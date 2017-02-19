/**
 * @description
 * Account Controller
 */
'use strict';

const Person = require('../models/Person');
const passport = require('passport');

module.exports.renderRegisterPage = function renderRegisterPage(req, res, next) {
  let model = req.model;
  model.alert = req.flash('register');
  model.csrfToken = req.csrfToken();
  model.meta.title = 'Register';
  model.meta.description = 'Register for Kronowork';
  res.render('register', model);
};

module.exports.renderLoginPage = function renderLoginPage(req, res, next) {
  let model = req.model;
  model.alert = req.flash('login');
  model.csrfToken = req.csrfToken();
  model.meta.title = 'Login';
  model.meta.description = 'Log in to Kronowork';
  res.render('login', model);
};

module.exports.login = function login(req, res, next) {
  passport.authenticate('login', function(err, person, info) {
    if(err) { return next(err); }

    if(!person) {
      req.flash('login', info);
      return res.redirect('/login');
    }

    if(info.status !== 'success') {
      req.flash('login', info);
      return res.redirect('/login');
    }

    req.logIn(person, function(err) {
      if(err) { return next(err); }
      res.redirect('/');
    });
  })(req, res, next);
};

module.exports.register = function register(req, res, next) {
  passport.authenticate('register', function(err, person, info) {
    if(err) { return next(err); }

    if(!person) {
      req.flash('register', info);
      return res.redirect('/register');
    }

    req.logIn(person, function(err) {
      if(err) { return next(err); }
      res.redirect('/');
    });
  })(req, res, next);
};

module.exports.disallowAuthenticatedUsers = function disallowAuthenticatedUsers(req, res, next) {
  if(req.isAuthenticated()) {
    return res.redirect('/');
  }
  next();
};

module.exports.logout = function logout(req, res, next) {
  let timer = null;
  req.logout();
  req.session.destroy(function(err) {
    if(err) { return next(err); }
    function waitUntilLoggedOut() {
      if (!req.isAuthenticated()) {
        return res.redirect('/');
      }
      clearTimeout(timer);
      timer = setTimeout(waitUntilLoggedOut, 500);
    }
    waitUntilLoggedOut();
  });
};
