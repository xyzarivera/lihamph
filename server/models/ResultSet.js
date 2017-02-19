/**
 * @description
 * Result Set Class
 */
'use strict';

class ResultSet {
  constructor(rows) {
    let self = this;
    if(rows[0].id) {
      self.id = rows[0].id;
    }
    self.status = rows[0]['status'];
    self.message = rows[0]['message'];
  }
}

module.exports = ResultSet;
