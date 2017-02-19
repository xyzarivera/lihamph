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

  UPDATE posting.post SET is_deleted = true WHERE post_id = p_post_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
