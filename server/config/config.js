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
      connectionString: process.env.LHM_POSTGRESQL
    },
    cache: {
      host: process.env.LHM_REDIS_HOST,
      port: 6379,
      password: process.env.LHM_REDIS_KEY
    },
    session: {
      secret: process.env.LHM_SESSION_SECRET,
      maxAge: 365 * 24 * 60 * 60 * 1000
    },
    middleware: {
      views: path.join(rootPath, 'server/views'),
      optimized: false,
      assets: path.join(rootPath, 'public'),
      verbose: true,
      cdn: {
        enabled: false,
        url: 'https://wanderast.azureedge.net/lihamnainiwan'
      }
    }
  },
  stage: {
    database: {
      connectionString: process.env.LHM_POSTGRESQL
    },
    cache: {
      host: process.env.LHM_REDIS_HOST,
      port: 6379,
      password: process.env.LHM_REDIS_KEY
    },
    session: {
      secret: process.env.LHM_SESSION_SECRET,
      maxAge: 365 * 24 * 60 * 60 * 1000
    },
    middleware: {
      views: path.join(rootPath, 'server/views'),
      optimized: true,
      assets: path.join(rootPath, 'public'),
      verbose: true,
      cdn: {
        enabled: true,
        url: 'https://wanderast.azureedge.net/lihamnainiwan'
      }
    }
  },
  prod: {
    database: {
      connectionString: process.env.LHM_POSTGRESQL
    },
    cache: {
      host: process.env.LHM_REDIS_HOST,
      port: 6379,
      password: process.env.LHM_REDIS_KEY
    },
    session: {
      secret: process.env.LHM_SESSION_SECRET,
      maxAge: 365 * 24 * 60 * 60 * 1000
    },
    middleware: {
      views: path.join(rootPath, 'server/views'),
      optimized: true,
      assets: path.join(rootPath, 'public'),
      verbose: false,
      cdn: {
        enabled: true,
        url: 'https://wanderast.azureedge.net/lihamnainiwan'
      }
    }
  }
};
