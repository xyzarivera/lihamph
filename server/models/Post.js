/**
 * @description
 * Post Class
 */
'use strict';

const Person = require('./Person');
const m = require('moment');
const marked = require('marked');
const cheerio = require('cheerio');

marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: false,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: false,
  smartypants: false
});

class Post {
  constructor(data) {
    data = data || {};
    this.id = data.id;
    this.parentId = data.parentId;
    this.author = new Person(data.author);
    this.title = data.title;
    this.content = data.content;
    this.tags = data.tags;
    this.stats = {
      replies: data.replyCount,
      upvotes: data.upvoteCount
    };
    this.isEdited = Boolean(data.isEdited);
    this.isDeleted = Boolean(data.isDeleted);
    this.createdDate = m(data.createdDate);
    this.lastUpdatedDate = m(data.lastUpdatedDate);

    this.childPosts = [];
  }

  addChildPost(post) {
    return this;
  }

  get marked() {
    return marked(this.content, { sanitize: true, breaks: true });
  }

  static mapFromRow(row) {
    if(!row) { return null; }
    return new Post({
      id: row['post_id'],
      parentId: row['parent_post_id'],
      title: row['title'],
      author: { id: row['author_id'], username: row['author_username'] },
      replyCount: row['reply_count'],
      upvoteCount: row['upvote_count'],
      content: row['content'],
      tags: row['tags'],
      isEdited: row['is_edited'],
      isDeleted: row['is_deleted'],
      createdDate: row['created_date'],
      lastUpdatedDate: row['last_updated_date']
    });
  }

  /**
   * Removes the <script> tags from the text
   * @param {string} content
   */
  static removeScripts(content) {
    //- Best solution yet so far
    const node = cheerio.load('<div id="postedContent">' + content + '</div>');
    const text = node('#postedContent').remove('script').text();
    return text;
  }
}

module.exports = Post;
