/**
 * @description
 * Tag.js
 */
'use strict';

class Tag {
  constructor(data = {}) {
    this.id = data.id;
    this.name = data.name;
    this.topicCount = Number(data.topicCount);
  }

  static mapFromRow(row) {
    if(!row) { return null; }

    return new Tag({
      id: row['tag_id'],
      name: row['tag_name'],
      topicCount: row['topic_count']
    });
  }
}

module.exports = Tag;
