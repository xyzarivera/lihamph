/**
 * @description
 * Passport configuration for Local Strategy
 */
'use strict';

const logger = require('./winston').get();
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const personRepository = require('../repositories/personRepository');
const Person = require('../models/Person');

module.exports = function(app, config) {
  logger.info('Configuring authentication middlewares...');

  passport.serializeUser(function(user, done) {
    done(null, user.username);
  });

  passport.deserializeUser(function(username, done) {
    personRepository.findPersonByUsername(username, function(err, person) {
      if(err) { return done(err, null); }
      done(null, person);
    });
  });

  passport.use('register', new LocalStrategy({
    usernameField: 'username',
    passwordField: 'password',
    passReqToCallback: true
  }, function register(req, username, password, done) {
    let person = new Person({ username: username });

    if(!person.isUsernameValid) {
      return done(null, null, { status: 'error', message: 'Invalid username' });
    }

    if(password.length < 8) {
      return done(null, null, { status: 'error', message: 'Password must be at least 8 characters' });
    }

    person.generateHashedPassword(password);
    personRepository.register(person, function(err, resultSet) {
      if(err) { return done(err, null); }

      if(resultSet.status !== 'success') {
        return done(null, null, resultSet);
      }

      personRepository.findPersonById(resultSet.id, function(err, person) {
        if(err) { return done(err, null); }

        done(null, person, resultSet);
      });
    });
  }));

  passport.use('login', new LocalStrategy({
    usernameField: 'username',
    passwordField: 'password',
    passReqToCallback: true
  }, function localLogin(req, username, password, done) {
    personRepository.findPersonByUsername(username, function(err, person) {
      if(err) { return done(err, null, { status: 'error', message: err.toString() }); }

      if(!person) {
        return done(null, null, { status: 'error', message: 'User does not exist' });
      }

      if(!person.isEnabled) {
        return done(null, person, { status: 'warning', message: 'Deactivated account' });
      }

      if(!person.validatePassword(password)) {
        return done(null, person, { status: 'warning', message: 'Incorrect username or password' });
      }

      done(null, person, { status: 'success', message: 'Successful login' });
    });
  }));
};
