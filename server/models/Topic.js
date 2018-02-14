/**
 * @description
 * Topic Class
 */
'use strict';

const Person = require('./Person');
const m = require('moment');

class Topic {
  constructor(data) {
    data = data || {};
    this.id = data.id;
    this.postId = data.postId;
    this.author = new Person(data.author);
    this.title = data.title;
    this.tags = data.tags;
    this.stats = {
      replies: data.replyCount,
      upvotes: data.upvoteCount
    };
    this.isUpvoted = data.isUpvoted;
    this.createdDate = m(data.createdDate);
    this.lastUpdatedDate = m(data.lastUpdatedDate);
  }

  static mapFromRow(row) {
    if(!row) { return null; }
    return new Topic({
      id: row['topic_id'],
      postId: row['post_id'],
      title: row['title'],
      tags: row['tags'],
      author: {
        id: row['author_id'],
        username: row['author_username']
      },
      replyCount: row['reply_count'],
      upvoteCount: row['upvote_count'],
      isUpvoted: row['is_upvoted'],
      createdDate: row['created_date'],
      lastUpdatedDate: row['last_updated_date']
    });
  }
}

module.exports = Topic;
