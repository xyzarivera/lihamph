CREATE OR REPLACE FUNCTION core.find_person_by_id (
  p_person_id INT
) RETURNS TABLE (
  person_id INT,
  username VARCHAR(50),
  hashed_password VARCHAR(500),
  email_address VARCHAR(255),
  about_me TEXT,
  is_moderator BOOLEAN,
  is_enabled BOOLEAN,
  created_date TIMESTAMPTZ,
  last_updated_date TIMESTAMPTZ
) AS
$func$
BEGIN
  RETURN QUERY
  SELECT
    p.person_id,
    p.username,
    p.hashed_password,
    p.email_address,
    p.about_me,
    p.is_moderator,
    p.is_enabled,
    p.created_date,
    p.last_updated_date
  FROM core.person AS p
  WHERE p.person_id = p_person_id;
END;
$func$ LANGUAGE plpgsql;
