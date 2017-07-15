/**
 * @description
 * Post Class
 */
'use strict';

let Person = require('./Person');
let m = require('moment');
const marked = require('marked');

marked.setOptions({
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
    let self = this;
    data = data || {};
    self.id = data.id;
    self.parentId = data.parentId;
    self.author = new Person(data.author);
    self.title = data.title;
    self.content = data.content;
    self.isEdited = Boolean(data.isEdited);
    self.isDeleted = Boolean(data.isDeleted);
    self.createdDate = m(data.createdDate);
    self.lastUpdatedDate = m(data.lastUpdatedDate);

    self.childPosts = [];
  }

  addChildPost(post) {
    return this;
  }

  get marked() {
    return marked(this.content);
  }

  static mapFromRow(row) {
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

}

module.exports = Post;
