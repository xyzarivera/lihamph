CREATE TABLE posting.post (
  post_id BIGSERIAL NOT NULL,
  parent_post_id BIGINT NULL,
  topic_id INT NOT NULL,
  author_id INT NOT NULL,
  title VARCHAR(500) NOT NULL,
  content TEXT NOT NULL,
  is_edited BOOLEAN NOT NULL DEFAULT false,
  is_deleted BOOLEAN NOT NULL DEFAULT false,
  created_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_updated_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT post_post_id_pkey PRIMARY KEY (post_id),
  CONSTRAINT post_topic_id_fkey FOREIGN KEY (topic_id)
    REFERENCES posting.topic(topic_id),
  CONSTRAINT post_author_id_fkey FOREIGN KEY (author_id)
    REFERENCES core.person(person_id)
);

ALTER TABLE posting.post
ADD CONSTRAINT topic_parent_post_id_fkey FOREIGN KEY (parent_post_id)
REFERENCES posting.post(post_id);
