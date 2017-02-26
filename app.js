/**
 * @description
 * Application Entry Point
 */
'use strict';

let express = require('express');
let app = express();
let env = process.env.NODE_ENV || 'development';
let config = require('./server/config/config')[env];

let winston = require('./server/config/winston');
winston.init();
let logger = winston.get();

let http = require('http').Server(app);
let database = require('./server/config/database');
let cache = require('./server/config/cache');

process.on('uncaughtException', function(err) {
  console.error(err);
});

if(!config) {
  logger.error('Unknown environment config: ' + env);
  process.exit(-1);
}
logger.info('Setting up environment for: ' + env);

const port = config.port || 6500;

database.init(config, function() {
  cache.init(config, function() {
    require('./server/config/middleware')(app, config);
    require('./server/config/authentication')(app, config);
    require('./server/config/routes')(app, config);
    http.listen(port, function() {
      console.log('App listening to port: ' + port);
    });
  });
});
