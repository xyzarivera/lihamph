/**
 * @description
 * Repository for core.person table
 */
'use strict';

const database = require('../config/database');
const Person = require('../models/Person');
const ResultSet = require('../models/ResultSet');
let client = database.get();

module.exports.findPersonById = function findPersonById(id, done) {
  client.func('core.find_person_by_id', [id])
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      let person = mapPerson(rows[0]);
      done(null, person);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.findPersonByUsername = function findPersonByUsername(username, done) {
  client.func('core.find_person_by_username', [username])
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      let person = mapPerson(rows[0]);
      done(null, person);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.register = function register(person, done) {
  let params = [person.username, person.hashedPassword];
  client.func('core.register_person', params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      let resultSet = new ResultSet(rows);
      done(null, resultSet);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.update = function update(person, done) {
  const params = [person.id, person.username, person.emailAddress, person.aboutMe];
  client.func('core.update_person', params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      const resultSet = new ResultSet(rows);
      done(null, resultSet);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.changePassword = function changePassword(person, done) {
  let params = [person.id, person.hashedPassword];
  client.func('core.change_password', params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      let resultSet = new ResultSet(rows);
      done(null, resultSet);
    })
    .catch(function(err) {
      done(err, null);
    });
};

function mapPerson(row) {
  if(!row) { return null; }
  return new Person({
    id: row['person_id'],
    username: row['username'],
    hashedPassword: row['hashed_password'],
    emailAddress: row['email_address'],
    aboutMe: row['about_me'],
    isModerator: row['is_moderator'],
    isEnabled: row['is_enabled'],
    createdDate: row['created_date'],
    lastUpdatedDate: row['last_updated_date']
  });
}
