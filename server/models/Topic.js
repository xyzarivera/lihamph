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

  static mapFromRow(row) {
    if(!row) { return null; }
    return new Topic({
      id: row['topic_id'],
      title: row['title'],
      author: { id: row['author_id'], username: row['author_username'] },
      createdDate: row['created_date'],
      lastUpdatedDate: row['last_updated_date']
    });
  }
}

module.exports = Topic;
