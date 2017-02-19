/**
 * @description
 * Custom Logger Wrapper using Winston
 */
'use strict';

let winston = require('winston');
let m = require('moment');
let logger = null;

module.exports.init = function init() {
  const dateFormat = 'dddd, MMMM Do YYYY, h:mm:ss a';

  logger = new (winston.Logger)({
    transports: [
      new (winston.transports.Console)({
        name: 'info-console',
        level: 'info',
        colorize: true,
        timestamp: function() { return m.utc().format(dateFormat); }
      }),
      new (winston.transports.Console)({
        name: 'error-console',
        level: 'error',
        colorize: true,
        timestamp: function() { return m.utc().format(dateFormat); }
      })
    ]
  });
  logger.info('Started logging service...');
};

module.exports.get = function get() {
  return logger;
};
