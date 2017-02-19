/**
 * @description
 * Topic Class
 */
'use strict';

let Person = require('./Person');
let m = require('moment');

class Topic {
  constructor(data) {
    let self = this;
    data = data || {};
    self.id = data.id;
    self.author = new Person(data.author);
    self.title = data.title;
    self.createdDate = m(data.createdDate);
    self.lastUpdatedDate = m(data.lastUpdatedDate);
  }
}

module.exports = Topic;
