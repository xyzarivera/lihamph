/**
 * @description
 * Configuration JS files for environment configuration
 */
'use strict';

let path = require('path');
let rootPath = path.normalize(__dirname + '/../../');

module.exports = {
  development: {
    database: {
      connectionString: process.env.DESCOUVRE_DB
    },
    cache: {
      host: process.env.DESCOUVRE_CACHE_HOST,
      port: 6379,
      password: process.env.DESCOUVRE_CACHE_PASSWORD
    },
    session: {
      secret: process.env.DESCOUVRE_SESSION_SECRET,
      maxAge: 365 * 24 * 60 * 60 * 1000
    },
    middleware: {
      views: path.join(rootPath, 'server/views'),
      assets: path.join(rootPath, 'public')
    }
  }
};
