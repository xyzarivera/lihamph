CREATE TABLE posting.upvote (
  person_id INT NOT NULL,
  post_id BIGINT NOT NULL,
  CONSTRAINT upvote_person_id_post_id_pkey PRIMARY KEY (person_id, post_id),
  CONSTRAINT upvote_person_id_fkey FOREIGN KEY (person_id)
    REFERENCES core.person(person_id),
  CONSTRAINT upvote_post_id_fkey FOREIGN KEY (post_id)
    REFERENCES posting.post(post_id)
);