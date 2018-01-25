CREATE OR REPLACE FUNCTION posting.get_topic_by_id (
  p_topic_id BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  author_id INT,
  tags TEXT NULL,
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

