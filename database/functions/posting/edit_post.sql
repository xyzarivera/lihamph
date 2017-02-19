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
  v_message VARCHAR(255) := 'Post has been edited';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post
      WHERE post_id = p_post_id AND author_id = p_author_id AND is_deleted = false) THEN
    v_status := 'error';
    v_message := 'Post does not exist';

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
