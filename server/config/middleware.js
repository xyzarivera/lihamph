/**
 * @description
 * Express App configuration
 */
'use strict';

let express = require('express');
let morgan = require('morgan');
let cookieParser = require('cookie-parser');
let bodyParser = require('body-parser');
let session = require('express-session');
let cache = require('./cache');
let RedisStore = require('connect-redis')(session);
let passport = require('passport');
let csurf = require('csurf');
let helmet = require('helmet');
let flash = require('connect-flash');

module.exports = function(app, config) {
  app.set('views', config.middleware.views);
  app.set('view engine', 'pug');

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
        title: 'Kronowork',
        description: 'Lightweight, fast job postings for programmers',
        siteName: 'http://kronowork.com'
      },
      user: req.user
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
    res.status(403).render('error', req.model);
  }
};
