CREATE TABLE core.person (
  person_id SERIAL NOT NULL,
  username VARCHAR(50) NOT NULL,
  hashed_password VARCHAR(500) NOT NULL,
  email_address VARCHAR(255) NULL,
  about_me TEXT NULL,
  is_moderator BOOLEAN NOT NULL DEFAULT false,
  is_enabled BOOLEAN NOT NULL DEFAULT true,
  created_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_updated_date TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT person_person_id_pkey PRIMARY KEY (person_id),
  CONSTRAINT person_username_key UNIQUE (username)
);
