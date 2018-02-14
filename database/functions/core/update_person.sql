CREATE OR REPLACE FUNCTION core.update_person (
  p_person_id INT,
  p_username VARCHAR(50),
  p_email_address VARCHAR(255),
  p_about_me TEXT
) RETURNS TABLE (
  status VARCHAR(50),
  message VARCHAR(255)
) AS
$func$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Naitala na ang pagbabago';
BEGIN
  IF NOT EXISTS(SELECT p.person_id FROM core.person AS p WHERE p.person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS(SELECT p.person_id FROM core.person AS p
      WHERE p.username = p_username AND p.person_id <> p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang iyong napiling sagisag ay umiiral na';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;


  UPDATE core.person
  SET username = p_username,
    email_address = p_email_address,
    about_me = p_about_me,
    last_updated_date = now()
  WHERE person_id = p_person_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$func$ LANGUAGE plpgsql;
