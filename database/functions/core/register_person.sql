CREATE OR REPLACE FUNCTION core.register_person (
  p_username VARCHAR(50),
  p_hashed_password VARCHAR(500)
) RETURNS TABLE (
  id INT,
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_person_id INT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ang iyong sagisag ay nagawa na';
BEGIN
  IF EXISTS(SELECT p.person_id FROM core.person AS p WHERE p.username = p_username) THEN
    v_status := 'warning';
    v_message := 'Ang iyong napiling sagisag ay umiiral na';

    RETURN QUERY SELECT v_person_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO core.person (username, hashed_password)
  VALUES (p_username, p_hashed_password)
  RETURNING person_id INTO v_person_id;

  RETURN QUERY
  SELECT v_person_id, v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
