/**
 * @description
 * Posting Controller
 */
'use strict';

const postingRepository = require('../repositories/postingRepository');
const Post = require('../models/Post');

module.exports.renderSubmitPage = function renderSubmitPage(req, res, next) {
  let model = req.model;

  model.submitPostStatus = req.flash('submitPost');
  model.csrfToken = req.csrfToken();
  res.render('submit', model);
};

module.exports.renderPostingPage = function renderPostingPage(req, res, next) {
  let id = req.params.topicId;
  let model = req.model;

  postingRepository.getPosting(id, function(err, rootPost) {
    if(err) { return next(err); }

    if(!rootPost) {
      model.message = 'Posting not found';
      return res.status(404).render('notfound', model);
    }

    model.rootPost = rootPost;
    model.topicId = id;
    model.csrfToken = req.csrfToken();
    model.commentStatus = req.flash('comment');
    model.meta.title = rootPost.title;
    model.meta.description = rootPost.content.slice(0, 120);
    res.render('posting', model);
  });
};

module.exports.submitPost = function submitPost(req, res, next) {
  let user = req.user;
  let post = new Post({
    title: req.body.title,
    content: req.body.content,
    author: { id: user.id, username: user.username }
  });

  if(!post.title || !post.content) {
    req.flash('submitPost', { status: 'error', message: 'Empty title or content' });
    return res.redirect('/submit');
  }

  postingRepository.submitPost(post, function(err, resultSet) {
    if(err) { return next(err); }

    if(resultSet.status !== 'success') {
      req.flash('submitPost', resultSet);
      return res.redirect('/submit');
    }

    res.redirect('/posting/' + resultSet.id);
  });
};

module.exports.deletePosting = function deletePosting(req, res, next) {
  let topicId = req.params.topicId;
  let user = req.user;
  if(!user.isModerator) {
    return res.status(403).send({ status: 'error', message: 'Forbidden to delete posting' });
  }

  postingRepository.deletePosting(topicId, function(err, resultSet) {
    if(err) { return res.status(500).send({ status: 'error', message: 'Cannot delete posting' }); }
    if(resultSet.status !== 'success') {
      return res.status(400).send(resultSet);
    }
    res.status(200).send(resultSet);
  });
};

module.exports.renderCommentPage = function renderCommentPage(req, res, next) {
  let postId = req.params.postId;
  let model = req.model;
  postingRepository.getPostById(postId, function(err, post) {
    if(err) { return next(err); }

    model.meta.title = 'Comment on ' + post.title;
    model.csrfToken = req.csrfToken();
    model.post = post;
    res.render('comment', model);
  });
};

module.exports.comment = function comment(req, res, next) {
  let topicId = req.body.topicId;

  let post = new Post({
    parentId: req.params.postId,
    content: req.body.comment,
    author: req.user
  });

  postingRepository.comment(post, function(err, resultSet) {
    if(err) { return next(err); }

    if(resultSet.status !== 'success') {
      req.flash('comment', resultSet);
    }
    return res.redirect('/posting/' + topicId + '#post' + resultSet.id);
  });
};

module.exports.deleteComment = function deleteComment(req, res, next) {
  let topicId = req.body.topicId;
  let postId = req.params.postId;

  postingRepository.deleteComment(postId, function(err, resultSet) {
    if(err) { return next(err); }
    return res.status(200).send(resultSet);
  });
};

module.exports.renderEditPostPage = function renderEditPostPage(req, res, next) {
  let postId = req.params.postId;
  let model = req.model;
  postingRepository.getPostById(postId, function(err, post) {
    if(err) { return next(err); }

    model.meta.title = 'Edit post on ' + post.title;
    model.csrfToken = req.csrfToken();
    model.topicId = req.query.topicId;
    model.editPostStatus = req.flash('editPost');
    model.post = post;
    res.render('edit', model);
  });
};

module.exports.editPost = function editPost(req, res, next) {
  let topicId = req.body.topicId;
  let post = new Post({
    id: req.params.postId,
    content: req.body.content,
    author: req.user
  });

  postingRepository.editPost(post, function(err, resultSet) {
    if(err) { return next(err); }

    if(resultSet.status !== 'success') {
      req.flash('editPost', resultSet);
    }
    res.redirect('/posting/' + topicId);
  });
};
