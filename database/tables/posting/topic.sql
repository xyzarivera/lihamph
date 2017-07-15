CREATE TABLE posting.topic (
  topic_id BIGSERIAL NOT NULL,
  title VARCHAR(500) NOT NULL,
  author_id INT NOT NULL,
  upvote_count INT NOT NULL DEFAULT 0,
  reply_count INT NOT NULL DEFAULT 0,
  is_deleted BOOLEAN NOT NULL DEFAULT false,
  created_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_updated_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT topic_topic_id_pkey PRIMARY KEY (topic_id),
  CONSTRAINT topic_author_id_fkey FOREIGN KEY (author_id)
    REFERENCES core.person(person_id)
);
