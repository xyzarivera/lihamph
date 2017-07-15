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
    model.meta.title = person.username;
    model.meta.description = person.aboutMe || person.username;
    res.render('profile', model);
  });
};

module.exports.renderSettingsPage = function renderSettingsPage(req, res, next) {
  let model = req.model;

  personRepository.findPersonById(req.user.id, (err, person) => {
    if(err) { return next(err); }

    if(!person) {
      model.message = 'Ang sagisag ay hindi matagpuan';
      return res.status(404).render('notfound', model);
    }

    model.profile = person;
    model.updateProfileStatus = req.flash('updateProfile');
    model.changePasswordStatus = req.flash('changePassword');
    model.csrfToken = req.csrfToken();
    model.meta.title = person.username;
    model.meta.description = person.aboutMe || person.username;
    res.render('settings', model);
  });
};

module.exports.updateProfile = function updateProfile(req, res, next) {
  const updatedPerson = new Person({
    id: req.user.id,
    username: req.body.username,
    emailAddress: req.body.emailAddress,
    aboutMe: req.body.aboutMe
  });

  if(!updatedPerson.username || !updatedPerson.isUsernameValid) {
    req.flash('updateProfile',
      { status: 'warning', message: 'Hindi maari ang iyong napiling sagisag' });
    return res.redirect('/user/settings');
  }

  personRepository.update(updatedPerson, (err, resultSet) => {
    if(err) { return next(err); }

    req.flash('updateProfile', resultSet);
    res.redirect('/user/settings');
  });
};

module.exports.changePassword = function changePassword(req, res, next) {
  const person = new Person(req.user);
  const currentPassword = req.body.currentPassword;
  const newPassword = req.body.newPassword;

  if(!currentPassword || !newPassword) {
    req.flash('changePassword',
      { status: 'warning', message: 'Mali ang mga lihim na salita' });
    return res.redirect('/user/settings');
  }

  if(newPassword.length < 8) {
    req.flash('changePassword',
      { status: 'warning', message: 'Ang bagong lihim na salita ay nararapat na mahigit sa 8 titik' });
    return res.redirect('/user/settings');
  }

  if(!person.validatePassword(currentPassword)) {
    req.flash('changePassword',
      { status: 'warning', message: 'Mali ang iyong lumang lihim na salita' });
    return res.redirect('/user/settings');
  }

  person.generateHashedPassword(newPassword);
  personRepository.changePassword(person, (err, resultSet) => {
    if(err) { return next(err); }

    req.flash('changePassword', resultSet);
    res.redirect('/user/settings');
  });
};
