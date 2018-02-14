/**
 * @description
 * Repository for core.person table
 */
'use strict';

const database = require('../config/database');
const Post = require('../models/Post');
const Topic = require('../models/Topic');
const SearchOption = require('../models/SearchOption'); // eslint-disable-line no-unused-vars
const ResultSet = require('../models/ResultSet');
const client = database.get();

/**
 * Gets the posting by topic ID
 * @param {Number} id
 * @param {function(Error, Post)} done
 */
module.exports.getPosting = function getPosting(id, done) {
  client.func('posting.get_posting', [id])
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }

      let posts = rows.map(Post.mapFromRow);
      let root = posts.find(function(p) { return !p.parentId; });

      posts = posts.filter(function(p) { return p.parentId > 0; });
      root.childrenCount = breadthFirstTree(root, posts, 0);
      done(null, root);
    })
    .catch(function(err) {
      done(err, null);
    });
};

/**
 * Gets the topic by ID
 * @param {Number} id
 * @param {function(Error, Topic)} done
 */
module.exports.getTopicById = function getTopicById(id, done) {
  const params = [id];
  client.func('posting.get_topic_by_id', params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }

      const topic = Topic.mapFromRow(rows[0]);
      done(null, topic);
    })
    .catch(function(err) {
      done(err, null);
    });
};

/**
 * Gets the post by ID
 * @param {Number} id
 * @param {function(Error, Post)} done
 */
module.exports.getPostById = function getPostById(id, done) {
  const params = [id];
  client.func('posting.get_post_by_id', params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }

      const post = Post.mapFromRow(rows[0]);
      done(null, post);
    })
    .catch(function(err) {
      done(err, null);
    });
};

/**
 * Searches the topics based on the query
 * @param {SearchOption} options
 * @param {function(Error, { topics: Topic[], totalCount: Number })} done
 */
module.exports.searchTopics = function searchTopics(options, done) {
  const params = [options.query, options.user.id, options.limit, options.offset];
  client.func('posting.search_topics', params)
    .then((rows) => {
      const searchResult = { topics: [], totalCount: 0 };
      if(rows.length > 0) {
        searchResult.topics = rows.map(Topic.mapFromRow);
        searchResult.totalCount = Number(rows[0]['total_count']);
      }
      done(null, searchResult);
    })
    .catch((err) => {
      done(err, null);
    });
};

/**
 * Gets the topics by the author. Pagination supported
 * @param {Person} author
 * @param {SearchOption} options
 * @param {function(Error, { topics: Topic[], totalCount: Number })} done
 */
module.exports.getTopicsByAuthorId = function getTopicsByAuthorId(author, options, done) {
  const params = [author.id, options.user.id, options.limit, options.offset];
  client.func('posting.get_topics_by_author_id', params)
    .then((rows) => {
      const searchResult = { topics: [], totalCount: 0 };
      if(rows.length > 0) {
        searchResult.topics = rows.map(Topic.mapFromRow);
        searchResult.totalCount = Number(rows[0]['total_count']);
      }
      done(null, searchResult);
    })
    .catch((err) => {
      done(err, null);
    });
};

/**
 * Gets the post by its ID
 * @param {number} id
 * @param {function(Error, Post)} done
 */
module.exports.getPostById = function getPostById(id, done) {
  client.func('posting.get_post_by_id', [id])
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      let post = Post.mapFromRow(rows[0]);
      done(null, post);
    })
    .catch(function(err) {
      done(err, null);
    });
};

////////////////////////////////////

/**
 * Creates a topic and a post
 * @param {Post} post
 * @param {function(Error, ResultSet)} done
 */
module.exports.submitPost = function submitPost(post, done) {
  const params = [post.title, post.content, post.author.id, post.tags];
  execResultSet('posting.submit_post', params, done);
};

/**
 * Deletes the posted topic
 * @param {Number} topicId
 * @param {function(Error, ResultSet)} done
 */
module.exports.deletePosting = function deletePosting(topicId, done) {
  const params = [topicId];
  execResultSet('posting.delete_posting', params, done);
};

/**
 * Comments to the parent post (can be a topic or a comment)
 * @param {Post} post
 * @param {function(Error, ResultSet)} done
 */
module.exports.comment = function comment(post, done) {
  const params = [post.parentId, post.author.id, post.content];
  execResultSet('posting.post_comment', params, done);
};

/**
 * Deletes the comment (post)
 * @param {Number} postId
 * @param {function(Error, ResultSet)} done
 */
module.exports.deleteComment = function deleteComment(postId, done) {
  execResultSet('posting.delete_comment', [postId], done);
};

module.exports.editPost = function editPost(post, done) {
  const params = [post.id, post.author.id, post.content];
  execResultSet('posting.edit_post', params, done);
};

module.exports.upvotePost = function upvotePost(post, user, done) {
  const params = [post.id, user.id];
  execResultSet('posting.upvote_post', params, done);
};

module.exports.undoUpvotePost = function undoUpvotePost(post, user, done) {
  const params = [post.id, user.id];
  execResultSet('posting.undo_upvote_post', params, done);
};

////////////////////////////////////

/**
 * Helper function for returning ResultSet object
 * @param {String} funcName
 * @param {Object[]} params
 * @param {function(Error, ResultSet)} done
 */
function execResultSet(funcName, params, done) {
  client.func(funcName, params)
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }
      const resultSet = new ResultSet(rows);
      done(null, resultSet);
    })
    .catch(function(err) {
      done(err, null);
    });
}

/**
 * Builds a tree based on the list
 * @param {Object} root
 * @param {Object[]} list
 * @param {Number} count
 */
function breadthFirstTree(root, list, count) {
  if(!root || !list) { return; }
  root.childPosts = list
    .filter(function(i) { return i.parentId === root.id; })
    .sort(function oldestFirst(a, b) { return a.id > b.id; });
  count = root.childPosts.length;
  for(var i = 0; i < root.childPosts.length; ++i) {
    root.childPosts[i].childrenCount = breadthFirstTree(root.childPosts[i], list, 0);
    count += root.childPosts[i].childrenCount;
  }
  return count;
}
