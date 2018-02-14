/**
 * @description
 * SearchOption class
 */
'use strict';

const Person = require('./Person');
const pos = require('pos');

/**
 * @description
 * SearchOption Constructor
 * @param {object} options
 */
class SearchOption {
  /**
   * Constructor for Search Option
   * @param {object} options
   */
  constructor(options) {
    let self = this;
    options = options || {};
    self.query = trimIfNotNull(options.query);
    self.sort = trimIfNotNull(options.sort);
    self.range = trimIfNotNull(options.range);
    self.page = Number(options.page || 1);
    self.limit = Number(options.limit || 10);
    self.user = new Person(options.user);
    self.ignoreEmptyQuery = false;
    if(!self.page || self.page <= 0) { self.page = 1; }
  }

  /**
   * @description
   * Returns the query offset. Default value is 0
   * @return {number}
   */
  get offset() {
    let self = this;
    if(self.limit && self.page) {
      return (self.page - 1) * self.limit;
    }
    return 0;
  }

  /**
   * @description
   * Returns a valid TSQuery string
   * @return {string}
   */
  get formattedTsQuery() {
    let self = this;
    const query = self.splitQuery();
    const words = new pos.Lexer().lex(query.term);
    const tagger = new pos.Tagger();
    const invalidTags = ['DT', 'CC', 'PRP', 'SYM', 'TO', 'UH', ',', '.', ':',
      '$', '#', '"', '(', ')', '!' , ';', '"', '\\'];
    const tsquery = tagger.tag(words)
      .map(element => { return { word: element[0].replace(/[^0-9a-zA-Z-]/g, ''), tag: element[1] }; })
      .filter(item => invalidTags.indexOf(item.tag) < 0 && item.word.length > 0)
      .map(i => i.word)
      .join(' & ');
    return tsquery;
  }

  /**
   * @description
   * Get total pages based on the total count
   */
  getTotalPages(totalCount) {
    return Math.ceil(totalCount / this.limit);
  }

  /**
   * @description
   * Splits the query into term and the intended filters splitted by colon ":"
   * @returns {object} query ({ term, filter1, filter2, ... })
   */
  splitQuery() {
    let self = this;
    let query = { term: self.query };
    const regex = /[A-Za-z0-9]+:[\w]+/g;
    const matches = self.query.match(regex);

    if(matches) {
      for(let i = 0; i < matches.length; ++i) {
        const dividedParam = matches[i].split(':');
        query[dividedParam[0]] = dividedParam[1];
      }
      query.term = self.query.replace(regex, '').trim();
    }
    return query;
  }
}

/**
 * @description
 * Helper function for the SearchOption constructor
 * @param {string} val
 * @return {string}
 */
function trimIfNotNull(val) {
  return (val || '').trim();
}

module.exports = SearchOption;
