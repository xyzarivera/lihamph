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
  v_message VARCHAR(255) := 'Comment has been posted';
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
