CREATE OR REPLACE FUNCTION posting.search_topics (
  p_query VARCHAR,
  p_requestor_id INT,
  p_limit INT,
  p_offset BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  post_id BIGINT,
  title VARCHAR(500),
  tags TEXT NULL,
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
    AND ps.parent_post_id IS NULl
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
