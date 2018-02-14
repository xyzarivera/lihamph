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
