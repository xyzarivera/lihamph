/**
 * @description
 * Repository for core.person table
 */
'use strict';

const database = require('../config/database');
const Post = require('../models/Post');
const Topic = require('../models/Topic');
const ResultSet = require('../models/ResultSet');

let client = database.get();

module.exports.getPosting = function getPosting(id, done) {
  client.func('posting.get_posting', [id])
    .then(function(rows) {
      if(rows.length === 0) { return done(null, null); }

      let posts = rows.map(mapPost);
      let root = posts.find(function(p) { return !p.parentId; });

      posts = posts.filter(function(p) { return p.parentId > 0; });
      root.childrenCount = breadthFirstTree(root, posts, 0);
      done(null, root);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.searchTopics = function searchTopics(options, done) {
  let params = [options.query, options.limit, options.offset];
  client.func('posting.search_topics', params)
    .then(function(rows) {
      let searchResult = { topics: [], totalCount: 0 };
      if(rows.length > 0) {
        searchResult.topics = rows.map(mapTopic);
        searchResult.totalCount = Number(rows[0]['total_count']);
      }
      done(null, searchResult);
    })
    .catch(function(err) {
      done(err, null);
    });
};

module.exports.getPostById = function getPostById(id, done) {
  client.func('posting.get_post_by_id', [id])
    .then(function(rows) {
      if(rows.length === 0) { return(null, null); }
      let post = mapPost(rows[0]);
      done(null, post);
    })
    .catch(function(err) {
      done(err, null);
    });
};

////////////////////////////////////

module.exports.submitPost = function submitPost(post, done) {
  let params = [post.title, post.content, post.author.id];
  execResultSet('posting.submit_post', params, done);
};

module.exports.deletePosting = function deletePosting(topicId, done) {
  execResultSet('posting.delete_posting', [topicId], done);
};

module.exports.comment = function comment(post, done) {
  let params = [post.parentId, post.author.id, post.content];
  execResultSet('posting.post_comment', params, done);
};

module.exports.deleteComment = function deleteComment(postId, done) {
  execResultSet('posting.delete_comment', [postId], done);
};

module.exports.editPost = function editPost(post, done) {
  let params = [post.id, post.author.id, post.content];
  execResultSet('posting.edit_post', params, done);
};

////////////////////////////////////

function execResultSet(funcName, params, done) {
  client.func(funcName, params)
    .then(function(rows) {
      if(rows.length === 0) { return(null, null); }
      let resultSet = new ResultSet(rows);
      done(null, resultSet);
    })
    .catch(function(err) {
      done(err, null);
    });
}

function mapTopic(row) {
  if(!row) { return null; }
  return new Topic({
    id: row['topic_id'],
    title: row['title'],
    author: { id: row['author_id'], username: row['author_username'] },
    createdDate: row['created_date'],
    lastUpdatedDate: row['last_updated_date']
  });
}

function mapPost(row) {
  if(!row) { return null; }
  return new Post({
    id: row['post_id'],
    parentId: row['parent_post_id'],
    title: row['title'],
    author: { id: row['author_id'], username: row['author_username'] },
    content: row['content'],
    isEdited: row['is_edited'],
    isDeleted: row['is_deleted'],
    createdDate: row['created_date'],
    lastUpdatedDate: row['last_updated_date']
  });
}

function breadthFirstTree(root, list, count) {
  if(!root || !list) { return; }
  root.childPosts = list
    .filter(function(i) { return i.parentId === root.id })
    .sort(function oldestFirst(a, b) { return a.id > b.id; });
  count = root.childPosts.length;
  for(var i = 0; i < root.childPosts.length; ++i) {
    root.childPosts[i].childrenCount = breadthFirstTree(root.childPosts[i], list, 0);
    count += root.childPosts[i].childrenCount;
  }
  return count;
}
