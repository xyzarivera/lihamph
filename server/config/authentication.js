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

module.exports = (app, config) => {
  logger.info('Configuring authentication middlewares...');

  passport.serializeUser((user, done) => {
    done(null, user.username);
  });

  passport.deserializeUser((username, done) => {
    personRepository.findPersonByUsername(username, (err, person) => {
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
      return done(null, null,
        { status: 'error', message: 'Hindi maari ang iyong piniling sagisag' });
    }

    if(password.length < 8) {
      return done(null, null,
        { status: 'error', message: 'Ang lihim na salita ay dapat mahigit sa 8 titik' });
    }

    person.generateHashedPassword(password);
    personRepository.register(person, (err, resultSet) => {
      if(err) { return done(err, null); }

      if(resultSet.status !== 'success') {
        return done(null, null, resultSet);
      }

      personRepository.findPersonById(resultSet.id, (err, person) => {
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
    personRepository.findPersonByUsername(username, (err, person) => {
      if(err) {
        return done(err, null,
          { status: 'error', message: 'Paumanhin. Nagkaroon ng problema sa liham.ph' });
      }

      if(!person) {
        return done(null, null,
          { status: 'error', message: 'Ang sagisag na ito ay hindi kasapi ng liham.ph' });
      }

      if(!person.isEnabled) {
        return done(null, person,
          { status: 'warning', message: 'Ang sagisag na ito ay hindi na magagamit pa' });
      }

      if(!person.validatePassword(password)) {
        return done(null, person,
          { status: 'warning', message: 'Mali ang sagisag o ang iyong liham na salita' });
      }

      done(null, person, { status: 'success', message: 'Sa wakas!' });
    });
  }));
};
