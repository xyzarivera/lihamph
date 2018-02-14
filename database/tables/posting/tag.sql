CREATE TABLE posting.tag (
  tag_id SERIAL NOT NULL,
  tag_name VARCHAR(255) NOT NULL,
  topic_count INT NOT NULL DEFAULT 0,
  CONSTRAINT tag_tag_id_pkey PRIMARY KEY (tag_id),
  CONSTRAINT tag_tag_name_key UNIQUE (tag_name)
);
