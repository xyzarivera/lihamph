CREATE OR REPLACE FUNCTION core.change_password (
  p_person_id INT,
  p_hashed_password VARCHAR(500)
) RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ang lihim mo ay nabago na';
BEGIN
  IF NOT EXISTS(SELECT p.person_id FROM core.person AS p WHERE p.person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE core.person
  SET hashed_password = p_hashed_password,
    last_updated_date = now()
  WHERE person_id = p_person_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
