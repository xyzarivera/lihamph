CREATE OR REPLACE FUNCTION posting.get_posting (
  p_topic_id BIGINT
) RETURNS TABLE (
  post_id BIGINT,
  parent_post_id BIGINT,
  topic_id INT,
  author_id INT,
  author_username VARCHAR(50),
  title VARCHAR(500),
  content TEXT,
  is_edited BOOLEAN,
  is_deleted BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    p.post_id,
    p.parent_post_id,
    p.topic_id,
    pr.person_id,
    pr.username,
    p.title,
    p.content,
    p.is_edited,
    p.is_deleted,
    p.created_date,
    p.last_updated_date
  FROM posting.post AS p
  INNER JOIN core.person AS pr
    ON p.author_id = pr.person_id
  WHERE p.topic_id = p_topic_id
    AND p.is_deleted = false
  ORDER BY p.parent_post_id NULLS FIRST, p.post_id;
END;
$func$ LANGUAGE plpgsql;
