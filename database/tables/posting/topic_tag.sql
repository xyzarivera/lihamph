CREATE TABLE posting.topic_tag (
  topic_id BIGINT NOT NULL,
  tag_id INT NOT NULL,
  CONSTRAINT tag_topic_tag_id_topic_id_pkey PRIMARY KEY (tag_id, topic_id),
  CONSTRAINT tag_topic_tag_id_fkey FOREIGN KEY (tag_id)
    REFERENCES posting.tag(tag_id),
  CONSTRAINT tag_topic_topic_id_fkey FOREIGN KEY (topic_id)
    REFERENCES posting.topic(topic_id)
);
