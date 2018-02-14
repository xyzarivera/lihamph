CREATE OR REPLACE FUNCTION posting.get_tag_by_name (
  p_tag_name VARCHAR
) RETURNS TABLE (
  tag_id INT,
  tag_name VARCHAR,
  topic_count INT
)
AS
$func$
BEGIN 
  RETURN QUERY
  SELECT
    t.tag_id,
    t.tag_name,
    t.topic_count
  FROM posting.tag AS t
  WHERE t.tag_name = p_tag_name;
END;
$func$ LANGUAGE plpgsql;
