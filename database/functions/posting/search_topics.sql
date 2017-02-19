CREATE OR REPLACE FUNCTION posting.search_topics (
) RETURNS TABLE (
  topic_id BIGINT,
  title VARCHAR(500),
  author_id INT,
  author_username VARCHAR(50),
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
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
    t.last_updated_date
  FROM posting.topic AS t
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
  ORDER BY t.topic_id DESC;
END;
$func$ LANGUAGE plpgsql;
