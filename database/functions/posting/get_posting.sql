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
  tags VARCHAR[],
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
    tg.tags,
    p.is_edited,
    p.is_deleted,
    p.created_date,
    p.last_updated_date
  FROM posting.post AS p
  INNER JOIN core.person AS pr
    ON p.author_id = pr.person_id
  LEFT JOIN (
    SELECT
      array_agg(tg.tag_name) AS tags,
      ttg.topic_id
    FROM posting.tag AS tg
    INNER JOIN posting.topic_tag AS ttg
      ON ttg.tag_id = tg.tag_id
    GROUP BY ttg.topic_id
  ) AS tg
    ON tg.topic_id = p.topic_id
  WHERE p.topic_id = p_topic_id
    AND p.is_deleted = false
  ORDER BY p.parent_post_id NULLS FIRST, p.post_id DESC;
END;
$func$ LANGUAGE plpgsql;
