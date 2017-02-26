/**
 * @description
 * SearchOption class
 */
'use strict';

const Person = require('./Person');

/**
 * @description
 * SearchOption Constructor
 * @param {object} options
 */
class SearchOption {
  constructor(options) {
    let self = this;
    options = options || {};
    self.query = (options.query || '').trim();
    self.sort = (options.sort || '').trim();
    self.dateRange = null;
    if(self.sort === 'top') {
      self.dateRange = (options.dateRange || '').trim();
    }

    self.page = Number.parseInt(options.page || 1);
    self.limit = Number.parseInt(options.limit || 10);
    self.user = new Person(options.user);
    self.offset = 0;
    if(!self.page || self.page <= 0) { self.page = 1; }
    if(self.limit && self.page) {
      self.offset = (self.page - 1) * self.limit;
    }
  }

  /**
   * @description
   * Splits the query into term and the intended filters splitted by colon ":"
   * @returns {object} query ({ term, filter1, filter2, ... })
   */
  splitQuery() {
    let self = this;
    let query = { term: self.query };
    let regex = /[a-z]+:[\w]+/g;
    let matches = self.query.match(regex);

    if(matches) {
      for(let i = 0; i < matches.length; ++i) {
        let dividedParam = matches[i].split(':');
        query[dividedParam[0]] = dividedParam[1];
      }
      query.term = self.query.replace(regex, '').trim();
    }
    return query;
  }
}

module.exports = SearchOption;
