/**
 * @description
 * tagController.js
 */
'use strict';

const SearchOption = require('../models/SearchOption');
const postingRepository = require('../repositories/postingRepository');

module.exports.renderTagPage = function renderTagPage(req, res, next) {
  let model = req.model;
  const options = new SearchOption({
    user: req.user || {},
    query: req.query.query,
    page: req.query.page,
    limit: req.query.size
  });

  const tagName = req.params.tagName;

  postingRepository.getTagByName(tagName, (err, tag) => {
    if(err) { return next(err); }

    if(!tag) {
      model.meta.title = model.title = 'Ang Pananda ay hindi makita';
      model.meta.description = model.message = 'Ang pananda na iyong hinahanap ay hindi namin mahanap.';
      return res.status(404).render('errors/notfound', model);
    }

    postingRepository.getTopicsByTagName(tag, options, (err, searchResult) => {
      if(err) { return next(err); }

      model.tag = tag;
      model.searchResult = searchResult;
      model.options = options;
      model.csrfToken = req.csrfToken();
      res.render('tag', model);
    });
  });
};
