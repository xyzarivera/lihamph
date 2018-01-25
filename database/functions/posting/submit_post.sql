CREATE OR REPLACE FUNCTION posting.submit_post (
  p_title VARCHAR(500),
  p_content TEXT,
  p_tags TEXT NULL,
  p_author_id INT
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

  INSERT INTO posting.topic(title, author_id, tags)
  VALUES(p_title, p_author_id, p_tags)
  RETURNING topic_id INTO v_topic_id;

  INSERT INTO posting.post(topic_id, parent_post_id, title, content, tags, author_id)
  VALUES(v_topic_id, NULL, p_title, p_content, p_tags, p_author_id)
  RETURNING post_id INTO v_post_id;

  RETURN QUERY
  SELECT v_topic_id, v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
