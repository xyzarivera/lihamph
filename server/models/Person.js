/**
 * @description
 * Person Class
 */
'use strict';

const m = require('moment');
const bcrypt = require('bcrypt-nodejs');

class Person {
  constructor(data) {
    let self = this;
    data = data || {};
    self.id = data.id;
    self.username = data.username;
    self.emailAddress = data.emailAddress;
    self.hashedPassword = data.hashedPassword;
    self.aboutMe = data.aboutMe;
    self.isModerator = Boolean(data.isModerator);
    self.isEnabled = Boolean(data.isEnabled);
    self.createdDate = m(data.createdDate);
    self.lastUpdatedDate = m(data.lastUpdatedDate);
  }

  get isUsernameValid() {
    const forbiddenUsernames = [
      'settings', 'admin', 'invite', 'liham', 'lihamph'
    ];
    if(!this.username) {
      return false;
    }
    if(forbiddenUsernames.indexOf(this.username) >= 0) {
      return false;
    }
    if(this.username.length >= 20) {
      return false;
    }
    const result = /[A-Za-z0-9._]+/.exec(this.username);
    return result[0] === result.input;
  }

  validatePassword(password) {
    return bcrypt.compareSync(password, this.hashedPassword);
  }

  generateHashedPassword(password) {
    let salt = bcrypt.genSaltSync(8);
    this.hashedPassword = bcrypt.hashSync(password, salt);
    return Boolean(this.hashedPassword);
  }
}

module.exports = Person;
