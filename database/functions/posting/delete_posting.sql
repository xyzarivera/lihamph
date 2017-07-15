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
