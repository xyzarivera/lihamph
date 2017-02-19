/**
 * @description
 * Postgresql Database Wrapper
 */
'use strict';

const logger = require('./winston').get();
let database = null;

module.exports.init = function init(config, done) {
  logger.info('Initializing database client...');
  let pgp = require('pg-promise')({
    error: function(err, e) {
      if(e.cn) {
        logger.error('Error while connecting to the database: ' + err);
      }
    }
  });
  database = pgp(config.database.connectionString);
  test(done);
};

module.exports.get = function get() {
  return database;
};

/////////////////////////

function test(done) {
  database.query('select 1')
    .then(function() {
      logger.info('Database test connection success');
      done();
    })
    .catch(function(err) {
      logger.error('Database test connection failed: ' + err);
      done();
    });
}
