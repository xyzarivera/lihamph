BEGIN;

DROP FUNCTION posting.submit_post(character varying, text, integer);
DROP FUNCTION posting.get_posting(bigint);
DROP FUNCTION posting.delete_posting(bigint);
DROP FUNCTION posting.get_post_by_id(bigint);
DROP FUNCTION posting.search_topics(character varying, integer, integer, bigint);
DROP FUNCTION posting.get_topics_by_author_id(integer, integer, integer, bigint);
DROP FUNCTION posting.get_topic_by_id(bigint);
DROP FUNCTION posting.post_comment(bigint, integer, text);
DROP FUNCTION posting.delete_comment(bigint);
DROP FUNCTION posting.edit_post(bigint, integer, text);
DROP FUNCTION posting.upvote_post(bigint, integer);
DROP FUNCTION posting.undo_upvote_post(bigint, integer);