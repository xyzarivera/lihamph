--- START OF database/migration/1-1-0/1-init.sql --- 
BEGIN;

DROP FUNCTION posting.submit_post(character varying, text, integer);
DROP FUNCTION posting.get_posting(bigint);
DROP FUNCTION posting.delete_posting(bigint);
DROP FUNCTION posting.get_post_by_id(bigint);
DROP FUNCTION posting.search_topics(character varying, integer, integer, bigint);
DROP FUNCTION posting.get_topics_by_author_id(integer, integer, integer, bigint);
DROP FUNCTION posting.get_topic_by_id(bigint);
DROP FUNCTION posting.post_comment(bigint, integer, text);
DROP FUNCTION posting.delete_comment(bigint);
DROP FUNCTION posting.edit_post(bigint, integer, text);
DROP FUNCTION posting.upvote_post(bigint, integer);
DROP FUNCTION posting.undo_upvote_post(bigint, integer);--- END OF database/migration/1-1-0/1-init.sql --- 

--- START OF database/tables/posting/tag.sql --- 
CREATE TABLE posting.tag (
  tag_id SERIAL NOT NULL,
  tag_name VARCHAR(255) NOT NULL,
  topic_count INT NOT NULL DEFAULT 0,
  CONSTRAINT tag_tag_id_pkey PRIMARY KEY (tag_id),
  CONSTRAINT tag_tag_name_key UNIQUE (tag_name)
);
--- END OF database/tables/posting/tag.sql --- 

--- START OF database/tables/posting/topic_tag.sql --- 
CREATE TABLE posting.topic_tag (
  topic_id BIGINT NOT NULL,
  tag_id INT NOT NULL,
  CONSTRAINT tag_topic_tag_id_topic_id_pkey PRIMARY KEY (tag_id, topic_id),
  CONSTRAINT tag_topic_tag_id_fkey FOREIGN KEY (tag_id)
    REFERENCES posting.tag(tag_id),
  CONSTRAINT tag_topic_topic_id_fkey FOREIGN KEY (topic_id)
    REFERENCES posting.topic(topic_id)
);
--- END OF database/tables/posting/topic_tag.sql --- 

