CREATE OR REPLACE FUNCTION posting.search_topics (
  p_query VARCHAR,
  p_limit INT,
  p_offset BIGINT
) RETURNS TABLE (
  topic_id BIGINT,
  title VARCHAR(500),
  author_id INT,
  author_username VARCHAR(50),
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ,
  total_count BIGINT
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    t.title,
    p.person_id,
    p.username,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND (lower(t.title) LIKE concat('%', lower(trim(from p_query)), '%') OR p_query IS NULL)
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$func$ LANGUAGE plpgsql;
