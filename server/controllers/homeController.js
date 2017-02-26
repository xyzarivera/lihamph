/**
 * @description
 * Home Controller
 */
'use strict';

const postingRepository = require('../repositories/postingRepository');
const SearchOption = require('../models/SearchOption');

module.exports.renderFrontPage = function renderFrontPage(req, res, next) {
  let model = req.model;
  let options = new SearchOption({
    query: req.query.query,
    page: req.query.page,
    limit: req.query.size
  });
  postingRepository.searchTopics(options, function(err, searchResult) {
    if(err) { return next(err); }
    model.searchResult = searchResult;
    model.options = options;
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
  model.meta.title = 'Kronowork - Rules';
  model.meta.description = 'Rules and regulations in Kronowork';
  res.render('rules', model);
};
