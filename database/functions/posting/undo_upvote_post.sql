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
$func$ LANGUAGE plpgsql;