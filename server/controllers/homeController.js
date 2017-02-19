/**
 * @description
 * Home Controller
 */
'use strict';

const postingRepository = require('../repositories/postingRepository');

module.exports.renderFrontPage = function renderFrontPage(req, res, next) {
  let model = req.model;
  postingRepository.searchTopics(function(err, topics) {
    if(err) { return next(err); }
    model.topics = topics;
    res.render('index', model);
  });
};

module.exports.renderRulesPage = function renderRulesPage(req, res, next) {
  let model = req.model;
  model.meta.title = 'Kronowork - Rules';
  model.meta.description = 'Rules and regulations in Kronowork';
  res.render('rules', model);
};