--- START OF database/functions/posting/submit_post.sql --- 
CREATE OR REPLACE FUNCTION posting.submit_post (
  p_title VARCHAR(500),
  p_content TEXT,
  p_author_id INT,
  p_tags VARCHAR[]
) RETURNS TABLE (
  id BIGINT,
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_topic_id BIGINT;
  v_post_id BIGINT;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Post is submitted successfully';
BEGIN
  IF NOT EXISTS (SELECT p.person_id FROM core.person AS p WHERE p.person_id = p_author_id) THEN
    v_status := 'error';
    v_message := 'Author does not exist';
    RETURN QUERY
    SELECT v_post_id, v_status, v_message;

    RETURN;
  END IF;

  INSERT INTO posting.topic(title, author_id)
  VALUES(p_title, p_author_id)
  RETURNING topic_id INTO v_topic_id;

  INSERT INTO posting.post(topic_id, parent_post_id, title, content, author_id)
  VALUES(v_topic_id, NULL, p_title, p_content, p_author_id)
  RETURNING post_id INTO v_post_id;

  IF p_tags IS NOT NULL THEN
    INSERT INTO posting.tag(tag_name)
    SELECT tg.tag_name
    FROM (
      SELECT p_tags[i] AS tag_name
      FROM generate_series(array_lower(p_tags, 1), array_upper(p_tags, 1)) AS i
      LEFT JOIN posting.tag AS t
        ON t.tag_name = p_tags[i]
      WHERE t.tag_id IS NULL
    ) AS tg;

    INSERT INTO posting.topic_tag(tag_id, topic_id)
    SELECT t.tag_id, v_topic_id
    FROM generate_series(array_lower(p_tags, 1), array_upper(p_tags, 1)) AS i
    INNER JOIN posting.tag AS t
      ON t.tag_name = p_tags[i];
  END IF;

  RETURN QUERY
  SELECT v_topic_id, v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/submit_post.sql --- 

--- START OF database/functions/posting/get_posting.sql --- 
CREATE OR REPLACE FUNCTION posting.get_posting (
  p_topic_id BIGINT
) RETURNS TABLE (
  post_id BIGINT,
  parent_post_id BIGINT,
  topic_id INT,
  author_id INT,
  author_username VARCHAR(50),
  title VARCHAR(500),
  content TEXT,
  tags VARCHAR[],
  is_edited BOOLEAN,
  is_deleted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    p.post_id,
    p.parent_post_id,
    p.topic_id,
    pr.person_id,
    pr.username,
    p.title,
    p.content,
    tg.tags,
    p.is_edited,
    p.is_deleted,
    p.created_date,
    p.last_updated_date
  FROM posting.post AS p
  INNER JOIN core.person AS pr
    ON p.author_id = pr.person_id
  LEFT JOIN (
    SELECT
      array_agg(tg.tag_name) AS tags,
      ttg.topic_id
    FROM posting.tag AS tg
    INNER JOIN posting.topic_tag AS ttg
      ON ttg.tag_id = tg.tag_id
    GROUP BY ttg.topic_id
  ) AS tg
    ON tg.topic_id = p.topic_id
  WHERE p.topic_id = p_topic_id
    AND p.is_deleted = false
  ORDER BY p.parent_post_id NULLS FIRST, p.post_id DESC;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_posting.sql --- 

--- START OF database/functions/posting/get_post_by_id.sql --- 
CREATE OR REPLACE FUNCTION posting.get_post_by_id (
  p_post_id BIGINT
) RETURNS TABLE (
  post_id BIGINT,
  parent_post_id BIGINT,
  topic_id INT,
  author_id INT,
  author_username VARCHAR(50),
  title VARCHAR(500),
  content TEXT,
  is_edited BOOLEAN,
  is_deleted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    p.post_id,
    p.parent_post_id,
    p.topic_id,
    pr.person_id,
    pr.username,
    p.title,
    p.content,
    p.is_edited,
    p.is_deleted,
    p.created_date,
    p.last_updated_date
  FROM posting.post AS p
  INNER JOIN core.person AS pr
    ON p.author_id = pr.person_id
  WHERE p.post_id = p_post_id
    AND p.is_deleted = false;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_post_by_id.sql --- 

--- START OF database/functions/posting/delete_posting.sql --- 
CREATE OR REPLACE FUNCTION posting.delete_posting (
  p_topic_id BIGINT
) RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Posting deleted successfully';
BEGIN
  IF NOT EXISTS (SELECT topic_id FROM posting.topic WHERE topic_id = p_topic_id) THEN
    v_status := 'warning';
    v_message := 'Posting does not exist';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post 
  SET is_deleted = true,
    last_updated_date = now()
  WHERE topic_id = p_topic_id;

  UPDATE posting.topic
  SET is_deleted = true, 
    last_updated_date = now()
  WHERE topic_id = p_topic_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/delete_posting.sql --- 

--- START OF database/functions/posting/search_topics.sql --- 
CREATE OR REPLACE FUNCTION posting.search_topics (
  p_query VARCHAR,
  p_requestor_id INT,
  p_limit INT,
  p_offset BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  tags VARCHAR[],
  author_id INT,
  author_username VARCHAR(50),
  reply_count INT,
  upvote_count INT,
  is_upvoted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ,
  total_count BIGINT
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    tg.tags,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    CASE WHEN u.post_id IS NOT NULL THEN TRUE ELSE FALSE END,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULL
  LEFT JOIN (
    SELECT
      array_agg(tg.tag_name) AS tags,
      ttg.topic_id
    FROM posting.tag AS tg
    INNER JOIN posting.topic_tag AS ttg
      ON ttg.tag_id = tg.tag_id
    GROUP BY ttg.topic_id
  ) AS tg
    ON tg.topic_id = t.topic_id
  LEFT JOIN posting.upvote AS u
    ON u.post_id = ps.post_id
    AND u.person_id = p_requestor_id
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND (lower(t.title) LIKE concat('%', lower(trim(from p_query)), '%') OR p_query IS NULL)
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/search_topics.sql --- 

--- START OF database/functions/posting/get_tag_by_name.sql --- 
CREATE OR REPLACE FUNCTION posting.get_tag_by_name (
  p_tag_name VARCHAR
) RETURNS TABLE (
  tag_id INT,
  tag_name VARCHAR,
  topic_count INT
)
AS
$func$
BEGIN 
  RETURN QUERY
  SELECT
    t.tag_id,
    t.tag_name,
    t.topic_count
  FROM posting.tag AS t
  WHERE t.tag_name = p_tag_name;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_tag_by_name.sql --- 

--- START OF database/functions/posting/get_topics_by_author_id.sql --- 
CREATE OR REPLACE FUNCTION posting.get_topics_by_author_id (
  p_author_id INT,
  p_requestor_id INT,
  p_limit INT,
  p_offset BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  tags VARCHAR[],
  author_id INT,
  author_username VARCHAR(50),
  reply_count INT,
  upvote_count INT,
  is_upvoted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ,
  total_count BIGINT
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    tg.tags,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    CASE WHEN u.post_id IS NOT NULL THEN TRUE ELSE FALSE END,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULL
  LEFT JOIN (
    SELECT
      array_agg(tg.tag_name) AS tags,
      ttg.topic_id
    FROM posting.tag AS tg
    INNER JOIN posting.topic_tag AS ttg
      ON ttg.tag_id = tg.tag_id
    GROUP BY ttg.topic_id
  ) AS tg
    ON tg.topic_id = t.topic_id
  LEFT JOIN posting.upvote AS u
    ON u.post_id = ps.post_id
    AND u.person_id = p_requestor_id
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND t.author_id = p_author_id
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_topics_by_author_id.sql --- 

--- START OF database/functions/posting/get_topics_by_tag_name.sql --- 
CREATE OR REPLACE FUNCTION posting.get_topics_by_tag_name (
  p_tag_name VARCHAR,
  p_requestor_id INT,
  p_limit INT,
  p_offset BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  tags VARCHAR[],
  author_id INT,
  author_username VARCHAR(50),
  reply_count INT,
  upvote_count INT,
  is_upvoted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ,
  total_count BIGINT
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    tg.tags,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    CASE WHEN u.post_id IS NOT NULL THEN TRUE ELSE FALSE END,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULL
  INNER JOIN (
    SELECT
      array_agg(tg.tag_name) AS tags,
      ttg.topic_id
    FROM posting.tag AS tg
    INNER JOIN posting.topic_tag AS ttg
      ON ttg.tag_id = tg.tag_id
    WHERE tg.tag_name = p_tag_name
    GROUP BY ttg.topic_id
  ) AS tg
    ON tg.topic_id = t.topic_id
  LEFT JOIN posting.upvote AS u
    ON u.post_id = ps.post_id
    AND u.person_id = p_requestor_id
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_topics_by_tag_name.sql --- 

--- START OF database/functions/posting/get_topic_by_id.sql --- 
CREATE OR REPLACE FUNCTION posting.get_topic_by_id (
  p_topic_id BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  author_id INT,
  author_username VARCHAR(50),
  reply_count INT,
  upvote_count INT,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    t.created_date,
    t.last_updated_date
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULl
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND t.topic_id = p_topic_id;
END;
$func$ LANGUAGE plpgsql;

--- END OF database/functions/posting/get_topic_by_id.sql --- 

--- START OF database/functions/posting/get_post_by_id.sql --- 
CREATE OR REPLACE FUNCTION posting.get_post_by_id (
  p_post_id BIGINT
) RETURNS TABLE (
  post_id BIGINT,
  parent_post_id BIGINT,
  topic_id INT,
  author_id INT,
  author_username VARCHAR(50),
  title VARCHAR(500),
  content TEXT,
  is_edited BOOLEAN,
  is_deleted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    p.post_id,
    p.parent_post_id,
    p.topic_id,
    pr.person_id,
    pr.username,
    p.title,
    p.content,
    p.is_edited,
    p.is_deleted,
    p.created_date,
    p.last_updated_date
  FROM posting.post AS p
  INNER JOIN core.person AS pr
    ON p.author_id = pr.person_id
  WHERE p.post_id = p_post_id
    AND p.is_deleted = false;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/get_post_by_id.sql --- 

--- START OF database/functions/posting/post_comment.sql --- 
CREATE OR REPLACE FUNCTION posting.post_comment (
  p_post_id BIGINT,
  p_author_id INT,
  p_content TEXT
) RETURNS TABLE (
  id BIGINT,
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_new_post_id BIGINT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ang iyong tugon ay nailagay na sa liham';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post
      WHERE post_id = p_post_id AND is_deleted = false) THEN
    v_status := 'error';
    v_message := 'Parent post does not exist';

    RETURN QUERY SELECT v_new_post_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO posting.post (
    parent_post_id,
    topic_id,
    author_id,
    title,
    content
  )
  SELECT
    post_id,
    topic_id,
    p_author_id,
    title,
    p_content
  FROM posting.post
  WHERE post_id = p_post_id
  RETURNING post_id INTO v_new_post_id;

  UPDATE posting.topic
  SET reply_count = reply_count + 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET reply_count = reply_count + 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY 
  SELECT v_new_post_id, v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/post_comment.sql --- 

--- START OF database/functions/posting/delete_comment.sql --- 
CREATE OR REPLACE FUNCTION posting.delete_comment (
  p_post_id BIGINT
) RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Comment deleted successfully';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Comment does not exist';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post 
  SET is_deleted = true,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/delete_comment.sql --- 

--- START OF database/functions/posting/edit_post.sql --- 
CREATE OR REPLACE FUNCTION posting.edit_post (
  p_post_id BIGINT,
  p_author_id INT,
  p_content TEXT
) RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Naitala na ang iyong mga binago';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post
      WHERE post_id = p_post_id AND author_id = p_author_id AND is_deleted = false) THEN
    v_status := 'error';
    v_message := 'Ang pagbabago mo sa liham o tugon ay naitala na';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post
  SET content = p_content,
    is_edited = TRUE,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
--- END OF database/functions/posting/edit_post.sql --- 

--- START OF database/functions/posting/upvote_post.sql --- 
CREATE FUNCTION posting.upvote_post (
  p_post_id BIGINT,
  p_person_id INT
) 
RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ito ay iyong napusuan';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.person WHERE person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Ang liham o tugon na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (SELECT 1 FROM posting.upvote 
      WHERE post_id = p_post_id AND person_id = p_person_id) THEN
    v_status := 'info';
    v_message := 'Ang liham o tugon na ito ay iyong napusuan na';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO posting.upvote(post_id, person_id)
  VALUES (p_post_id, p_person_id);

  UPDATE posting.topic
  SET upvote_count = upvote_count + 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET upvote_count = upvote_count + 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;--- END OF database/functions/posting/upvote_post.sql --- 

--- START OF database/functions/posting/undo_upvote_post.sql --- 
CREATE FUNCTION posting.undo_upvote_post (
  p_post_id BIGINT,
  p_person_id INT
) 
RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Hindi mo na ito pinupusuan';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.person WHERE person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Ang liham o tugon na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.upvote 
      WHERE post_id = p_post_id AND person_id = p_person_id) THEN
    v_status := 'info';
    v_message := 'Ang liham o tugon na ito ay hindi mo napusuan pa';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  DELETE FROM posting.upvote
  WHERE post_id = p_post_id AND person_id = p_person_id;

  UPDATE posting.topic
  SET upvote_count = upvote_count - 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET upvote_count = upvote_count - 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;--- END OF database/functions/posting/undo_upvote_post.sql --- 

--- START OF database/functions/triggers/update_topic_tag_count.sql --- 
CREATE OR REPLACE FUNCTION posting.update_topic_tag_count()
RETURNS trigger
AS $func$
BEGIN
  UPDATE posting.tag AS t
  SET topic_count = (
      SELECT COUNT(*)
      FROM posting.topic_tag AS tt
      WHERE tt.tag_id = t.tag_id
    )
  WHERE t.tag_id = NEW.tag_id;

  RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE TRIGGER update_topic_tag_count_trigger
AFTER INSERT on posting.topic_tag
FOR EACH ROW
EXECUTE PROCEDURE posting.update_topic_tag_count();
--- END OF database/functions/triggers/update_topic_tag_count.sql --- 

--- START OF database/migration/1-1-0/2-commit.sql --- 
-- ROLLBACK;
COMMIT;
--- END OF database/migration/1-1-0/2-commit.sql --- 

