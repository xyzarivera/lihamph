/**
 * @description
 * Express App configuration
 */
'use strict';

const express = require('express');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const session = require('express-session');
const cache = require('./cache');
const RedisStore = require('connect-redis')(session);
const passport = require('passport');
const csurf = require('csurf');
const helmet = require('helmet');
const flash = require('connect-flash');

module.exports = function(app, config) {
  app.set('views', config.middleware.views);
  app.set('view engine', 'pug');
  app.set('view cache', config.middleware.optimized);
  app.locals.pretty = config.middleware.optimized;

  app.use(bodyParser.urlencoded({ extended: true, limit: '5mb' }));
  app.use(bodyParser.json({ limit: '5mb' }));
  app.use(helmet());
  app.use(express.static(config.middleware.assets));
  app.use(cookieParser());
  app.use(session({
    secret: config.session.secret,
    store: new RedisStore({ client: cache.get() }),
    resave: false,
    cookie: { maxAge: config.session.maxAge },
    saveUninitialized: true
  }));
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(flash());
  app.use(morgan('combined'));
  app.use(initializeModel);
  app.use(csurf({ cookie: true }));
  app.use(csurfError);

  function initializeModel(req, res, next) {
    const baseUrl = req.protocol + '://' + req.get('host');
    req.model = {
      meta: {
        url: baseUrl +  req.originalUrl,
        type: 'website',
        title: 'Mga Liham na Iniwan',
        description: 'Mga Liham na Iniwan - Isang lugar para mga katha ng mga makata',
        siteName: 'http://lihamnainiwan.com'
      },
      user: req.user,
      verbose: config.middleware.verbose,
      cdn: config.middleware.cdn,
      utils: {
        //- TODO: Improve performance
        convertFromNowToFilipino(dt) {
          return dt.replace('hours ago', 'oras ang nakalipas')
            .replace('a few seconds ago', 'makalipas ang ilang segundo')
            .replace('a minute ago', 'makalipas ang isang minuto')
            .replace('minutes ago', 'minuto ang nakalipas')
            .replace('a day ago', 'isang araw ang nakalipas')
            .replace('days ago', 'araw ang nakalipas')
            .replace('a month ago', 'isang buwan ang nakalipas')
            .replace('months ago', 'buwan ang nakalipas')
            .replace('a year ago', 'isang taon ang nakalipas')
            .replace('years ago', 'taon ang nakalipas');
        }
      }
    };

    next();
  }

  function csurfError(err, req, res, next) {
    //if not csrf err, do next
    if(err.code !== 'EBADCSRFTOKEN') { return next(err); }

    // handle CSRF token errors here
    req.model.title = 'Forbidden';
    req.model.message = 'Your submitted form has been tampered';

    if(req.headers.accept === 'application/json') {
      return res.status(403).send({ status: 'error', message: 'Forbidden' });
    }
    res.status(403).render('errors/error', req.model);
  }
};
