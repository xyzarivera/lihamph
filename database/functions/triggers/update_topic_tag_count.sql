CREATE OR REPLACE FUNCTION posting.update_topic_tag_count()
RETURNS trigger
AS $func$
BEGIN
  UPDATE posting.tag AS t
  SET topic_count = (
      SELECT COUNT(*)
      FROM posting.topic_tag AS tt
      WHERE tt.tag_id = t.tag_id
    )
  WHERE t.tag_id = NEW.tag_id;

  RETURN NEW;
END
$func$ LANGUAGE plpgsql;

CREATE TRIGGER update_topic_tag_count_trigger
AFTER INSERT on posting.topic_tag
FOR EACH ROW
EXECUTE PROCEDURE posting.update_topic_tag_count();
