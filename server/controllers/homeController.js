/**
 * @description
 * Home Controller
 */
'use strict';

const postingRepository = require('../repositories/postingRepository');
const SearchOption = require('../models/SearchOption');

module.exports.renderFrontPage = function renderFrontPage(req, res, next) {
  let model = req.model;
  const options = new SearchOption({
    user: req.user || {},
    query: req.query.query,
    page: req.query.page,
    limit: req.query.size
  });
  postingRepository.searchTopics(options, (err, searchResult) => {
    if(err) { return next(err); }
    model.searchResult = searchResult;
    model.options = options;
    model.csrfToken = req.csrfToken();
    res.render('index', model);
  });
};

module.exports.renderSearchPage = function renderSearchPage(req, res, next) {
  let model = req.model;
  let options = new SearchOption({
    query: req.query.query,
    page: req.query.page,
    limit: req.query.size
  });

  model.options = options;
  if(!options.query) {
    model.searchResult = { topics: [], totalCount: 0 };
    return res.render('search', model);
  }

  postingRepository.searchTopics(options, function(err, searchResult) {
    if(err) { return next(err); }
    model.searchResult = searchResult;
    res.render('search', model);
  });
};

module.exports.renderRulesPage = function renderRulesPage(req, res, next) {
  let model = req.model;
  model.meta.title = 'Palatuntunan sa Liham.ph';
  model.meta.description = 'Mga Palatuntunan para makapagsulat ng mga liham na iniwan';
  res.render('rules', model);
};

module.exports.renderAboutPage = function renderRulesPage(req, res, next) {
  let model = req.model;
  model.meta.title = 'Tungkol sa Liham.ph';
  model.meta.description = 'Tungkol sa Liham.ph';
  res.render('about', model);
};
