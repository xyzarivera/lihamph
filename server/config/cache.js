/**
 * @description
 * Redis Client Wrapper
 */
'use strict';

let logger = require('./winston').get();
let redis = require('redis');
let client = null;

module.exports.init = function init(config, done) {
  logger.info('Initializing cache client...');
  client = redis.createClient({
    host: config.cache.host,
    port: config.cache.port,
    password: config.cache.password,
  });
  client.on('error', function(err) {
    logger.error('Redis error: ' + err);
  }).on('connect', function(e) {
    logger.info('Connected to redis: ' + config.cache.host);
  });

  test(done);
};

module.exports.get = function get() {
  return client;
};

//////////////////////////////////////

function test(done) {
  client.set('redis-connection', 'true', function(err) {
    if(err) {
      logger.error('Redis test connection failed: ' + err);
    } else {
      logger.info('Redis test connection success');
    }
    done();
  });
}
