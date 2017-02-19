/**
 * @description
 * Home Controller
 */
'use strict';

const personRepository = require('../repositories/personRepository');
const Person = require('../models/Person');

module.exports.renderProfilePage = function renderProfilePage(req, res, next) {
  let username = req.params.username;
  let model = req.model;

  personRepository.findPersonByUsername(username, function(err, person) {
    if(err) { return next(err); }

    if(!person) {
      model.message = 'User not found';
      return res.render('notfound', model);
    }

    model.profile = person;
    model.isEditMode = req.isAuthenticated() && person.id === req.user.id;

    model.updateProfileStatus = req.flash('updateProfile');
    model.changePasswordStatus = req.flash('changePassword');
    model.csrfToken = req.csrfToken();
    model.meta.title = person.username;
    model.meta.description = person.aboutMe || person.username;
    res.render('profile', model);
  });
};

module.exports.updateProfile = function updateProfile(req, res, next) {
  let username = req.params.username;
  let user = req.user;
  let updatedPerson = new Person({
    id: null,
    username: req.body.username,
    emailAddress: req.body.emailAddress,
    aboutMe: req.body.aboutMe
  });

  if(!updatedPerson.username || !updatedPerson.isUsernameValid) {
    req.flash('updateProfile', { status: 'warning', message: 'Invalid username' });
    return res.redirect('/user/' + username);
  }

  personRepository.findPersonByUsername(username, function(err, person) {
    if(err) { return next(err); }
    updatedPerson.id = person.id;

    personRepository.update(updatedPerson, function(err, resultSet) {
      if(err) { return next(err); }

      req.flash('updateProfile', resultSet);
      if(resultSet !== 'success') { return res.redirect('/user/' + username); }

      res.redirect('/user/' + updatedPerson.username);
    });
  });
};

module.exports.changePassword = function changePassword(req, res, next) {
  let username = req.params.username;
  let user = req.user;
  let currentPassword = req.body.currentPassword;
  let newPassword = req.body.newPassword;

  if(!currentPassword || !newPassword) {
    req.flash('changePassword', { status: 'warning', message: 'Invalid passwords' });
    return res.redirect('/user/' + username);
  }

  if(newPassword.length < 8) {
    req.flash('changePassword', { status: 'warning', message: 'New password must be greater than 8 characters' });
    return res.redirect('/user/' + username);
  }

  personRepository.findPersonByUsername(username, function(err, person) {
    if(err) { return next(err); }

    if(user.id !== person.id) {
      req.flash('changePassword',
        { status: 'error', message: 'Cannot update someone\'s password' });
      return res.redirect('/user/' + username);
    }

    if(!person.validatePassword(currentPassword)) {
      req.flash('changePassword',
        { status: 'warning', message: 'Incorrect current password' });
      return res.redirect('/user/' + username);
    }

    person.generateHashedPassword(newPassword);
    personRepository.changePassword(person, function(err, resultSet) {
      if(err) { return next(err); }

      req.flash('changePassword', resultSet);
      res.redirect('/user/' + person.username);
    });
  });
};
