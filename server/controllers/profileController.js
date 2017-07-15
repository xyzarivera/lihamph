/**
 * @description
 * Home Controller
 */
'use strict';

const personRepository = require('../repositories/personRepository');
const Person = require('../models/Person');

module.exports.renderProfilePage = function renderProfilePage(req, res, next) {
  const username = req.params.username;
  let model = req.model;

  personRepository.findPersonByUsername(username, (err, person) => {
    if(err) { return next(err); }

    if(!person) {
      model.message = 'Ang sagisag ay hindi matagpuan';
      return res.status(404).render('notfound', model);
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
  const username = req.params.username;
  let updatedPerson = new Person({
    id: null,
    username: req.body.username,
    emailAddress: req.body.emailAddress,
    aboutMe: req.body.aboutMe
  });

  if(!updatedPerson.username || !updatedPerson.isUsernameValid) {
    req.flash('updateProfile', { status: 'warning', message: 'Maling sagisag' });
    return res.redirect('/user/' + username);
  }

  personRepository.findPersonByUsername(username, (err, person) => {
    if(err) { return next(err); }

    if(!person) {
      req.flash('updateProfile', { status: 'warning', message: 'Ang sagisag ay hindi matagpuan' });
      return res.redirect('/user/' + username);
    }

    updatedPerson.id = person.id;

    personRepository.update(updatedPerson, (err, resultSet) => {
      if(err) { return next(err); }

      req.flash('updateProfile', resultSet);
      if(resultSet !== 'success') {
        return res.redirect('/user/' + username);
      }

      res.redirect('/user/' + updatedPerson.username);
    });
  });
};

module.exports.changePassword = function changePassword(req, res, next) {
  const username = req.params.username;
  const user = req.user;
  const currentPassword = req.body.currentPassword;
  const newPassword = req.body.newPassword;

  if(!currentPassword || !newPassword) {
    req.flash('changePassword',
      { status: 'warning', message: 'Mali ang mga lihim na salita' });
    return res.redirect('/user/' + username);
  }

  if(newPassword.length < 8) {
    req.flash('changePassword',
      { status: 'warning', message: 'Ang bagong lihim na salita ay nararapat na mahigit sa 8 titik' });
    return res.redirect('/user/' + username);
  }

  personRepository.findPersonByUsername(username, (err, person) => {
    if(err) { return next(err); }

    if(user.id !== person.id) {
      req.flash('changePassword',
        { status: 'error', message: 'Hindi ka maaring magbago ng lihim ng iba!' });
      return res.redirect('/user/' + username);
    }

    if(!person.validatePassword(currentPassword)) {
      req.flash('changePassword',
        { status: 'warning', message: 'Mali ang iyong lumang lihim na salita' });
      return res.redirect('/user/' + username);
    }

    person.generateHashedPassword(newPassword);
    personRepository.changePassword(person, (err, resultSet) => {
      if(err) { return next(err); }

      req.flash('changePassword', resultSet);
      res.redirect('/user/' + person.username);
    });
  });
};
