--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: lihamph
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO lihamph;

--
-- Name: core; Type: SCHEMA; Schema: -; Owner: lihamph
--

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO lihamph;

--
-- Name: posting; Type: SCHEMA; Schema: -; Owner: lihamph
--

CREATE SCHEMA posting;


ALTER SCHEMA posting OWNER TO lihamph;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = core, pg_catalog;

--
-- Name: change_password(integer, character varying); Type: FUNCTION; Schema: core; Owner: lihamph
--

CREATE FUNCTION change_password(p_person_id integer, p_hashed_password character varying) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.change_password(p_person_id integer, p_hashed_password character varying) OWNER TO lihamph;

--
-- Name: find_person_by_id(integer); Type: FUNCTION; Schema: core; Owner: lihamph
--

CREATE FUNCTION find_person_by_id(p_person_id integer) RETURNS TABLE(person_id integer, username character varying, hashed_password character varying, email_address character varying, about_me text, is_moderator boolean, is_enabled boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.find_person_by_id(p_person_id integer) OWNER TO lihamph;

--
-- Name: find_person_by_username(character varying); Type: FUNCTION; Schema: core; Owner: lihamph
--

CREATE FUNCTION find_person_by_username(p_username character varying) RETURNS TABLE(person_id integer, username character varying, hashed_password character varying, email_address character varying, about_me text, is_moderator boolean, is_enabled boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
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
  WHERE p.username = p_username;
END;
$$;


ALTER FUNCTION core.find_person_by_username(p_username character varying) OWNER TO lihamph;

--
-- Name: register_person(character varying, character varying); Type: FUNCTION; Schema: core; Owner: lihamph
--

CREATE FUNCTION register_person(p_username character varying, p_hashed_password character varying) RETURNS TABLE(id integer, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.register_person(p_username character varying, p_hashed_password character varying) OWNER TO lihamph;

--
-- Name: update_person(integer, character varying, character varying, text); Type: FUNCTION; Schema: core; Owner: lihamph
--

CREATE FUNCTION update_person(p_person_id integer, p_username character varying, p_email_address character varying, p_about_me text) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION core.update_person(p_person_id integer, p_username character varying, p_email_address character varying, p_about_me text) OWNER TO lihamph;

SET search_path = posting, pg_catalog;

--
-- Name: delete_comment(bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION delete_comment(p_post_id bigint) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Comment deleted successfully';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Comment does not exist';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post 
  SET is_deleted = true,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION posting.delete_comment(p_post_id bigint) OWNER TO lihamph;

--
-- Name: delete_posting(bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION delete_posting(p_topic_id bigint) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Posting deleted successfully';
BEGIN
  IF NOT EXISTS (SELECT topic_id FROM posting.topic WHERE topic_id = p_topic_id) THEN
    v_status := 'warning';
    v_message := 'Posting does not exist';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post 
  SET is_deleted = true,
    last_updated_date = now()
  WHERE topic_id = p_topic_id;

  UPDATE posting.topic
  SET is_deleted = true, 
    last_updated_date = now()
  WHERE topic_id = p_topic_id;

  RETURN QUERY
  SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION posting.delete_posting(p_topic_id bigint) OWNER TO lihamph;

--
-- Name: edit_post(bigint, integer, text); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION edit_post(p_post_id bigint, p_author_id integer, p_content text) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Naitala na ang iyong mga binago';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post
      WHERE post_id = p_post_id AND author_id = p_author_id AND is_deleted = false) THEN
    v_status := 'error';
    v_message := 'Ang pagbabago mo sa liham o tugon ay naitala na';

    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  UPDATE posting.post
  SET content = p_content,
    is_edited = TRUE,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION posting.edit_post(p_post_id bigint, p_author_id integer, p_content text) OWNER TO lihamph;

--
-- Name: get_post_by_id(bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION get_post_by_id(p_post_id bigint) RETURNS TABLE(post_id bigint, parent_post_id bigint, topic_id integer, author_id integer, author_username character varying, title character varying, content text, is_edited boolean, is_deleted boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
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
  WHERE p.post_id = p_post_id
    AND p.is_deleted = false;
END;
$$;


ALTER FUNCTION posting.get_post_by_id(p_post_id bigint) OWNER TO lihamph;

--
-- Name: get_posting(bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION get_posting(p_topic_id bigint) RETURNS TABLE(post_id bigint, parent_post_id bigint, topic_id integer, author_id integer, author_username character varying, title character varying, content text, is_edited boolean, is_deleted boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
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
  ORDER BY p.parent_post_id NULLS FIRST, p.created_date ASC;
END;
$$;


ALTER FUNCTION posting.get_posting(p_topic_id bigint) OWNER TO lihamph;

--
-- Name: get_topic_by_id(bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION get_topic_by_id(p_topic_id bigint) RETURNS TABLE(topic_id bigint, post_id bigint, title character varying, author_id integer, author_username character varying, reply_count integer, upvote_count integer, created_date timestamp with time zone, last_updated_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    t.created_date,
    t.last_updated_date
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULl
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND t.topic_id = p_topic_id;
END;
$$;


ALTER FUNCTION posting.get_topic_by_id(p_topic_id bigint) OWNER TO lihamph;

--
-- Name: get_topics_by_author_id(integer, integer, integer, bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION get_topics_by_author_id(p_author_id integer, p_requestor_id integer, p_limit integer, p_offset bigint) RETURNS TABLE(topic_id bigint, post_id bigint, title character varying, author_id integer, author_username character varying, reply_count integer, upvote_count integer, is_upvoted boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    CASE WHEN u.post_id IS NOT NULL THEN TRUE ELSE FALSE END,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULl
  LEFT JOIN posting.upvote AS u
    ON u.post_id = ps.post_id
    AND u.person_id = p_requestor_id
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND t.author_id = p_author_id
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$;


ALTER FUNCTION posting.get_topics_by_author_id(p_author_id integer, p_requestor_id integer, p_limit integer, p_offset bigint) OWNER TO lihamph;

--
-- Name: post_comment(bigint, integer, text); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION post_comment(p_post_id bigint, p_author_id integer, p_content text) RETURNS TABLE(id bigint, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_new_post_id BIGINT := 0;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ang iyong tugon ay nailagay na sa liham';
BEGIN
  IF NOT EXISTS (SELECT post_id FROM posting.post
      WHERE post_id = p_post_id AND is_deleted = false) THEN
    v_status := 'error';
    v_message := 'Parent post does not exist';

    RETURN QUERY SELECT v_new_post_id, v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO posting.post (
    parent_post_id,
    topic_id,
    author_id,
    title,
    content
  )
  SELECT
    post_id,
    topic_id,
    p_author_id,
    title,
    p_content
  FROM posting.post
  WHERE post_id = p_post_id
  RETURNING post_id INTO v_new_post_id;

  UPDATE posting.topic
  SET reply_count = reply_count + 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET reply_count = reply_count + 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY 
  SELECT v_new_post_id, v_status, v_message;
END;
$$;


ALTER FUNCTION posting.post_comment(p_post_id bigint, p_author_id integer, p_content text) OWNER TO lihamph;

--
-- Name: search_topics(character varying, integer, integer, bigint); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION search_topics(p_query character varying, p_requestor_id integer, p_limit integer, p_offset bigint) RETURNS TABLE(topic_id bigint, post_id bigint, title character varying, author_id integer, author_username character varying, reply_count integer, upvote_count integer, is_upvoted boolean, created_date timestamp with time zone, last_updated_date timestamp with time zone, total_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.topic_id,
    ps.post_id,
    t.title,
    p.person_id,
    p.username,
    t.reply_count,
    t.upvote_count,
    CASE WHEN u.post_id IS NOT NULL THEN TRUE ELSE FALSE END,
    t.created_date,
    t.last_updated_date,
    COUNT(*) OVER () AS total_count
  FROM posting.topic AS t
  INNER JOIN posting.post AS ps
    ON ps.topic_id = t.topic_id
    AND ps.parent_post_id IS NULl
  LEFT JOIN posting.upvote AS u
    ON u.post_id = ps.post_id
    AND u.person_id = p_requestor_id
  INNER JOIN core.person AS p
    ON p.person_id = t.author_id
  WHERE t.is_deleted = false
    AND (lower(t.title) LIKE concat('%', lower(trim(from p_query)), '%') OR p_query IS NULL)
  ORDER BY t.topic_id DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$;


ALTER FUNCTION posting.search_topics(p_query character varying, p_requestor_id integer, p_limit integer, p_offset bigint) OWNER TO lihamph;

--
-- Name: submit_post(character varying, text, integer); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION submit_post(p_title character varying, p_content text, p_author_id integer) RETURNS TABLE(id bigint, status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_topic_id BIGINT;
  v_post_id BIGINT;
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Post is submitted successfully';
BEGIN
  IF NOT EXISTS (SELECT p.person_id FROM core.person AS p WHERE p.person_id = p_author_id) THEN
    v_status := 'error';
    v_message := 'Author does not exist';
    RETURN QUERY
    SELECT v_post_id, v_status, v_message;

    RETURN;
  END IF;

  INSERT INTO posting.topic(title, author_id)
  VALUES(p_title, p_author_id)
  RETURNING topic_id INTO v_topic_id;

  INSERT INTO posting.post(topic_id, parent_post_id, title, content, author_id)
  VALUES(v_topic_id, NULL, p_title, p_content, p_author_id)
  RETURNING post_id INTO v_post_id;

  RETURN QUERY
  SELECT v_topic_id, v_status, v_message;
END;
$$;


ALTER FUNCTION posting.submit_post(p_title character varying, p_content text, p_author_id integer) OWNER TO lihamph;

--
-- Name: undo_upvote_post(bigint, integer); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION undo_upvote_post(p_post_id bigint, p_person_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Hindi mo na ito pinupusuan';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.person WHERE person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Ang liham o tugon na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.upvote 
      WHERE post_id = p_post_id AND person_id = p_person_id) THEN
    v_status := 'info';
    v_message := 'Ang liham o tugon na ito ay hindi mo napusuan pa';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  DELETE FROM posting.upvote
  WHERE post_id = p_post_id AND person_id = p_person_id;

  UPDATE posting.topic
  SET upvote_count = upvote_count - 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET upvote_count = upvote_count - 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION posting.undo_upvote_post(p_post_id bigint, p_person_id integer) OWNER TO lihamph;

--
-- Name: upvote_post(bigint, integer); Type: FUNCTION; Schema: posting; Owner: lihamph
--

CREATE FUNCTION upvote_post(p_post_id bigint, p_person_id integer) RETURNS TABLE(status character varying, message character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_status VARCHAR(50) := 'success';
  v_message VARCHAR(255) := 'Ito ay iyong napusuan';
BEGIN
  IF NOT EXISTS (SELECT 1 FROM core.person WHERE person_id = p_person_id) THEN
    v_status := 'warning';
    v_message := 'Ang sagisag na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM posting.post WHERE post_id = p_post_id) THEN
    v_status := 'warning';
    v_message := 'Ang liham o tugon na ito ay hindi umiiral';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  IF EXISTS (SELECT 1 FROM posting.upvote 
      WHERE post_id = p_post_id AND person_id = p_person_id) THEN
    v_status := 'info';
    v_message := 'Ang liham o tugon na ito ay iyong napusuan na';
    RETURN QUERY SELECT v_status, v_message;
    RETURN;
  END IF;

  INSERT INTO posting.upvote(post_id, person_id)
  VALUES (p_post_id, p_person_id);

  UPDATE posting.topic
  SET upvote_count = upvote_count + 1,
    last_updated_date = now()
  WHERE topic_id = (SELECT topic_id FROM posting.post WHERE post_id = p_post_id);

  UPDATE posting.post
  SET upvote_count = upvote_count + 1,
    last_updated_date = now()
  WHERE post_id = p_post_id;

  RETURN QUERY SELECT v_status, v_message;
END;
$$;


ALTER FUNCTION posting.upvote_post(p_post_id bigint, p_person_id integer) OWNER TO lihamph;

SET search_path = core, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: person; Type: TABLE; Schema: core; Owner: lihamph
--

CREATE TABLE person (
    person_id integer NOT NULL,
    username character varying(50) NOT NULL,
    hashed_password character varying(500) NOT NULL,
    email_address character varying(255),
    about_me text,
    is_moderator boolean DEFAULT false NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_date timestamp with time zone DEFAULT now() NOT NULL,
    last_updated_date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE person OWNER TO lihamph;

--
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: core; Owner: lihamph
--

CREATE SEQUENCE person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE person_person_id_seq OWNER TO lihamph;

--
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: lihamph
--

ALTER SEQUENCE person_person_id_seq OWNED BY person.person_id;


SET search_path = posting, pg_catalog;

--
-- Name: post; Type: TABLE; Schema: posting; Owner: lihamph
--

CREATE TABLE post (
    post_id bigint NOT NULL,
    parent_post_id bigint,
    topic_id integer NOT NULL,
    author_id integer NOT NULL,
    title character varying(500) NOT NULL,
    content text NOT NULL,
    upvote_count integer DEFAULT 0 NOT NULL,
    reply_count integer DEFAULT 0 NOT NULL,
    is_edited boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_date timestamp with time zone DEFAULT now() NOT NULL,
    last_updated_date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE post OWNER TO lihamph;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: posting; Owner: lihamph
--

CREATE SEQUENCE post_post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_post_id_seq OWNER TO lihamph;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: posting; Owner: lihamph
--

ALTER SEQUENCE post_post_id_seq OWNED BY post.post_id;


--
-- Name: topic; Type: TABLE; Schema: posting; Owner: lihamph
--

CREATE TABLE topic (
    topic_id bigint NOT NULL,
    title character varying(500) NOT NULL,
    author_id integer NOT NULL,
    upvote_count integer DEFAULT 0 NOT NULL,
    reply_count integer DEFAULT 0 NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_date timestamp with time zone DEFAULT now() NOT NULL,
    last_updated_date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE topic OWNER TO lihamph;

--
-- Name: topic_topic_id_seq; Type: SEQUENCE; Schema: posting; Owner: lihamph
--

CREATE SEQUENCE topic_topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topic_topic_id_seq OWNER TO lihamph;

--
-- Name: topic_topic_id_seq; Type: SEQUENCE OWNED BY; Schema: posting; Owner: lihamph
--

ALTER SEQUENCE topic_topic_id_seq OWNED BY topic.topic_id;


--
-- Name: upvote; Type: TABLE; Schema: posting; Owner: lihamph
--

CREATE TABLE upvote (
    person_id integer NOT NULL,
    post_id bigint NOT NULL,
    created_date timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE upvote OWNER TO lihamph;

SET search_path = core, pg_catalog;

--
-- Name: person person_id; Type: DEFAULT; Schema: core; Owner: lihamph
--

ALTER TABLE ONLY person ALTER COLUMN person_id SET DEFAULT nextval('person_person_id_seq'::regclass);


SET search_path = posting, pg_catalog;

--
-- Name: post post_id; Type: DEFAULT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY post ALTER COLUMN post_id SET DEFAULT nextval('post_post_id_seq'::regclass);


--
-- Name: topic topic_id; Type: DEFAULT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY topic ALTER COLUMN topic_id SET DEFAULT nextval('topic_topic_id_seq'::regclass);


SET search_path = core, pg_catalog;

--
-- Data for Name: person; Type: TABLE DATA; Schema: core; Owner: lihamph
--

COPY person (person_id, username, hashed_password, email_address, about_me, is_moderator, is_enabled, created_date, last_updated_date) FROM stdin;
5	batangbalisa	$2a$08$sQtGCoeUVeeirIEmi/j8eeKhQiflh2NxFZ1AwiihVIhDQNEWM18rS	\N	\N	f	t	2017-07-12 11:09:38.749611+00	2017-07-12 11:09:38.749611+00
6	DakilangMiguel	$2a$08$PIt8pshNuuxKszG/f.GjqunvJlS8uwR.IkF1gnin.qcACbRkSFic6	\N	\N	f	t	2017-07-12 12:31:14.054387+00	2017-07-12 12:31:14.054387+00
7	zelink	$2a$08$PMde3X3Pd6Si3i0B4iB9WONSHgh7PeMyFKCE6h/LXBBkJutelgNaK	\N	\N	f	t	2017-07-12 13:55:09.813953+00	2017-07-12 13:55:09.813953+00
8	karag	$2a$08$9beGxZvUeDVl29IOvGJkLuJoarCpKu6dWM8S8jiI7xd.xP4p1LtVW	\N	\N	f	t	2017-07-12 15:33:17.612008+00	2017-07-12 15:33:17.612008+00
10	damangdamako	$2a$08$AHO5ny1emOtBQxtb5auwCeZp2n3mUi5410qbEPCCziHWvzMBe9CIC	\N	\N	f	t	2017-07-13 08:45:42.812614+00	2017-07-13 08:45:42.812614+00
11	mamamarvic	$2a$08$ljFfxzzJ6fPXZSaPU/4F2u2YAj1wNeXI8mEOfWHleVKKX7GWUYncu	johnmarvicdianco@yahoo.com	:(	f	t	2017-07-13 13:09:25.547221+00	2017-07-13 13:11:14.551165+00
12	throwaway	$2a$08$vmPk5uvXDL0VkuSgIEQJ6OUyIwPFUs60Z70kbKq0KSLcrUjTWbhTG	\N	\N	f	t	2017-07-13 13:39:19.985+00	2017-07-13 13:40:46.470074+00
9	damhininyo	$2a$08$vmPk5uvXDL0VkuSgIEQJ6OUyIwPFUs60Z70kbKq0KSLcrUjTWbhTG	\N	\N	f	t	2017-07-13 02:36:28.177652+00	2017-07-13 02:36:28.177652+00
13	petsenoyawa	$2a$08$F1Mj3..LJIz35qbg3cYdyuC70FhWW1P6sOvyj0.IQYJIKW9D9Tbe.	\N	\N	f	t	2017-07-14 00:18:42.17668+00	2017-07-14 00:18:42.17668+00
14	malaya	$2a$08$LlKmfqviIbn6rVebPQqpIuKHGJcn7eXQM/vu1OV5PUCx5K.ifnGzG	\N	\N	f	t	2017-07-14 07:07:17.45647+00	2017-07-14 07:07:17.45647+00
15	TangAng	$2a$08$JsESweDEo7vA2R.4jxrsreo49wrQhpZYpVt0jlvV/AC4iEnMIXiSi	\N	\N	f	t	2017-07-15 04:56:41.735501+00	2017-07-15 04:56:41.735501+00
16	Rosas	$2a$08$XO9U2D9iCDm6nFvYy8kQQOjnIblv1Koi8Em.ejOQQdt5ry2Lfdqtm	\N	\N	f	t	2017-07-16 05:31:03.089445+00	2017-07-16 05:31:03.089445+00
17	yrag	$2a$08$rjhqE2ymqaJRO9rOE0meIOsBIt99oGSRcdlYCdBpTNKRtVqsBDETy	\N	\N	f	t	2017-07-16 05:39:14.154052+00	2017-07-16 05:39:14.154052+00
18	PusoNgAmianan	$2a$08$fxar/H3eufKXAD6jhrHMK.x2.PX9wWLsNN9MtcijaIKaOUkoSkThO	\N	\N	f	t	2017-07-16 13:59:19.698694+00	2017-07-16 13:59:19.698694+00
26	hiraya	$2a$08$NcaKpTzgZppB9iv/UdAddOHwmkHNGzEl6g7PKfPB4c3eGMXBIAfR2	ysabelle602@gmail.com 	naiisip, ngunit hindi maaabot. nawawala ngunit hindi makakatagpo. 	f	t	2017-07-26 08:35:54.089385+00	2017-08-03 11:53:55.323144+00
21	Hapon	$2a$08$gQoR9GS/883Vzt7A4l/PpuoyR5Llw3cilrwHqH19rbYjAjEBYBP9u	\N	\N	f	t	2017-07-19 01:59:56.682342+00	2017-07-19 01:59:56.682342+00
22	peyang	$2a$08$VzTTT5IODGKBqEEPmccPV.Z/mars6kdIIb/S8frpq3IqHo6gryAZ6	sofcruz127@gmail.com		f	t	2017-07-24 11:28:49.032031+00	2017-07-24 11:32:37.686192+00
23	ibongmalaya	$2a$08$6H5zfSIGPA9zgZRNn7242e4H8JlPC4vODx732RoYso/f48wrS8b16	\N	\N	f	t	2017-07-24 13:19:42.26136+00	2017-07-24 13:19:42.26136+00
4	81_TulaParaSaIyo	$2a$08$.4YPeJa7HqRBk/mnecgNTObzIueGe2.IMQV48.KYYbQ1Xp1NUhE.O		Umiibig na manunulat	f	t	2017-07-12 10:55:40.893656+00	2017-07-25 04:11:14.436217+00
24	Sinagtala	$2a$08$o5cQAstuEU0yjrJy/YfXyO7PIG.0JnDmxPar6tPdlnPU8mpDQRujK	\N	\N	f	t	2017-07-25 10:05:03.99491+00	2017-07-25 10:05:03.99491+00
25	Saturn	$2a$08$DyX7oJhM1BFkIS91hvjVDu7RLRHLZdxhknB/bKR28EnHRHZJBxEsy	\N	\N	f	t	2017-07-25 13:22:58.474798+00	2017-07-25 13:22:58.474798+00
27	bahaghari	$2a$08$DVoP1eMAfiGds7SG7efhHOQL7Kz6kkYR30T/kv/yTC6ci81ooYIA.	\N	\N	f	t	2017-07-26 16:14:06.566603+00	2017-07-26 16:14:06.566603+00
3	AngMangingibig	$2a$08$gEiIcE6JAmU4Br0P7TkSYe7245147bndZyR9u0AfBOgWUC5f2lDMe		Ang Mangingibig na umiibig hindi dahil sa kanyang sarili o mula sa kanyang sarili. Isang makasalanang natuklasang kaya pala niya kayang magmahal dahil una siyang niyakap at tinanggap ng Tunay na Pag-ibig.	f	t	2017-07-12 10:46:58.678965+00	2017-07-27 01:06:04.34406+00
28	hiyas	$2a$08$LFhrHRjRZyEyccOUBHYY3u2tgDXovyLSemZq14h1N4/mxKNCrFLAe	\N	\N	f	t	2017-07-27 13:59:56.793686+00	2017-07-27 13:59:56.793686+00
39	dalisay	$2a$08$doGughYvaDoqBfSFAhPbyulCxQnCCHWKqGyGKcmMaA9rcP0.v0Cgi	\N	\N	f	t	2017-08-04 20:15:43.688589+00	2017-08-04 20:15:43.688589+00
19	Mirasol	$2a$08$7qvQBvjEc//kywp8oVsz5uWfWpc5o1r21YF8Ly3ctj4bf7S7BtdAi		Iniaalay ko ang mga tulang ito para sayo.	f	t	2017-07-16 14:27:04.727285+00	2017-07-28 13:10:25.178376+00
30	AJ.	$2a$08$bVL6And3PDKf54ck7qfoC.5NisgXm8UErkIx7Rlrnj8B8X784IUB6	\N	\N	f	t	2017-07-28 13:13:54.336425+00	2017-07-28 13:13:54.336425+00
31	Guerrero	$2a$08$PP4kqkqIf.0u059/EiU7gO.XTfrDD9WudQboH1KpNAr.gVoVcFuYe	\N	\N	f	t	2017-07-31 06:59:12.534029+00	2017-07-31 06:59:12.534029+00
32	Puyatism	$2a$08$pRYxkiwZvxZzO1rFmgO8tOst68jGeYzKvdWjByiUjnefkOXkaCwCK	\N	\N	f	t	2017-07-31 13:57:17.154724+00	2017-07-31 13:57:17.154724+00
33	Magsasaka	$2a$08$XqJIKvwEBDaLqMC57LXCWeBMIlxkWruOTJhQMjTtvchs6WEJW09Pa	\N	\N	f	t	2017-07-31 18:02:48.54443+00	2017-07-31 18:02:48.54443+00
36	erisevangelista	$2a$08$HHyWRY6h/HhoiP5zH.Ia4epRGOHpFNI1Aco8r/WJbhyh9CuqIIoiq	\N	\N	f	t	2017-08-01 22:21:03.22174+00	2017-08-01 22:21:03.22174+00
37	lila	$2a$08$7TYuRGIyklBOxmFp2sAWAe92KoMgRiSBDtjS4MBqTGXy5SLp/IBJG	\N	\N	f	t	2017-08-03 05:08:06.411432+00	2017-08-03 05:08:06.411432+00
42	wagas	$2a$08$a/1WFkQgWMnk.COMwURc0ukvH5MOmOodaeuKThhlnsSQ5lTdxbKO2			f	t	2017-08-22 19:13:49.522591+00	2017-08-22 20:27:44.660586+00
35	Sanilad	$2a$08$pTk9zmAelEbZzuWv7Q06G.IVi2HZ4onlQ6Gv3NK0ulCBk4t8o/7M6		Mag-isang nakikibagay sa paghanap ng saysay.	f	t	2017-08-01 14:52:51.897427+00	2017-08-07 05:05:47.617965+00
34	kgabs	$2a$08$zdZZJRuRDxgcDngngZ/cvOE1mjibYKQNEW..eUIJAr/Yi6UHw9liK		sumusúlat ako ng líham 'di pará sa kalawákan, kundí pará sa pusó mong pagál. isáng áraw, ákin ngang hilíng, dalhín nawà ang mga itó sa ió ng hangín	f	t	2017-07-31 18:21:46.407798+00	2017-08-08 12:49:25.12295+00
38	hamaya	$2a$08$59CCCFAdTRalkfiCrO4wFOodjFfHIeNhiiAle2bWceEVxucoGb1u6		mananatiling nakakapit sa sinulid	f	t	2017-08-04 12:09:38.74026+00	2017-08-09 08:57:38.825422+00
29	hungkag	$2a$08$yGCmc6JhuBBwTsrHciOZ.exXpmA4wkMwdoxmUcq3nR3VmW/oJ8eYe	jericha.santillan@gmail.com		f	t	2017-07-28 12:47:40.816318+00	2017-08-11 11:31:46.253154+00
40	Maria	$2a$08$YQYWFkyF3Cg3bThYE12ViuFYPSbhy6oA33oXuNNaP6bbEWMxHMc6q	\N	\N	f	t	2017-08-17 08:42:00.229369+00	2017-08-17 08:42:00.229369+00
41	maria	$2a$08$FwM8loQhjAXc9qY2tnZqMOVb7FeCCLQiOtBkCzqxf8xDo7lsP9okW	\N	\N	f	t	2017-08-17 08:52:53.0499+00	2017-08-17 08:52:53.0499+00
2	anginiwannglubhaan	$2a$08$lPb1YMcPcbAyQq9pdkRcdueXu7GpW3Qxg7LcIBdJKI0ofho2ooHD6		Ako ay isang simpleng tao na nais lamang lumikha	f	t	2017-07-12 08:28:10.654029+00	2017-08-21 04:44:18.431192+00
43	lostmeanderer	$2a$08$USj1bJia2utefPfy7ezsA.b466p8.6SD4qdNacjAlI/NP0//MB5Du	\N	\N	f	t	2017-08-24 06:51:41.239394+00	2017-08-24 06:51:41.239394+00
1	onezeronine	$2a$08$GVGy1cO0vHglqKY/P6lC.ue7cCf5OW.90VRt2H4CLyldZwXqZPe1C	kenneth.g.bastian@descouvre.com	Manunulat at programmer ng Wanderast at Liham.ph	f	t	2017-07-12 08:16:56.497037+00	2017-08-22 10:57:45.041162+00
44	Pao	$2a$08$xi8hfR/vCBEh5HQzX9DM3.v5uGdyUGKh4pQA2wCD38TUEZ5lpE852	\N	\N	f	t	2017-08-27 05:11:08.630614+00	2017-08-27 05:11:08.630614+00
20	chocnut	$2a$08$xb2y/wE/1nCJlQbqi5m6OeViWwH1uepWtT4y.N3KWholBEXk9jQE.		ating sayawan ang buhay sa saliw ng pag-ibig ng Hari ng mga hari	f	t	2017-07-17 02:58:12.466825+00	2017-10-30 01:10:10.403046+00
45	EK	$2a$08$cTadlWjgE3wYyVZ2Qi3Fd.GgPZa.s4UaEo0wn8wtqCPRyjrJ/Qrgy	\N	\N	f	t	2017-11-05 14:25:09.450783+00	2017-11-05 14:25:09.450783+00
46	velika	$2a$08$ck76ScAbH0ReiF/xvoKM1OmN7YxCqrMBYYQjJNbWEjN8dZ6Om8T7u	\N	\N	f	t	2017-12-17 07:27:56.568689+00	2017-12-17 07:27:56.568689+00
47	penknife	$2a$08$m4jIvGwXvJ4gqfb7DI1ky.f394NK59aVJLsODk5EEMmcv5.zfPCuy		Hindi mo ako maiintindihan kung hindi mo ako titingnan nang malaliman.	f	t	2018-01-01 14:01:32.618625+00	2018-01-01 15:06:33.380811+00
49	onezeronine2	$2a$08$HrwTGkYezn/VdyQ15EHwCe/d52HApCC40UKZaRQmXITuIZTd3euQm	\N	\N	f	t	2018-01-23 08:43:36.253163+00	2018-01-23 08:43:36.253163+00
50	mapang_api	$2a$08$juqks.S/IlX/zpTaC0mMWe2O6TrLvRByMk1luQ48kCzShjK6Sb0QO	\N	\N	f	t	2018-01-25 11:08:04.675999+00	2018-01-25 11:08:04.675999+00
48	kahel	$2a$08$QO3nq8PHwmErE4bLgSl4Sua4d9aqcL4O/KrdX7FWfz/pReEAXPDEq	\N	\N	f	t	2018-01-16 08:54:55.844316+00	2018-02-07 14:52:00.855185+00
\.


--
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: core; Owner: lihamph
--

SELECT pg_catalog.setval('person_person_id_seq', 50, true);


SET search_path = posting, pg_catalog;

--
-- Data for Name: post; Type: TABLE DATA; Schema: posting; Owner: lihamph
--

COPY post (post_id, parent_post_id, topic_id, author_id, title, content, upvote_count, reply_count, is_edited, is_deleted, created_date, last_updated_date) FROM stdin;
3	2	2	1	Para sa mga patuloy na lumalaban	> Punyal at bala iyong handang harapin\r\n\r\nLahat tayo ay humaharap sa laban araw-araw. Nakakabilib ng liham 👍	0	0	f	f	2017-07-12 08:59:13.519645+00	2017-07-12 08:59:13.519645+00
4	1	1	2	Sa mga huni ng mga ibon	Ako ay namamangha sa iyong angking talento sa paglikha ng tula. Ito ay nagdulot ng luha sa aking mga mata.	0	0	f	f	2017-07-12 09:02:58.230871+00	2017-07-12 09:02:58.230871+00
6	\N	4	5	Tama Na	Buwan\r\nSiya ang saksi sa ating kahibangan\r\nSa halip na manatili sa katotohanan\r\nPiniling kumapit sa kaligayahan.\r\n\r\nIto'y magiging nakaraan\r\nYamang pinili nating humakbang\r\nPatungo sa Kanya na mas nakakaalam\r\nAt lubos na nagbibigay kapayapaan.	0	0	f	f	2017-07-12 11:12:55.563494+00	2017-07-12 11:12:55.563494+00
10	5	3	2	Pag-ibig	Ang iyong tula ay isa sa mg dahilan bakit naniniwala ako sa pagibig, dahil ang pagibig ay paglikha at ang paglikha ay pagibig.	0	0	f	f	2017-07-12 15:56:40.846167+00	2017-07-12 15:56:40.846167+00
14	13	10	2	Ere at Plano	kamangha-mangha ginoo, mula sa pook-sapot na ito tayo ay lilikha ng mga makabagong La Liga Filipina	0	0	f	f	2017-07-13 03:58:36.217383+00	2017-07-13 03:58:36.217383+00
16	12	9	11	Langit	as	0	0	f	f	2017-07-13 13:09:42.414258+00	2017-07-13 13:09:42.414258+00
17	12	9	11	Langit	noyz!! :D	0	0	f	f	2017-07-13 13:10:22.927205+00	2017-07-13 13:10:22.927205+00
19	\N	13	11	Salamat	Gusto ko lang naman\r\nna marinig ang mga \r\nsalitang galing sayo na\r\n"Salamat at nandiyan ka"\r\n"Salamat at meron akong\r\nisang katulad mo."\r\n\r\nPero wala.\r\nAt hindi ako\r\nHindi ako yung pinagpapasalamat mo.\r\nSalamat ha?	0	0	f	f	2017-07-13 13:21:04.599535+00	2017-07-13 13:21:04.599535+00
13	\N	10	9	Ere at Plano	Ayoko na nga sana pero, noon pa.\r\nNoon pa nang pangarapin ko siya.\r\nNgayon na abot-tanaw na,\r\nAno't gulong-gulo pa?\r\nDi naman daw kailangan na.\r\nPakikinggan ko ba?\r\nItutuloy ba o iuurong siya?\r\nPag-asa'y nandoon kaya?\r\nMinsan ayoko na, suko na.\r\nNgunit, makita ko silang sagana,\r\nPagsisikap ay tunay na ligaya.\r\nHayaan ninyo itutuloy ko siya,\r\nAng pangarap ko na, noon pa.	1	0	f	f	2017-07-13 02:44:29.768663+00	2017-07-15 17:24:01.662558+00
2	\N	2	2	Para sa mga patuloy na lumalaban	Sa mga lumalaban kahit duguan, ang mensaheng ito ay para sa inyo\r\npara sa mga may dugong, nananalaytay sa iyo na mula pa sa mga katipunero\r\n\r\nPunyal at bala iyong handang harapin,\r\nmaliban na lamang sa pagdurusa na malalim\r\nhatid ng kanyang mga labi, na humalik sayo habang nagpapaalam\r\n\r\nAko'y sumusulat para sa iyo.\r\nSa dugo at pawis at sakit ng pagibig\r\nat ng kanyang anino...\r\nhabang siya ay paalis, paalis sa iyong piling\r\n\r\ntama na, umaga na, oras na para gumising.	0	1	f	f	2017-07-12 08:33:08.266768+00	2018-01-25 11:08:39.718402+00
12	\N	9	7	Langit	Para kong manhid,\r\npero ramdam ang bawat hinanakit\r\n\r\nNa tila ba walang bahid ng sakit,\r\nhabang ako'y namimilipit\r\n\r\nPutulin mo na ang lubid,\r\nupang ako'y makarating na sa langit	1	0	f	f	2017-07-13 01:02:59.669683+00	2017-07-15 17:25:18.708762+00
8	\N	6	4	Tula 1 - Ang simula at ang huli	Tapusin natin ang ating pagsasama,\r\nNa ating pinag-hirapan,\r\nBuhat sa humantong na hindi inaasahan,\r\nWalang bakas ng luha kang mababatid\r\nSa aking mga pisnging pulang-pula\r\nSapagkat ang aking pisngi ay manhid\r\nSa diwa at pait na aking dinanas.\r\n\r\nKaya sa oras na ito ay wakasan natin\r\nAng ating mga damdaming umaapaw\r\nSa pag-ibig, lungkot at takot\r\n\r\nMagsimula muli ng bagong kasarinlan,\r\nDahil hindi ako mabubuhay kapag\r\nAng iyong liwanag ay nakalimutan\r\nNg aking mga mata\r\nKung saan nabighani sa ganda\r\nAt mag-dasal sa may-kapal\r\nNa sa bukang liwayliway ay ikaw\r\nMamasdan pagkatapos ng dilim.	2	0	t	f	2017-07-12 13:08:43.411143+00	2017-07-27 06:49:00.955647+00
40	\N	29	9	Dagupan	Kay saya kapiling niya na.\nTanaw ko iyon sa kanyang mata.\nPighati na dulot niya, \nSa aki'y di pa nabura.\nLandas niya'y bago na,\nGagawa na siya ng pamilya.\nSiguro nga akin siya noong una. \nNgunit, paalam. Tatanggapin ko na.	4	1	f	f	2017-07-18 15:03:08.412437+00	2017-07-29 02:34:30.685057+00
18	\N	12	11	Magkasama	Gusto sana kitang isama\r\nsaking mga pangarap,\r\nat saking kinabukasan.\r\nYung tayong dalawa lang.\r\nWalang iba\r\nwalang kasama\r\nwalang sila.\r\nTayo lang.\r\nSana gusto mo rin.\r\nAt sana, sumama ka.\r\n\r\nKung hindi man,\r\nako'y lalayo na lamang.\r\nDi kana gagambalain pa.\r\nHahayaan ka,\r\nmabuhay sa buhay na nais mo.\r\nMahal kita.	1	0	f	f	2017-07-13 13:20:31.816766+00	2017-07-30 06:25:34.196629+00
96	\N	51	19	Bitaw	Hindi ko na kayang kumapit\nMasyado ng masakit\nMasyado ng mapait	3	2	f	f	2017-07-28 05:54:29.09809+00	2017-08-04 06:07:46.088693+00
104	101	53	2	Takot	Nararamdaman ko ang hinagpis sa iyong mga tula. Ito ay nagdudulot ng mapait na lasa ngunit may init pa rin ng pagibig na nararamdaman sa bawat paksa	0	0	f	f	2017-07-28 06:35:59.546356+00	2017-07-28 06:35:59.546356+00
1	\N	1	1	Sa mga huni ng mga ibon	Ang mga huni ng mga ibon\r\n\r\nAy tahimik, payak at malambing\r\n\r\nSa aking dalawang tenga na bingi,\r\n\r\nDahil sa binigay mo sa aking pait.	1	1	f	f	2017-07-12 08:19:46.844711+00	2017-11-05 14:27:41.332474+00
95	15	11	19	Patak	Sa kanyang paglisan, nawa'y muli mong matagpuan ang iyong kasiyahan	0	0	t	t	2017-07-28 05:47:32.13783+00	2017-07-28 08:47:31.435106+00
94	\N	50	19	Paalam	Sa pagbitaw sayo, kaibigan,\nMatatagpuan ko bang muli ang kapayapaan?\n\nNatutunan na kitang mahalin,\nSubalit hindi mo ata ito kayang ibalik saakin.\n\nLabis ang kagalakan tuwing ika'y kasama,\nNgunit mas lamang ang pait na nadarama.\n\nBigyan mo ako ng rason upang manatili,\nPangakong hindi na ako lilisang muli.\n\nPero sa ngayon,\nPaalam muna, kaibigan. \n	2	0	f	f	2017-07-28 05:34:48.556792+00	2017-08-04 06:07:46.90106+00
7	\N	5	6	Nalilito	Marahil ikaw ay nalilito sa iyong buhay. Maraming bagay ang gumugulo sa isipan mo, kagaya ng pagiging praktikal ba or sundin ang sinasabi ng iyong puso? Isusugal ko ba ang aking mga ari arian sa ngalan ng kadakilaan? Lalaban ba ko sa agos ng buhay para mapatunayan na di ko kailangan makipagkompromiso sa mundo? \r\n\r\nPero kung ano man ang naiisip mo, kapatid. Nais ko lang sabihin sayo na kahit ano man yang pagsubok na kinakaharap mo, di ka iiwan ng Diyos ama at mapagtatagumpayan mo yan.	1	0	f	f	2017-07-12 12:54:27.107213+00	2017-08-04 02:38:33.96425+00
79	\N	47	19	Hiling	Sana dumating ang umaga\nNa bibigyan mo ako ng halaga\n	4	5	f	f	2017-07-27 11:28:46.986221+00	2017-08-04 03:59:25.613379+00
15	\N	11	2	Patak	Sa pagpatak ng ulan ako'y bumilang.\r\n\r\nIsa, patak.\r\n\r\nDalawa, patak.\r\n\r\nSa iyong pagbagyo hindi makalisan.\r\n\r\nTatlo, patak.\r\n\r\nSa pagpatak ng ulan ako'y iyong iniwan.	0	2	f	f	2017-07-13 08:47:18.691912+00	2018-01-25 11:15:46.317579+00
20	\N	14	11	Ako lamang	Gusto ko sanang ako ang hahawak\r\nng iyong kamay;\r\nat sayo'y aakbay habang naglalakbay\r\nat nangangarap ng sabay.\r\nGusto ko sanang ako ang iyong tatakbuha--\r\nlalapitan, at iiyakan,\r\nsa anumang hinaing mo sa buhay.\r\n\r\nNgunit titingin nalang sa malayo.\r\nIiwas ng tingin\r\nat hindi lilingon sa inyo.\r\nWari'y hindi na lamang nakikita\r\nkahit na damang dama.\r\nNa hindi ako, kundi siya.\r\nSapat na---\r\nna minamahal kita.\r\nKahit walang pabalik\r\nmula sa iyo.\r\nSapat na---\r\nna sa ating dalawa,\r\nako lang ang nagmamahal.\r\nSapat na.	0	0	f	f	2017-07-13 13:22:06.698535+00	2017-07-13 13:22:06.698535+00
21	\N	15	11	Liwanag	Tila, isa kang liwanag.\r\nsa mga oras ng buhay ko\r\nna wala akong maaninag,\r\nkundi ang mga mahihinang\r\nilaw ng alitaptap.\r\nMga ilaw na iindap indap.\r\n\r\nAt ako'y umaasa.\r\nNa baka lumakas pa.\r\nAng ilaw mo,\r\nat tayo'y magka pagasa.\r\n\r\nNgunit,\r\nDi na lang pala aasa.\r\nDahil\r\nisa ka nga palang pailaw\r\nsa oras ng gabi.\r\nMalakas man o mahina\r\nang iyong ilaw\r\nisa ka paring liwanag--\r\nMaski na isa kang ilaw \r\nng buwan\r\nng mga butuin\r\no poste ng ilaw\r\nalam kong mawawala ka rin\r\npag dating ng "araw"	0	0	f	f	2017-07-13 13:25:48.736847+00	2017-07-13 13:25:48.736847+00
22	\N	16	14	malaya	Sasamahan kita kahit saan.\r\nHindi magsasawa ang aking mga paang maglakad\r\nSa mga mahahabang kalsada na pinalilibutan ng lungkot at dilim, \r\nbasta ba ipangako mo sa akin na sa dulo nito, maghiwalay man ang ating landas pag-uwi,\r\nay baun-baon ko ang kasiguraduhan na hindi dito magtatapos ang lahat.\r\nNa hindi ito ang uri ng pag-ibig na paggising mo ay maaaring mabura ito sa isang iglap. \r\nNa sabay tayong susugal at ‘di papansinin\r\nAng mga matang kanina pa’t nakatingin.\r\nAng mga palad na ito, medyo namamawis na pero pipilitin kong patagalin pa ang paghawak,\r\nDahil alam ko, mahal, paparating na ang sigwa.\r\nGaano man kaganda ang pinapangako nitong simula,\r\nKapalit nito ay masakit na paalam na may kasamang luha.\r\nKaya habang naririto pa ako, at naririyan ka pa,\r\nSasamahan kita kahit saan.\r\nKasama ang panalangin na balang araw, ako naman ang iyong sasamahan.\r\n	0	0	f	f	2017-07-14 07:14:06.984256+00	2017-07-14 07:14:06.984256+00
24	\N	18	2	Liham Para Kay Nikky - Ikaunang Kabanata	Binibini, ikaw ay di ko man lamang napansin. Hanggang sa unang beses na ako ay napatingin.\r\n\r\nSa aking kaliwa ika'y biglang napaupo na para bang hanging amihan na sa dagat ay dumating.\r\n\r\nNagulat ang mga alon, ang daluyong na sigurado sa kanyang sarili. Ngayo'y mabait na bata na minamasdan ang hangin.\r\n\r\nHangin. Hangin ang nagdala sa iyo. Hindi inaasahan na liliparin. Ngunit sa mga sandaling iyon, nang ikaw ay unang masilayan nakilala ko ang hangin.\r\n\r\nHindi. Kahit hindi ko pa nasubukan lumipad, sa iyong mga mata alam ko na kaya ko. Hindi na ako natatakot tangayin. Hindi na ako natatakot sa hangin. Hindi na.	2	0	t	t	2017-07-15 04:49:01.658867+00	2017-07-16 01:13:55.567763+00
25	\N	19	15	Gutom	Kumukulo ang sikmura, isang linggo nang kumakain ng tira tira. Isang buwan nang walang gana. Halos humanap nang kakainin sa basura.\r\n\r\nNgunit araw araw ay masarap na handa, pinalaki sa isang mayaman na pamilya. sa bawat subo ay hindi nababawasan ang gutom.\r\n\r\nGutom. Gutom ang isip niya.	1	0	f	f	2017-07-15 05:00:09.401398+00	2017-07-15 17:30:12.393174+00
35	\N	26	4	Tula 2 - Anino mo sa ulan	Sa pagpatak ng mga ulan sa mga bintana,\nIyong mahabang, nakatirintas na buhok ay aking nasulyapan\nAt sa paggalaw ng mga gulong sa daan,\nAng iyong ngiti ang aking nakikita.\n\nSubalit sa bawat pagpatak ng ulan,\nIkaw ang gusto kong makatabi sa upuan,\nSa mga balikat mo ay nais kong sumandal\nKahit alam kong mahirap na matupad ang aking hiling.\n\nDahil sa bawat patak ng ulan,\nKahit aking payong ikaw ang gustong silungan,\nSa iyong malambing na bigkas na hindi ko mawari,\nAlam kong ayaw mo na, pero lungkot ko'y hindi mapawi.\n\nAt sa gabi ng huling patak ng mga ulan,\nAng wangis ng iyong anino ang umaawit sa aking mata\nHinihiling ko sa maykapal kung bakit ka niya pinaalala\nDahil alam ko ang ulan ay galing sa kanya.	3	2	f	f	2017-07-17 13:44:15.610754+00	2017-07-27 07:03:58.224841+00
36	\N	27	13	Saloobin	Nais kong iparating ang aking saloobin, sa liham na to'y sana yong mapansin. Alam mo bang labis akong nasaktan nang ikaw ay aking iwan? Pagsisisi sa pag alis na hindi kailaman mawawala. Patawad salitang sayo'y gusto kong ulit ulitin. Ako ang unang lumisan kasi hindi ko naipaglaban, pagtitinginang nagwakas ngayon ba'y hindi na kayang balikan?\n\nIlang taon na ang nakaraan pero sayo akoy umaasa. Babalik ka at muli tayoy magiging masaya. \n\nHanggang ngayon mahal na mahal pa rin kita.\n\n\nR.A.D	1	1	f	f	2017-07-17 14:27:18.946436+00	2017-07-18 06:03:54.068364+00
26	1	1	1	Sa mga huni ng mga ibon	@anginiwannglubhaan maraming salamat kaibigan	0	0	f	f	2017-07-15 17:24:44.762718+00	2017-07-15 17:24:44.762718+00
38	\N	28	2	Ang pag-ikot	Sabi nila hindi masama ang mundo dahil masama ang tao subalit, masama ang mundo dahil sa mga mabubuting tao na hindi umiimik.\n\nHindi naman sa hindi nararamdaman ng kanilang mga puso. Karamihan sa mga pusong ito ay tumitibok para sa mabubuting bagay.\n\nIto ay nagmamahal at nakikipaglaban para sa tama.\n\nDumadagundong, sumasabog, kumukulog para sa katarungan, katotohanan at kapayapaan.\n\nHanggang sa humina.\n\nAng sugat ay humihilom.\n\nAng sigaw ay naging bulong hanggang sa ang bulong ay naging katahimikan. Balik sa normal na buhay.	1	1	f	f	2017-07-18 00:16:27.103929+00	2017-07-20 07:05:14.944311+00
87	\N	48	19	Sana	Sana magising na ako sa katotohanan\nNa sa akin wala kang pakialam\nGusto ko ng bumalik sa katinuan\nTama na ang katangahan	3	0	f	f	2017-07-27 12:34:36.295305+00	2017-08-04 03:59:27.695592+00
85	70	46	26	makata	@AngMangingibig salamat sa iyong tugon :)	0	0	f	f	2017-07-27 12:26:41.610774+00	2017-07-27 12:26:41.610774+00
86	56	38	26	kadiliman	@anginiwannglubhaan salamat sa iyong tugon, kaibigan :)	0	0	f	f	2017-07-27 12:27:54.568873+00	2017-07-27 12:27:54.568873+00
56	\N	38	26	kadiliman	Kadiliman\nWalang hanggang\nKaitiman\nMalawak na\nKalaliman\nNg gabing walang talà\n\nKadiliman\nWalang hanggang\nKaitiman\nWalang pumapasok\nSa isipan\nIsang gabing walang tula\n\nKadiliman\nWalang hanggang\nKaitiman\nWalang pumapasok\nNa kaisipan\nSa gabing walang talâ\n\nKadiliman\nNg gabing walang talà\nNg gabing walang tula\nNg gabing walang talâ\nWalang pumapasok\nNa kaisipan\nSa isipan\n\nHanggang magpahinga\nHanggang maghangad\nNg gabing may talà\nNg gabing may tula\nNg gabing may talâ\nHanggang magwakas\nAng kadiliman\nWalang hanggang kaitiman\nNg gabing walang talà\n	4	2	f	f	2017-07-26 09:02:59.785645+00	2017-07-27 12:27:54.568873+00
11	\N	8	8	Bata ka pa talaga...	Alam ko, nakakapagod na rin, 'di ba? Lagi mo na lang siyang tinitingnan mula sa malayo, napapangiti kapag nasisilayan siya, biglang iiwas ng tingin kapag bigla rin siyang napatingin sa iyo.\r\n\r\nAng problema sa atin, masyado na tayong kumportable sa sitwasyon natin. Kuntento na sa sulyap at pahaging na ngiti.\r\n\r\nMinsan ba, naisip mo nang lapitan siya? Naisip mo na rin bang umamin? Wala ka ring lakas ng loob, ano? 'Yan tayo e. \r\n\r\nKung ako sayo, lumapit ka. Sabihin mo. Ano pa ba ang hinihintay mo? Magkaroon siya ng kasintahan? At 'pag naunahan ka, anong gagawin mo? Magmumukmok? Magmamaasim? \r\n\r\nNakakasawa na ang luha at alak. Kailangang may gawin ka. Paano ka makikilala kung 'di ka magpapakilala? Paano ka sasagutin kung wala kang tanong?\r\n\r\nSabihin mong gusto mong makipagkaibigan.\r\nSabihin mong gusto mo siya at nakuha niya ang atensiyon mo.\r\nSabihin mong masaya ka kapag nakikita mo siya.\r\nSabihin mong bumabagal ang oras, dumaraan ang mga bulalakaw, at humuhuni ang mga ibon kapag nasusulyapan mo siya.\r\nSabihin mong siya ang kukumpleto sa buhay mo.\r\n\r\n...\r\n\r\nOo ngapala, malapit na ang anibersaryo niyo.\r\n\r\n	1	0	f	f	2017-07-12 16:03:31.076756+00	2017-07-15 17:25:19.872761+00
28	\N	21	16	Si lola	Sa aking balintataw ako'y nagbalik-tanaw\nPakiwari ko'y musmos palamang at nakakalong sa kinalakhan.\nO kay sarap sa pakiramdam ang pagsintang naglinang sa murang diwa't isipan.\nSa bawat pagpalit ng panahon ay laging nakaagapay at nagmamasid sa 'di kalayuan, nariyang nasambulat ng malakas na hampas ng hangin at yanig ng kalupaan ngunit 'di natinag sa kinatayuan, siyang tunay kong naging katuwang at naging sandigan. \nSa aking pagtangis at paghangos, ako'y ikinubli ng mga yapos at kahit nauupos siya ang nagpagapos.\nBatid ko ang walang kapantay na pagsinta na kahit 'di mamutawi ay kusang nangusap sa mga panahong hindi na mawawaksi. \nAt sa aking pag-inog unti-unti kong naaninag ang matang malulam at pagsapit ng dapit hapong biglaan. Ako'y 'di makaalpas sa pag-inog, pikit mata at taos pusong idinalanging muli na lang sanang pumihit sa pagbalik tanaw.	0	0	f	f	2017-07-16 05:32:31.001185+00	2017-07-16 05:32:31.001185+00
29	\N	22	16	Pangungulila	Nang aking ilapat ang hapong katawa't isipan dagli namang napagtagumpayan ang minimithing kapahingahan, ngunit hindi nagtagal ako'y naalimpungatan at nakatunghay lamang sa kawalan. \nMuli kong binalikan ang naglalaro sa isipan at hindi napigilan ang kalungkutan, ninais kong ika'y abutin upang ika'y aking mahagkan ngunit tumambad ang asap na iginuhit lamang nang aking kaisipan.\nMuling naglaro sa aking kamalayan ang mga panahong ating pinagsamahan, mga sandaling naimpok at pwede kong balikan, oh kay ikli ngunit makabuluhan. \nAko'y lubos paring nagdadalamhati sa iyong paglisan, atin mang paglabanan hindi naman hawak ang kaloob nang maylalang. \nIsang taimtim na dalangin ang sa iyo'y aking ipinarating ng sagayon iyo paring marinig ang aking saloobin, hindi ko man matunghayan ang tugon na iyong isinukli alam kong ito'y nagdulot sa iyo ng kagalakan at iyon ay sapat na para sa akin.\n	0	0	f	f	2017-07-16 05:34:48.467443+00	2017-07-16 05:34:48.467443+00
30	\N	23	17	Tungkulin	Kung maisisigaw ko lang ang lahat\nkaya kong sasabihin nang kompleto\nkung mailalahad ko ang lahat \nmaisusulat ko nang buong -buo\nwalang labis, walang kulang\npero paano? \nhindi ko magawa dahil kailangang ipinid ang bibig, kailangang itiklop ang kamay,  nararapat na iyuko ang ulo\nhindi gulo ang idinayo ko, \nhindi rin yabang\nat lalong hindi pagmamalaki ang dahilan\niisa lang ang nais ko..\ngampanan ang tungkulin\nat ituloy ang adbokasiya\nbilang guro ng lipunan \nbilang guro ng bayan..\nkaya pakiusap\ntantanan mo ako...:)	0	0	f	f	2017-07-16 05:41:22.957903+00	2017-07-16 05:41:22.957903+00
31	\N	24	17	Lihim	malungkot \ndi ko masabi\nngunit\ndapat ilihim\n\nayoko na talaga\nngunit ang hirap umiwas\nparang droga \nhinanap hanap\nnakatutuyo ng lalamunan\n\nkung alam lang  nila\nitong pagdurusa\nkung pd lng talaga \nipaalam sa kanya \n\nako na siguro\nang pinakamasaya\nmakasarili ba ako\nkung di ko masabi ang totoo?\n\nnalulungkot ako\nkapag naiisip ko\nyung mga ginawa ko\nayoko n talaga \n\nsana matungan nyo ako\nmahal ko ang asawa't anak ko	2	2	f	f	2017-07-16 05:43:14.834427+00	2017-07-17 00:07:17.676724+00
32	31	24	1	Lihim	> makasarili ba ako\n> kung di ko masabi ang totoo?\n\nTagos itong linya sa puso!	0	0	f	f	2017-07-16 14:05:59.473433+00	2017-07-16 14:05:59.473433+00
37	35	26	2	Tula 2 - Anino mo sa ulan	Mahusay! Nararamdaman ko ang pagpatak ng ulan sa iyong puso	0	0	f	f	2017-07-18 00:09:29.660105+00	2017-07-18 00:09:29.660105+00
34	31	24	2	Lihim	nararamdaman ko ang pag-guhit ng sakit sa iyong puso, ngunit ang mga pagsubok ay kailangan sa buhay. Hindi man tayo perpekto ngunit may tinatapos ang Diyos na likhain sa ating puso. Ako ay naniniwala na kung may lilikhain siya sa ating puso sa gitna ng sakit, ito ay ang magmahal nang mas matindi at nang mas lubusan.	0	0	f	f	2017-07-17 00:07:17.676724+00	2017-07-17 00:07:17.676724+00
27	\N	20	2	Liham para kay nikki - unang kabanata	Binibini, ikaw ay di ko man lamang napansin. Hanggang sa unang beses na ako ay napatingin.\n\nSa aking kaliwa ika'y biglang napaupo na para bang hanging amihan na sa dagat ay dumating.\n\nNagulat ang mga alon, ang daluyong na sigurado sa kanyang sarili. Ngayo'y mabait na bata na minamasdan ang hangin.\n\nHangin. Hangin ang nagdala sa iyo. Hindi inaasahan na liliparin. Ngunit sa mga sandaling iyon, nang ikaw ay unang masilayan nakilala ko ang hangin.\n\nHindi. Kahit hindi ko pa nasubukan lumipad, sa iyong mga mata alam ko na kaya ko. Hindi na ako natatakot tangayin. Hindi na ako natatakot sa hangin. Hindi na.	1	0	f	f	2017-07-16 01:13:43.19755+00	2017-07-18 00:11:28.183677+00
39	36	27	1	Saloobin	Isang tapik sa balikat sa mga pusong sawi.	0	0	f	f	2017-07-18 05:59:12.037391+00	2017-07-18 05:59:12.037391+00
42	40	29	2	Dagupan	Aking naramdaman ang iyong kalungkutan ngunit ikinagagalak ko rin ang iyong kalayaan	0	0	f	f	2017-07-19 12:51:03.074044+00	2017-07-19 12:51:03.074044+00
43	38	28	9	Ang pag-ikot	Anilay maski ang siyang di kumibo ay isang kasalanan.	0	0	f	f	2017-07-19 14:10:47.076013+00	2017-07-19 14:10:47.076013+00
33	\N	25	18	Tungkod	'Di akalain na ako'y hahawak nito\nUpang ako ay makalakad ng diretso\nAt nang mapuntahan ko ang aking si Lito\nMasulyapan man lamang ang kaniyang nitso\n\nMagagandang alaala ang kanyang iniwan\nNa buong buhay ko namang iniingatan\nPaboritong sagot niya ang salitang "ewan"\nPaboritong tanawin magandang kalangitan\n\nNapakasayang sariwain sa 'king isipan\nAng madalas na pagsandal niya sa aking likod\nTuwing siya ay pagod at nasa kahirapan\nSa paggawa niya ng kanyang sariling tungkod\n\nNamahinga na ng ilang taon ang aking irog\nAt ako naman heto na at uugod-ugod\nSa t'wing kami ay namamasyal sa tabing ilog\nGamit ko na ngayon ang dati n'yang tungkod\n\nSa aking palagay ay malapit-lapit na rin\nNa ako'y mahimlay sa tabi ng aking giliw\nIto'y binitawang pangakong aking tutuparin\nSalamat sa tungkod na nagbibigay ng aliw\n	0	0	f	t	2017-07-16 14:46:04.068672+00	2017-07-22 06:02:18.21964+00
91	70	46	2	makata	Napaka-malikhain nga! tama si @AngMagingibig Patuloy kang magsulat kaibigan :)	0	0	f	f	2017-07-28 00:29:14.718404+00	2017-07-28 00:29:14.718404+00
100	96	51	19	Bitaw	@hiraya Mas masakit, lalo na't ikaw lang ang nakakapit.	0	0	t	f	2017-07-28 06:03:08.954039+00	2017-07-28 06:03:29.515862+00
69	\N	45	26	ulan	sige, \nbuhos pa. \n\nbasain mo\nang kalupaan. \n\nsige,\nbuhos pa. \n\nanurin mo\nang aking luha. 	3	2	f	f	2017-07-27 01:59:48.297784+00	2017-07-28 08:21:12.405226+00
70	\N	46	26	makata	ako'y tutula,\nkahit mahaba.\n\nhindi magtatapos\nkahit mapaos.\n\npupunuin ng salita\nang kalawakan.\n\nyayapusin ang bawat taludtod\n\ndahil maha—	4	3	f	f	2017-07-27 04:31:00.0027+00	2017-07-28 08:21:18.424353+00
41	\N	30	21	Para san ka gumigising?	Para san ka gumigising?\n\nKapag minumulat ang aking mga mata, sa umaga gabi o kahit anong oras pa\nAko ay napapaisip at nagtataka,\nAko pa kaya'y buhay pa? Ako pa nga ba'y buhay pa? Hmmm o ang mortal katawan ko na lamang ang pumipilit sa akin na bumangon at gumising\n\nAno nga ba ang silbi ng mabuhay\nKung ang buo mong pagkatao ay sumuko na\nDugo sa laman dumadaloy\nPero ano ba rason para magpatuloy.\n\nKatawan ay buhay \nSilakbo ng damdamin unti unting pumapanaw\nParang kandilang nag aapoy na walang malay oras ay dahandahang nauubos\n\nNabubuhay tayo para mamatay\nNamamatay dahil tayo ay isinilang\nNgunit bakit takot na mapaslang\n\nHindi ako takot mamatay\nPero takot akong mabuhay\nPaano na lamang kubg walang marating\nPaano na lamang kung lahat walang saysay\nMga paghihirap sa kabuuan ako rin namang ang siyang nagpataw	1	0	f	f	2017-07-19 02:00:50.486755+00	2017-07-20 07:05:12.930492+00
45	23	17	23	Panatang Makabayan	Tama kapatid	0	0	f	f	2017-07-24 13:20:03.350013+00	2017-07-24 13:20:03.350013+00
50	\N	34	24	Bungang-isip na tula	Awit ng Buhay\n\nAng nais ko'y maging isang awit\nNa siyang patutugtugin mo\nSa umaga mong kay ganda\nAwit na magsisilbing gabay mo\nSa bawat pintig ng iyong orasan\n\nPaano bang maging awit?\nAwit na tatatak sa iyong isipan\nAraw man o gabi\nKahit hindi naririnig sa radyo o mp3,\nSa utak mo nama'y laging nadidinig.\n\nAwiting sabay-sabay na nagpakilala sa'yo\nNgunit iisang awit lang ang uulit-ulitin mo\n\nNais kong maging iyong awit\nNa hindi pagsasawaan\nMawala man sa uso\nBabalik-balikan pa rin\n\nNgayin, sasabihin kong nais\nKong maging awit\n\nHindi ng madla kundi ng tinakda\nTinakdang taong magihing awit din\nNg aking buhay\n\nAwit na ika'y paluluhain,\nPatatawanin, at pakikiligin\nAwit na hinding-hindi maluluma\nSapagkat sa iyong pandinig ay laging bago\nAt sariwa\n\nAwit na tabunan man ng panahon,\nMananatilinv paborito ng puso mong musikero.	1	0	f	f	2017-07-25 10:13:10.821396+00	2017-07-26 05:07:50.037295+00
48	47	33	4	Luha	> Kasabay ng pagpatak ng luha mo\n> Ay ang pagkawasak ng puso ko\n\nMaraming salamat sa pagbabahagi ng iyong damdamin.	0	0	f	t	2017-07-25 02:50:00.027922+00	2017-07-25 02:50:22.823544+00
49	47	33	1	Luha	Maraming salamat sa pagbabahagi ng iyong damdamin	0	0	f	f	2017-07-25 02:50:49.530426+00	2017-07-25 02:50:49.530426+00
51	\N	35	25	pagibig 	Sigarilyo at Alak\r\n\r\nSigarilyo at alak ang takbuhan\r\nSa tuwing naalala ka\r\nWalang ibang magawa\r\nKundi ang pilitin na kalimutan ka\r\n\r\nSa bawat usok ng sigarilyo na binubuga\r\nMalulungkot na ala-ala ang nadarama\r\nAt sa bawat lagok ng alak\r\nNa hahagod sa lalamunan ko\r\nMga matatamis mong salita ang naiisip ko\r\n\r\nSabay tutulo ang mga luha sa mata ko\r\nAt magsisindi ng panibagong sigarilyo\r\nSusundan ng bugtong hininga na may kasamang daing na \r\n"bakit ako pa?"\r\n\r\nSa pag pitik ng upos\r\nSana ganon kadaling pitikin ka palayo sa buhay ko na ginugulo mo\r\nDahil pagod na pagod na ko\r\nSana layuan mo na lang ako\r\n\r\nPero bakit sa patuloy na paglagok ng alak\r\nMas pinipili kong bumalik ka\r\nMali yatang uminom pa\r\nMas lalo lang kitang naaalala\r\n\r\nAkala ko sa paginom ng alak ay makakalimutan ka\r\nAt para sa huling sigarilyo na meron ako\r\nPara ito sa mga ala-ala na ibinigay mo\r\nHuling sindi ng ala-ala\r\nHuling buga ng mga problema\r\n\r\nPero salamat sayo\r\nUnti-unting nakakabangon ako\r\nAt eto na ang huling tula\r\nNa isusulat ko para sayo.\r\n\r\n\r\n	0	0	t	t	2017-07-25 13:23:50.441153+00	2017-07-25 13:24:21.093556+00
235	234	126	3	para kay mama	Ang lungkot...	0	0	f	f	2017-08-21 03:11:59.905844+00	2017-08-21 03:11:59.905844+00
103	89	49	2	Selos	@hiraya maraming salamat kaibigan!	0	0	f	f	2017-07-28 06:25:08.420934+00	2017-07-28 06:25:08.420934+00
46	\N	32	4	Tula 3 - Paniniwala sa nawala	Sa lahat ng bagay na aking ipagpapalit,\nIkaw pa ang aking nawala,\nKung ako'y mananatili at magagalit\nWala akong magagawa kung hindi manalig.\n\nSapagkat sa iyong paglisan\nAt sa aking pagdadalamhati,\nAko ay naniniwala sa mga ulap at araw\nNa sa aking nawalang pag-aari,\nKatumbas nito ay higit pa sa inaasahan\nDalawang beses na higit pa sa nawala	3	0	f	f	2017-07-24 15:28:24.683926+00	2017-07-26 05:17:10.491632+00
63	\N	44	3	Kita Kita	(Inspirasyon mula sa pelikulang, "Kita Kita"\n\nBabala: Maaaring makapagbahagi ng mahahalagang detalye mula sa pelikula. Basahin ayon sa iyong kagustuhan kung hindi pa napanonood.)\n\nNakita mo ako sa panahong ayokong makita ang mundo.\nSa panahong ipinikit ko ang aking mata sa nais niyang ipakita.\nNakita mo ako sa pagkakataong wala akong gustong tignan.\nAt nagpapalunod ako sa aking kalungkutan.\n\nAko ang nagsilbi mong mata. Ikaw ang nagsilbi kong paningin.\nIpinasilip mo sa akin ang pananaw ng bagong pag-asa.\nIpinakita ko naman sa'yo ang hating-patag ng pagsisimula.\n\nNakita mo ako nang nawalan ka ng paningin.\nNakita kita noong di mo ako masilayan.\nPinatunayang ang damdamin ay higit sa nakikita.\nKailan kaya kita muling makikita?\n	3	0	f	f	2017-07-26 16:46:09.834228+00	2017-08-20 08:07:53.391225+00
47	\N	33	19	Luha	Kasabay ng pagpatak ng luha mo\nAy ang pagkawasak ng puso ko\nAlam kong wala akong magagawa\nAng kailangan mo ay sya\n\nPunasan ang luha\nTignan ang aking mga mata\nNang maramdaman mo\nAng pagmamahal ko para sayo	4	2	f	f	2017-07-24 17:25:05.311685+00	2017-07-26 09:58:50.771738+00
105	97	52	1	tatlo	@Mirasol nakakalungkot ngunit kailangan natin harapin ang katotohanan. :'(	0	0	f	f	2017-07-28 07:46:47.614292+00	2017-07-28 07:46:47.614292+00
102	89	49	2	Selos	@onezeronine ginamit ko na kaibigan, siya ay nagalak, sinabi niya sa akin na pakiramdam niya raw ay napakahaba ng kanyang buhok sa ulo	0	0	f	f	2017-07-28 06:24:56.327075+00	2017-07-28 06:24:56.327075+00
89	\N	49	2	Selos	Oo magselos ka\n\nDahil maraming mas maganda sayo\n\nIkaw bukas...\nIkaw sa isang araw...\nIkaw sa isang linggo...\n\nIkaw ngayon. \nIkaw ngayon. \nIkaw ngayon...\n\nSa isang kisap mata mas maganda ka na sa sarili mo pagkatapos ng isang hininga.\n\nKaya magselos ka sa sarili mo,\ndahil mas mamahalin kita sa bawat segundo na magdaan.	3	4	f	f	2017-07-28 00:27:01.990406+00	2017-07-28 06:25:08.420934+00
109	\N	57	26	pagkikita	kung magkikita tayo\nngingitian kita,\nkagaya ng dati,\nkung magtagpo tayo ng landas. \n\nhindi mo mahahalatang\nmalungkot ako. \n\nhindi ko ilalabas \nang damdamin ko. \n\n"ayos lang ako."	3	1	f	f	2017-07-28 11:45:25.690059+00	2017-07-29 07:46:35.838427+00
97	\N	52	26	tatlo	bibitiw ako, \npagkabilang ko ng tatlo. \n\nisa. \ndalawa. \n... \ndalawa. \ndalawa.\n....\n\npatawad..\n\nhindi ko pa kaya. \n\n.... \ndalawa. \ndalawa.\n...	5	3	f	f	2017-07-28 05:56:30.706815+00	2017-07-29 07:47:54.355019+00
101	\N	53	19	Takot	Hindi ko alam kung paano ka haharapin\r\nSasalubungin ba ang mga tingin?\r\nTulad ba ng dati'y ngingiti pa rin?\r\n\r\nDahil sayo nasasaktan ako\r\nDahil sayo ako'y nagkakaganito\r\nAraw-araw mong dinudurog ang puso ko\r\n\r\nPero hindi mo alam\r\nWala akong balak ipaalam\r\nNatatakot ako sa kalalabasan\r\n\r\nNatatakot ako baka sakaling wala kang pakialam	3	1	t	f	2017-07-28 06:24:39.485747+00	2017-09-06 13:49:19.796558+00
234	\N	126	26	para kay mama	mama, \ngabi na po ako makakauwi. \n\n'wag kayong mag-alala. \nmag-iingat po ako. \n\n'wag kayong mabalisa. \n'wag niyong isipin na \nmakikita niyo ang katawan ko\nsa telebisyon. \n\nmama, \ngabi na ako makakauwi. \n\nmahal kita, mama. \n\npakisabi rin kay papa\nat kay bunso.\n\nhindi po ako sigurado\nkung makakauwi pa ako mamaya. 	8	4	f	f	2017-08-21 00:24:19.584547+00	2017-08-25 15:58:31.336241+00
53	52	36	2	Sigarilyo at Alak	Napakalupit ng tadhana, ngunit mas malupit ang puso na bumabangon at nagpapatuloy sa buhay.	0	0	f	f	2017-07-26 05:18:18.711359+00	2017-07-26 05:18:18.711359+00
55	52	36	19	Sigarilyo at Alak	Darating rin ang araw na ika'y tuluyang makakalimot sa pait na idinulot nya	0	0	f	f	2017-07-26 08:43:23.743263+00	2017-07-26 08:43:23.743263+00
77	59	41	3	wala	Hindi lahat ng nasaktan ay sumusulat... Pero lahat ng sumusulat ay nasaktan... Subalit, sana'y makita mo na ang iyong kaligayahan.	0	0	f	f	2017-07-27 06:57:09.723531+00	2017-07-27 06:57:09.723531+00
64	61	42	2	kasinungalingan 	ang ikatlo :(	0	0	f	f	2017-07-26 23:36:27.962333+00	2017-07-26 23:36:27.962333+00
58	\N	40	19	Umaga	Tuwing umaga\r\nHinihintay ko ang pagdating mo\r\nTuwing umaga\r\nHinihitay ko ang pagbati mo\r\nTuwing umaga\r\nHinihintay ko ang pagngiti mo\r\nDahil tuwing umaga\r\nMakita lang kita buo na ang araw ko\r\n\r\n	2	0	t	f	2017-07-26 09:20:16.524281+00	2017-08-04 04:00:01.834111+00
60	59	41	19	wala	dama ko ang sakit, kaibigan	0	0	f	f	2017-07-26 12:55:27.875798+00	2017-07-26 12:55:27.875798+00
67	52	36	3	Sigarilyo at Alak	May dahilan ang bawat pait at pighati. Sana'y malaman mo kung ano ang dahilan nang sa'yo.	0	0	f	f	2017-07-27 01:11:36.785053+00	2017-07-27 01:11:36.785053+00
59	\N	41	26	wala	wala na pala. \nwala na. \n\nang dating nag-iisang tala\nsa kalangitan, \nay may kasama na pala. \n\nnang maaabot na kita, \nmay humila sa akin pabalik\nng lupa. \n\nhanggang dito na lang. \n\nwala na talaga. \nwala na. 	3	3	f	f	2017-07-26 12:38:50.999856+00	2017-07-27 06:57:46.357487+00
54	\N	37	19	Pagtatagpo	Bakit nga ba tayo pinagtapo?\n\nPinagtagpo ba tayo upang magsilbing leksyon sa isa't isa?\nPinagtagpo ba tayo upang isa man lang sa relasyon natin ang maisalba?\nPinagtagpo ba tayo upang ang pagkakamali ng isa ay di na maulit pa?\n\n\nMay rason kung bakit tayo pinagtagpo. \nAt sana, tayo'y pinagtagpo upang manatili. \nHindi upang lumisang muli.	2	1	f	f	2017-07-26 08:41:43.106864+00	2017-08-04 06:07:42.46345+00
65	59	41	2	wala	kumakagat ang sakit sa aking puso sa iyong mga tula :( sanay ikaw ay maglimbag pa ng mas maraming tula	0	0	f	f	2017-07-26 23:37:04.046379+00	2017-07-26 23:37:04.046379+00
68	61	42	19	kasinungalingan 	Una :(	0	0	f	f	2017-07-27 01:17:47.686592+00	2017-07-27 01:17:47.686592+00
66	56	38	2	kadiliman	napakahusay ng pag-gamit ng umuulit na salit, nakakadagdag ito sa emosyon na nararamdaman ko sa iyong mga tula. Ipagpatuloy mo magsulat kapatid.	0	0	f	f	2017-07-26 23:39:14.336144+00	2017-07-26 23:39:14.336144+00
74	61	42	1	kasinungalingan 	ang pang-apat ay... kalimutan 😭	0	0	f	f	2017-07-27 06:39:51.138737+00	2017-07-27 06:39:51.138737+00
71	5	3	26	Pag-ibig	Sa aking palagay, ito ang totoong kahulugan at kahalagahan ng pag-ibig. Salamat sa iyong tula, kaibigan.	0	0	f	f	2017-07-27 04:59:51.355176+00	2017-07-27 04:59:51.355176+00
72	54	37	26	Pagtatagpo	minsan, tadhana ang gumagawa ng paraan upang mapagtagpo ang dapat na ipagtagpo. kung ipinagtagpo kayo sa isa't isa bunga ng tadhana, maniwala ka, pinagtagpo kayo upang manatili.	0	0	f	f	2017-07-27 05:27:33.651093+00	2017-07-27 05:27:33.651093+00
57	\N	39	26	hapunan	Malamig ang kalsada. Ginginaw ang kanyang balikat habang naglalakad siya. Basa ang kanyang nilalakaran, nararamdaman niya sa kanyang paang naka-tapak. Ang tanging nakapagpapainit sa kanyang katawa ay ang ulam mula sa karinderya. \n\nLumalamig na ang ulam. \n\nTumakbo siya upang maabutan ng kanyang pamilya ang init ng bagong lutong pansit na bunga ng isang linggong panlilimos at pagbenta ng sampaguitang nilikha ng kanyang maliit na kamay. Lumalamig pa ang ulam. Binilisan niya ang pagtakbo... hanggang tumigil siya sa harap ng isang kariton. \n\nMay init pa ang ulam nang magsalita siya. \n\n"'Nay, Ate.. kain na tayo.." \n\nHindi na nakagalaw ang mga katawan sa ilalim ng sakong ginawang kumot ng mag-ina. \n\nTuluyang nanlamig ang ulam. 	1	0	f	t	2017-07-26 09:14:29.040613+00	2017-08-13 07:25:15.99896+00
73	61	42	20	kasinungalingan 	ikalawa :|	0	0	f	f	2017-07-27 05:41:24.876192+00	2017-07-27 05:41:24.876192+00
61	\N	42	26	kasinungalingan 	una - hindi na kita iisipin\npangalawa - hindi na kita aabutin. \n\npangatlo–\n\nhindi na... hindi na kita mamahalin. 	4	4	f	f	2017-07-26 13:32:34.007309+00	2017-07-27 06:39:58.630584+00
75	62	43	1	Pamilya	gamitin mo ang wikang Filipino kaibigan.	0	0	f	f	2017-07-27 06:40:34.327253+00	2017-07-27 06:40:34.327253+00
62	\N	43	27	Pamilya	mama i wanna go back to baguio and work there.	0	1	f	f	2017-07-26 16:14:27.284806+00	2017-07-27 06:40:34.327253+00
76	70	46	3	makata	Simple subalit malikhain. Mahusay! :)	0	0	f	f	2017-07-27 06:46:30.847254+00	2017-07-27 06:46:30.847254+00
78	35	26	3	Tula 2 - Anino mo sa ulan	Ang ganda ng pagkakahabi. Makatotohanan at malikhain.	0	0	f	f	2017-07-27 07:03:58.224841+00	2017-07-27 07:03:58.224841+00
80	79	47	26	Hiling	maikli, ngunit tagos sa damdamin.	0	0	f	f	2017-07-27 12:03:59.685873+00	2017-07-27 12:03:59.685873+00
88	79	47	1	Hiling	Sa ilang salita lamang nabigyan mong buhay ang aking puso ngayong gabi. Maraming salamat!	0	0	f	f	2017-07-27 14:25:05.124708+00	2017-07-27 14:25:05.124708+00
81	79	47	19	Hiling	@hiraya salamat, kaibigan. Nais kong ipaalam na ang sagisag mo ay isa sa nga paborito kong salita.	0	0	f	t	2017-07-27 12:19:29.96537+00	2017-07-27 12:20:55.253346+00
84	69	45	26	ulan	@Mirasol salamat sa iyong tugon :)	0	0	f	f	2017-07-27 12:25:55.907658+00	2017-07-27 12:25:55.907658+00
82	69	45	19	ulan	Napakaganda ng mga tulang iyong isinusulat. Nais ko ring sabihin ang iyong sagisag ay isa sa mga paborito kong salita. Mabuhay!	0	0	f	f	2017-07-27 12:22:03.992113+00	2017-07-27 12:22:03.992113+00
83	79	47	26	Hiling	@Mirasol walang anuman, kaibigan. at salamat sa pagpaalam sa akin na ang aking sagisag ay isa sa mga paborito mong salita. napakaganda nga ng salitang ito :)	0	0	f	f	2017-07-27 12:25:04.111272+00	2017-07-27 12:25:04.111272+00
92	89	49	1	Selos	> Kaya magselos ka sa sarili mo\n\nGamitin itong linya sa totoong buhay	0	0	f	f	2017-07-28 02:19:07.473029+00	2017-07-28 02:19:07.473029+00
90	79	47	2	Hiling	Sumugat sa aking puso! napakasimple ngunit nakapagpinta ka ng larawan.	0	0	f	f	2017-07-28 00:28:20.642791+00	2017-07-28 00:28:20.642791+00
93	89	49	26	Selos	Napakaganda ng kahulugan ng iyong tula! Ipagpatuloy mo, kaibigan :)	0	0	f	f	2017-07-28 04:43:35.600556+00	2017-07-28 04:43:35.600556+00
110	106	54	19	pagkakaiba	Tagos sa puso..	0	0	f	f	2017-07-28 12:37:40.191503+00	2017-07-28 12:37:40.191503+00
98	96	51	26	Bitaw	Minsan talaga, mas masakit pa ang kumapit kaysa sa bumitiw.	0	0	f	f	2017-07-28 05:57:30.809117+00	2017-07-28 05:57:30.809117+00
99	97	52	19	tatlo	Naaalala ko sayo ang aking kaibigan. Sinambit nya ring hindi nya kayang bumitaw. Sa huli, sya ang binitawan. Kapit lamang, kaibigan!	0	0	f	f	2017-07-28 06:01:59.246132+00	2017-07-28 06:01:59.246132+00
120	97	52	2	tatlo	hindi man dumating ang tatlo, mahalaga ay patuloy na magbilang. walang kasiguraduhan ngunit ang pagsambit ay paglaban.	0	0	f	f	2017-07-29 07:47:40.635999+00	2017-07-29 07:47:40.635999+00
111	107	55	19	pagkakatulad	"pipilitin kong maging masaya, para sa 'yo."\n\nKahit nasasaktan ako	0	0	f	f	2017-07-28 12:38:57.201245+00	2017-07-28 12:38:57.201245+00
112	108	56	19	luha	Patuloy kang maglabas ng damdamin sa pamamagitan ng pagsulat. Saludo ako sayo kaibigan!	0	0	f	f	2017-07-28 12:39:52.302326+00	2017-07-28 12:39:52.302326+00
121	\N	61	2	Ang engkwentro	Ako'y sumilip sa aking kanan\r\nsa pagitan ng dalawang dingding na tila ba'y guguho na\r\nnaririnig ko ang putukan sa malayo\r\n\r\nang aking mga kasamaha'y namatay na. ako ay mag-isa!\r\n\r\nmga bangkay na nakapaligid sa aking mga paa\r\ndi na alam kung sino ang kalaban, sino ang kasama\r\nhindi ko na maisip ang maging isang bayani\r\ngusto ko lamang bumalik sa aking pamilya\r\n\r\nngunit ano itong kumukurot sa aking puso\r\nang kasiguraduhan na ako'y di na makakabalik\r\nna ito na ang aking huling gabi\r\nang aking mga huling sandali\r\n\r\nnang masigurado ang tunog na aking naririnig \r\nay ang walang tigil na pagtibok lamang ng aking puso, \r\nako ay tumakbo. \r\n\r\nngayon lang ako tumakbo ng ganito...\r\n\r\npatungo sa kadiliman...\r\n\r\npatungo sa engkwentro.	1	1	t	f	2017-07-29 07:55:00.097604+00	2017-07-30 11:41:18.544033+00
113	109	57	19	pagkikita	"hindi ko ilalabas\nang damdamin ko"\n\nKahit durog na durog ang aking puso	0	0	f	f	2017-07-28 12:40:42.731861+00	2017-07-28 12:40:42.731861+00
114	\N	58	29	Apoy	Hindi ako nasasaktan dahil wala ka na\nNasasaktan ako dahil nandiyan ka pa\n\nNandiyan ka pa kahit  damdamin mo'y naglaho na\nNananatili ka pa kahit lingas ng kandila'y wala na\n\nDi ko alam kung anong mas masahol\nAng umalis ng walang paalam\nO ang kahit walang dahilan, siya pa ring naghahabol	1	0	f	f	2017-07-28 12:52:43.965363+00	2017-07-28 13:07:38.549033+00
131	121	61	26	Ang engkwentro	wala akong masabi sa ganda ng iyong tula. pinupukaw niya ang isip at hinihila ang mga mambabasa sa bawat taludtod. mahusay ka, kaibigan!	0	0	f	f	2017-07-30 11:41:10.817969+00	2017-07-30 11:41:10.817969+00
122	108	56	2	luha	napakalakas ng mga damdamin sa isang maikling liham. ito ang dahilan kung bakit ginawa ang komunidad na ito.	0	0	f	f	2017-07-29 07:58:45.826518+00	2017-07-29 07:58:45.826518+00
107	\N	55	26	pagkakatulad	ngunit minsan naman,\nmagkatulad tayo. \n\nmasaya ka. \nmasaya rin ako.\n\nmasaya ako dahil masaya ka, kahit may ibang dahilan kung bakit masaya ka. \n\npipilitin kong maging masaya, para sa 'yo. 	4	2	f	f	2017-07-28 11:39:52.846112+00	2017-08-16 23:54:31.532022+00
123	115	59	2	Ninakaw na Tsokolate	kakaiba itong tula na ito. totoong nasagi ang aking kaisipan	0	0	f	f	2017-07-29 08:00:36.009966+00	2017-07-29 08:00:36.009966+00
116	115	59	19	Ninakaw na Tsokolate	Bibigyan na lang kita ng tsokolate, kaibigan. HAHAHA. Nagbigay galak sa akin ang iyong tula.	0	0	f	f	2017-07-28 14:15:27.69412+00	2017-07-28 14:15:27.69412+00
117	115	59	1	Ninakaw na Tsokolate	@Mirasol salamat sa paunlak, sapagkat nangangailangan ako ng tamis ;)	0	0	f	f	2017-07-28 14:55:49.134468+00	2017-07-28 14:55:49.134468+00
118	107	55	3	pagkakatulad	Mukhang magkasundo na kayo ni Mirasol, a. Maganda 'yan.	0	0	f	f	2017-07-28 16:21:21.209005+00	2017-07-28 16:21:21.209005+00
124	119	60	19	Mainis ka	Natamaan ako sa tulang ito. Sumisigaw ang katotohanan	0	0	f	f	2017-07-29 12:02:52.183335+00	2017-07-29 12:02:52.183335+00
106	\N	54	26	pagkakaiba	magkaiba tayo. \n\nmahal kita. \nmahal mo siya. \n\n.. magkaibang-magkaiba. 	4	1	f	f	2017-07-28 11:38:10.648072+00	2017-08-16 23:54:40.524375+00
128	\N	65	19	Hindi	Lisanin mo na ang aking isipan\n\nMaawa ka\n\nHindi ko na kaya\n\nMaawa ka\n\nHindi ko na kaya\n\nHindi na talaga	0	0	f	t	2017-07-30 03:13:05.060447+00	2017-07-30 10:06:40.695605+00
130	129	66	26	Minsan	minsan, malupit talaga ang tadhana. sana mahanap mo na ang taong para sa 'yo, balang araw, kaibigan.	0	0	f	f	2017-07-30 11:38:13.117917+00	2017-07-30 11:38:13.117917+00
129	\N	66	19	Minsan	Minsan na nga lang magmahal ng ganito\nNasasaktan pa\n\n\nSa dinami-rami ng mga tao\nBakit ikaw pa?\n	3	2	f	f	2017-07-30 03:16:47.940496+00	2017-08-04 06:07:51.136421+00
132	129	66	19	Minsan	Minahal ko sya hindi sa romantikong paraan. Minahal at mahal ko pa din sya bilang kaibigan. Hindi ko alam kung anong meron sakanya. Pero ayaw kong mawala sya sa buhay ko. Maraming salamat, kaibigan.\r\n\r\n@hiraya	0	0	t	f	2017-07-30 12:32:55.364285+00	2017-07-30 12:33:08.665551+00
127	\N	64	19	Bakit	Ang sabi ko'y tama na\nPero bakit naghihintay pa din\n\nAng sabi ko'y titigilan na\nPero bakit binabalikan pa din\n\nAng sabi ko'y di na aasa\nPero bakit umaasa pa din\n\nAng sabi ko sarili ko muna...\nPero bakit ikaw pa din ang inaalala?\n\n	2	0	f	f	2017-07-30 03:04:19.718586+00	2017-08-04 06:07:49.950893+00
108	\N	56	26	luha	hindi ako lumuha\nnang malaman mong mahal mo siya. \n\nhindi sapat ang luha. \n\nkaya, ang langit na lang ang nagbuhos ng damdamin. \n\n... bumuhos ng sobra-sobrang damdamin\n\nna hindi kayang ilabas ng luha. 	3	2	f	f	2017-07-28 11:42:40.773221+00	2017-08-16 23:53:57.099731+00
119	\N	60	2	Mainis ka	Mainis ka\nwag sa akin, wag sa kanya\nnakakainis mahirapan\nalam ko\n\nngunit anong maidudulot ng pagsigaw mo?\nmakakasakit ka lang\nanong maidudulot ng pagrereklamo?\n\nkung mainis ka man\nmainis ka sa iyong kahinaan\n\nmainis ka!\nmainis ka ng sobra!\nmainis ka ng mainis...\n\nhanggang sa ang iyong kahinaan \nay maging kalakasan \npara sa iyo - para sa ibang tao.	3	1	f	f	2017-07-29 07:46:05.084905+00	2017-07-30 11:39:38.730272+00
133	\N	67	26	paano	paano ba kita\nhindi mamahalin? \n\npaano ba kita\nhindi iisipin?\n\n...\n\nsiguro,\nhanggang tanong na lang\nang mga ito. 	3	2	f	f	2017-07-30 13:19:52.972882+00	2017-08-11 09:17:45.721171+00
125	\N	62	26	hiraya	bahagi lamang ako\r\nng iyong gunita. \r\n\r\nmakikita, ngunit hindi maaabot. \r\nmaglalaho, at hindi magtatagpo. \r\n\r\nbahagi lamang ako\r\nng iyong gunita. \r\n\r\nnabubuhay lamang ako\r\nsa iyong alaala. \r\n\r\nat sa iyong gunita lamang, \r\ntayong dalawa'y\r\nmakakatagpo. 	2	0	t	f	2017-07-29 15:15:07.427174+00	2017-08-16 23:52:16.300343+00
134	133	67	19	paano	Balang araw, mahahanap mo rin ang kasagutan sa iyong mga katanungan, kaibigan.	0	0	f	f	2017-07-30 19:05:30.72519+00	2017-07-30 19:05:30.72519+00
224	\N	120	40	Di ko alam	Di ko alam, kung pwede na.\nDi ko alam, kung pwede pa.\nDi ko alam, kung meron ba.\nDi ko alam, kung may dulo ba.\n\nHindi ko na alam.	1	1	f	f	2017-08-17 08:43:31.950823+00	2017-08-21 04:48:35.399527+00
293	\N	157	9	Kuyakoy	Walang gawa. Ito'y pumapatay,\nsa isip, sa katawan at sa iyong buhay.\nMayroon pang pag-asa.\nHuwag kang tamad.\nHumanap ng pagkaka-abalahan.\nIka'y may karangalan!\nIka'y kapapakinabangan!	2	0	f	f	2017-11-08 14:06:12.084271+00	2017-11-09 11:01:48.684227+00
5	\N	3	3	Pag-ibig	Ang tunay na pag-ibig ay pipiliin ang tama. Ang mabuti. Ang mahusay.\r\n\r\nPaiiralin ng pag-ibig ang katotohanan; wawakasan ang anumang pagkamakasarili.\r\n\r\nDahil ang pag-ibig na iniisip ang sarili, ay ang pag-ibig na nakakalimot. Makakalimutan nito lahat -- kahit ang pag-ibig. 	6	2	f	f	2017-07-12 10:49:06.29448+00	2018-01-25 11:10:10.969203+00
181	\N	93	19	Pero	Oo mahal kita\n Pero hindi ko na alam\nKung sapat pa ba ito upang manatili\n\nOo mahal kita\n Pero pareho na tayong nasasaktan\nAlam kong hindi na nakakabuti\n\nOo mahal kita\n Pero alam nating may nagbago na\nHindi na ako tulad ng dati\n\nOo mahal kita\n Pero di ko na alam kung kaya ko pa\nPano ba ipaiintindi\n\nOo mahal kita\n Pero...\n\n	3	1	f	f	2017-08-04 13:57:21.661708+00	2017-08-21 12:17:27.11839+00
183	\N	95	39	Pag Ibig ng Isang Ina	Munting anghel sa aking bisig\nYakap ko'y iyong damhin\nPuno ito ng pagmamahal at lambing\nNg isang inang di habang buhay mong kapiling\n\nSa iyong paglaki'y wag kalimutan\nNa ika'y minsang dinala sa aking sinapupunan\nLumaki ka man at lumayo\nPalagi kang mananatili sa puso't isipan ko... 	1	0	f	f	2017-08-04 20:19:03.492392+00	2017-08-05 07:00:32.298596+00
149	\N	76	2	Kulang	Kulang.\n\nKulang ako...\nKulang ka...\nKulang ang dalawa\n\nKung tutuusin di na siguro kaya\nNg ating pagibig na pumuno ng mumunting tasa\n\nSaan tayo kukuha\nNang pagibig na wagas at kaya?\nKayang pigilang ang mga luha\nO paluhain...\nPaluhain ang mga tala\n\nHigit pa sa ating dalawa\nAndiyan siya...\nIsang dakilang Diyos\nNa namatay sa krus\nPara sa mga tao \nat sa ating dalawa\n\nDalawa...\nKulang ang dalawa\nKung tayo ang magbubuhat ng krus ng pagibig siguradong...\nHindi!\nh i n d i   n a t i n   k a y a...\n\nDagdagan ng isa...\nIsang Diyos na nagpakita\nNg tunay na pagibig na nagmula sa kanya\n\nAng pagibig na kulang\nNgayon ay sobra sobra!\n\nAt dahil minahal ka na niya\nBago ko pa nasambit na mahal kita\nKaya mo na\nAt kaya ko na\nMagmahal ng\n\nSobra.	2	2	f	f	2017-08-01 14:11:25.527251+00	2017-08-03 13:34:22.105801+00
126	\N	63	29	Anong oras na ba? Paano ba basahin 'to?	Minahal kita nung mga oras na di ako marunong magbasa ng orasan\n\nMinahal kita nung mga oras na di mo ako mahal\n\nMinahal kita nung mga oras na di mo ako gustong mahalin\n\nMinahal kita nung mga oras na di mo ako kayang mahalin\n\nMinahal kita nung mga oras na di ko alam ang rason\n\nMinahal kita lalo na nung mga oras na di ka kamahalmahal\nKasi yun yung mga oras na kailangang kailangan mong maranasang ang mahalin\n\nHindi kita mahal. Minahal kita.\n\n	3	0	f	f	2017-07-29 17:35:10.703441+00	2017-08-03 14:25:24.65204+00
23	\N	17	6	Panatang Makabayan	"Sisikapin kong maging isang tunay na Pilipino sa isip, sa wika, at sa gawa."\r\n\r\n\r\nPanatang makabayan, pinakabisado sa atin to mula elementarya hanggang hayskul. Napakaganda ng mensahe pero naisasapamuhay ba natin? \r\n\r\nSa wika- KItang kita na sa lahat ng antas ng paaralan na mas pinapangahalagahan ang wikang Ingles kaysa sa atin. Papagalitan ka ng guro mo pag ginamit mo sarili mong wika o minsan sasabihan ka pa ng "i dont understand you." \r\n\r\nSa isip- Pag may mga umaasensong Pinoy, madami rin ang gumugustong pabagsakin siya. Halimbawa na lang si Pacman, kahit anong gawin niyang maganda sa bayan ay sobrang dami pa rin babatikos sa kanya. Yan ba ang tunay na mga Pinoy? \r\n\r\nSa gawa- Mga magnanakaw, kurakot, nanlalamang sa kapwa. Tama ba na kumuha ka sa kaban ng bayan para sa sarili mong kapakanan? Tamang bang tutukan mo ng kutsilyo ang isang estudyante sa ubelt para makuha lang ang pera niya? Ganyan ba ang gawain ng isang tunay na nagmamahal sa bayan?\r\n\r\n\r\nGising mga kapatid! Ang ganda ng bayan natin kung lahat tayo nagkakaisa at nagtutulungan. 	2	1	f	f	2017-07-15 03:52:15.361776+00	2017-08-04 02:38:35.143065+00
225	\N	121	40	Kung maging tayo	Kung maging tayo\nPuso ko'y sayo\nKung maging tayo\nOras ko'y ilaan sayo\n\nMangangako,\npero hindi mapapako.\nSa panahong iyon\nSana wala ng "kung"\n\nAng meron lang ay\nTAYO.	2	2	f	f	2017-08-17 08:50:32.634969+00	2017-08-20 11:05:33.395114+00
186	\N	98	39	Tanglaw sa Dilim	Isang gabi ako'y nangarap...\nPagdilat ko'y ikaw ay kasama...\nHawak iyong kamay,\ndali-dali't naglalakad\nsa mabatong buhangin\nsa gilid ng dagat.\n\nSimoy ng hangi'y sagana\nMalamig na hampas ng tubig alat\nMata'y tinignan...\nPuno ng tuwa\nPisngi'y namumula \nTulad ng rosas sa umaga.\n\nHinagkan mo ako't\nmatamis mong sinambit\n\nMahal kita mahal...\nMahal kita ❤	1	0	f	f	2017-08-04 20:21:57.762034+00	2017-08-05 07:00:34.2176+00
180	\N	92	34	tibôk ng pusò sa dapit-hápon	kung yka'y tibôk ng pusò\r\nsa dapit-hapon, ykao ang:\r\n  1. taás-babáng bulubundûkin\r\n     sa matamláy na abot-tanâo\r\n  2. apóy na úlap na umaágao\r\n     sa búhay ng árao\r\n  3. dagundông ng kulôg\r\n     sa gitnà ng katahimîkan\r\n\r\nngunit ióng ylapît ang pandiníg\r\nsa kabádong dibdíb at\r\nalingao-ngâo ng katahimîkan\r\nang ióng marírinig\r\n	5	1	t	f	2017-08-04 13:49:14.326096+00	2017-08-07 00:42:21.632731+00
188	185	97	34	Tanglaw sa Dilim	hábang binabása ko ay halos dinalâ akó níto sa tabíng-dágat. ang pagkakakumpól ng mga salità ay nagbigáy ng ymáje na tilá ba ay nandúruon akó at naráramdaman ang mga emoción na ióng ramdâm habang ysinusúlat ang ióng lîham. majúsay!	0	0	t	f	2017-08-05 06:56:08.389721+00	2017-08-05 06:56:46.560893+00
187	\N	99	35	MJ	Nakilala ko siya sa pagsasama ng alaala, sa gitna ng umaga na tila'y tadhana.\r\n'Di ko hinanap ang ngiti ng tulad niya, o ng gandang 'ngalan siya, ngunit, ayan na:\r\nSa munting pag-usap, sa muntikang pagtagpo, sa muling pag-usbong sa pagsalubong ng tala,\r\nBiningi ang isip sa pusong lamig; pagtinging pinagkamalang pag-ibig sa pag-asang inakalang matagalang ligaya.	4	1	t	f	2017-08-05 01:51:14.838844+00	2017-08-07 05:17:27.357872+00
179	\N	91	26	panaginip	naaabot na kita\nnahahabol na kita\nsa aking pagtakbo\n\nunti-unting\n\tmaabot\n\t\tmagtatagpo\nhanggang...\n\nbumalik ako \nsa katotohanan. \n\tnakita ang sarili\n\tsa dating kinatayuan. \n\ninabot ng mga kamay\nang pampatulog\nsa tabi ng kama. \n\nkahit ilang oras pa,\n(lunok, sabay inom) \n\nkailangan ko maging masaya. 	3	0	f	f	2017-08-04 13:12:24.992032+00	2017-08-11 09:17:30.618136+00
185	\N	97	39	Tanglaw sa Dilim	Isang gabi ako'y nangarap...\nPagdilat ko'y ikaw ay kasama...\nHawak iyong kamay,\ndali-dali't naglalakad\nsa mabatong buhangin\nsa gilid ng dagat.\n\nSimoy ng hangi'y sagana\nMalamig na hampas ng tubig alat\nMata'y tinignan...\nPuno ng tuwa\nPisngi'y namumula \nTulad ng rosas sa umaga.\n\nHinagkan mo ako't\nmatamis mong sinambit\n\nMahal kita mahal...\nMahal kita ❤	1	1	f	f	2017-08-04 20:21:57.288833+00	2017-08-05 07:00:35.104662+00
184	\N	96	39	Munting Aklatan ni Inay	Saan mo ko dadalhin?\nMga pahinang puno ng salitang di ko mamaliw\nSa bawat dahon, laman ay samu't saring aliw\nMay bagong kaalaman ba na syang sisibol para sa akin?\n\nNakakatuwa't tila ako'y lilipad sa himpapawid...\nSa bawat kumpas ng daliri dito sa babasahin...\nImahinasyon ko'y iyong dalhin \nSa mundo mong walang humpay ang kulay at lambing... 📖	1	1	f	f	2017-08-04 20:20:18.605633+00	2017-08-07 00:46:14.913836+00
229	\N	124	26	kay fidel	(babala: ang mga susunod na taludtod ay naglalaman ng mga mahahalagang detalye mula sa pelikulang 100 tula para kay stella.)\n\nfidel,\n\nmahal kita, fidel. \n\ntatlong salita. \n\npero hindi pwede. \n\ntatlong salita. \n\npatawarin mo ako. \n\nmahal kita. \n\npero kailangan mong umusad\nnang mag-isa.\n\nmahal kita. \n\npero, dahil mahal kita,\nkailangan kitang bitiwan. \n\n... hindi ako karapat-dapat \nupang maging mundo mo. 	3	1	f	f	2017-08-20 08:34:12.876968+00	2017-08-21 08:57:45.107886+00
292	\N	156	26	kalyo	kinakalyo ang kamay\nna tinatahak ang kalye\nng papel na sinusulatan. \n\nkinakalyo ang kamay\nna mahigpit ang hawak\nsa plumang tumatahak\nsa kalye ng papel na sinusulatan. \n\nkinakalyo ang kamay\nna kumakapit sa pluma\nsa salita\nsa mga pangungusap\nhabang patuloy na tinatahak\nang kalye ng papel na sinusulatan.	2	0	f	f	2017-11-06 12:46:23.796736+00	2018-01-26 23:56:49.830235+00
139	\N	72	32	Babae ng Aking mga Pangarap	Alam ko sa sarili ko \nNapakalayo maging tayo\n\nAng iyong kutis na porselana\nAng itsura mong pang artista\n\nMga labi na aking minithi\nAng iyong matamis na ngiti\n\nAt kailanman hindi ko kayang mapagtanto\nkung dapat ba akong mulumbay o ano\n\nDahil nagawa kitang makasama sa kwarto\nSa halagang dalawang libong piso\n\n\n\n	5	2	f	f	2017-07-31 14:29:56.830983+00	2017-08-16 23:50:53.770675+00
145	\N	75	26	paalala	a\nba\nka \nda\nma \nha \nlin \nang \nsa\nri\nling\nwi \nka	4	1	f	f	2017-08-01 10:14:25.987336+00	2017-08-11 09:17:40.277254+00
137	\N	70	26	tadhana, anadhat	putol na, \nang pulang sinulid\nna nag-uugnay\nsa ating dalawa. \n\nwala na, \nang mga kulay\nna nakita ko\nnang ika'y aking\nunang nasilayan. \n\nnaglaho na, \nnaubos na, \nang hiwaga\nng tadhana. 	1	0	f	t	2017-07-31 13:04:24.966862+00	2017-07-31 13:19:57.963736+00
146	135	68	2	Bakit?	Nawa'y mabasa niya ito kaibigan	0	0	f	f	2017-08-01 13:54:30.15154+00	2017-08-01 13:54:30.15154+00
52	\N	36	25	Sigarilyo at Alak	Sigarilyo at alak ang takbuhan\nSa tuwing naalala ka\nWalang ibang magawa\nKundi ang pilitin na kalimutan ka\n\nSa bawat usok ng sigarilyo na binubuga\nMalulungkot na ala-ala ang nadarama\nAt sa bawat lagok ng alak\nNa hahagod sa lalamunan ko\nMga matatamis mong salita ang naiisip ko\n\nSabay tutulo ang mga luha sa mata ko\nAt magsisindi ng panibagong sigarilyo\nSusundan ng bugtong hininga na may kasamang daing na \n"bakit ako pa?"\n\nSa pag pitik ng upos\nSana ganon kadaling pitikin ka palayo sa buhay ko na ginugulo mo\nDahil pagod na pagod na ko\nSana layuan mo na lang ako\n\nPero bakit sa patuloy na paglagok ng alak\nMas pinipili kong bumalik ka\nMali yatang uminom pa\nMas lalo lang kitang naaalala\n\nAkala ko sa paginom ng alak ay makakalimutan ka\nAt para sa huling sigarilyo na meron ako\nPara ito sa mga ala-ala na ibinigay mo\nHuling sindi ng ala-ala\nHuling buga ng mga problema\n\nPero salamat sayo\nUnti-unting nakakabangon ako\nAt eto na ang huling tula\nNa isusulat ko para sayo.\n\n\n	4	3	f	f	2017-07-25 13:24:54.440477+00	2017-07-31 14:31:37.97547+00
140	135	68	1	Bakit?	Maraming salamat kaibigang Guerrero sa iyong pagbahagi ng iyong dinadamdam sa liham.ph. Nawa ay maging masaya ka sa iyong buhay at pagpalain ka ng maykapal.	0	0	f	f	2017-07-31 14:39:41.43408+00	2017-07-31 14:39:41.43408+00
141	133	67	1	paano	Kapag hindi mo na matiis, subukan mong tumayo ulit at magsimula uli mula sa wala.	0	0	f	f	2017-07-31 14:52:38.882856+00	2017-07-31 14:52:38.882856+00
142	139	72	19	Babae ng Aking mga Pangarap	Napakaganda ng pagkakasulat, kaibigan!	0	0	f	f	2017-07-31 15:18:57.898103+00	2017-07-31 15:18:57.898103+00
173	\N	87	29	Di Ko Alam	Di ko alam kung kaya pa\nDi ko alam kung kaya na\nAng alam ko lang damdamin ko\nIkaw pa din ang inuuna\n\nDi ko alam kung maari pa\nDi ko alam kung maari na\nPusong dati tinibok ay wala pa\nPusong ngayo'y tinitibok ay wala na\n\nWala na akong aasahan\nWala na akong sisilayan\nDahil ika'y tuluyan nang lumisan \nAt ako'y iyong iniwang luhaan\n\nSalamat sa pananatili kahit di mo ko mahal\nSalamat sa pagkukunwaring ako'y iyong pinapahalagahan\nPatawad kung di ako tumupad sa pangako\nPatawad kung lumingon ako kahit ang hindi paglingon ang tanging bilin mo	0	0	f	t	2017-08-04 06:05:40.178096+00	2017-08-04 06:06:39.726291+00
147	138	71	2	tadhana, anahdat	Mahiwaga :)	0	0	f	f	2017-08-01 13:55:01.88044+00	2017-08-01 13:55:01.88044+00
151	150	77	2	Gracielle	Mahusay kaibigan!	0	0	f	f	2017-08-02 06:08:15.027463+00	2017-08-02 06:08:15.027463+00
136	\N	69	26	daan	binabaybay natin\nang dalawang magkahiwalay\nna daan. \n\nparehong tuwid, \nparehong walang hanggan\nang layo. \n\npatuloy nating binabaybay\nang dalawang magkahiwalay\nna daan.\n\nparehong tuwid. \n\nat kailanma'y, \nhindi magtatagpo. 	2	0	f	f	2017-07-31 12:19:20.2605+00	2017-08-11 09:17:44.622224+00
148	143	73	2	lílok	Napakahusay kaibigan!	0	0	f	f	2017-08-01 13:55:54.178372+00	2017-08-01 13:55:54.178372+00
138	\N	71	26	tadhana, anahdat	putol na, \nang pulang sinulid\nna nag-uugnay\nsa ating dalawa. \n\nwala na, \nang mga kulay\nna nakita ko\nnang ika'y aking\nunang nasilayan. \n\nnaglaho na, \nnaubos na, \nang hiwaga\nng tadhana. 	4	1	f	f	2017-07-31 13:20:23.539291+00	2017-08-11 09:17:42.162162+00
174	\N	88	29	Di Ko Alam	Di ko alam kung kaya pa\nDi ko alam kung kaya na\nAng alam ko lang damdamin ko\nIkaw pa din ang inuuna\n\nDi ko alam kung maari pa\nDi ko alam kung maari na\nPusong dati tinibok ay wala pa\nPusong ngayo'y tinitibok ay wala na\n\nWala na akong aasahan\nWala na akong sisilayan\nDahil ika'y tuluyan nang lumisan \nAt ako'y iyong iniwang luhaan\n\nSalamat sa pananatili kahit di mo ko mahal\nSalamat sa pagkukunwaring ako'y iyong pinapahalagahan\nPatawad kung di ako tumupad sa pangako\nPatawad kung lumingon ako kahit ang hindi paglingon ang tanging bilin mo	0	0	f	t	2017-08-04 06:06:16.349173+00	2017-08-04 06:06:45.633571+00
227	\N	122	38	buhos ng damdamin	'wag kang umiyak\n\n\nwala kang karapatang umiyak\n\n\nkinakailangan bang umiyak?\n\n\nano makukuha mo 'pag ika'y umiyak?\n\n\nwalang kang mapapala sa pag-iyak\n\n\nhindi ka dapat umiyak\n\n\nhindi ka iiyak\n\n\n\nikaw ay iiyak	2	1	f	f	2017-08-17 11:55:31.334458+00	2017-08-20 11:06:41.892986+00
170	\N	86	34	ibulông mo sa ákin	ibulông mo sa áking\r\nhoâg na akóng maghintáy\r\npagka't ika'y patungó sa láot:\r\nsa mga álon ika'y híhimlay\r\ndi man batîd ng ióng pusò\r\nkung bakít s'ya nga'ng hilîng\r\n'ibulong mo sa ákin' akíng giít\r\n'ibulong mo sa ákin' anong paít\r\n'ibulong mo sa ákin' mata'y pikít.\r\n\r\nhabang ang iong hakbâng\r\nay palaiò sa ákin\r\nmaghihintay pâ rin\r\nhanggáng takipsílim	7	2	t	f	2017-08-04 00:58:51.08354+00	2017-08-06 11:11:00.664349+00
232	227	122	2	buhos ng damdamin	napakahusay ng iyong istilo kaibigan! Ika'y magpatuloy sa pagsulat :)	0	0	f	f	2017-08-20 11:06:30.116527+00	2017-08-20 11:06:30.116527+00
150	\N	77	35	Gracielle	Sa rosas ako'y tumingin: tiniis ang tinik ng tangkay na may talim.\nPumapalibot, kumukulot sa kamay kong 'di dumurugo at 'di dumadapo.\nSa posas ng puso'y tangkain: nais pasanin, pinipilit ang pagtinging lihim.\nSa pagtanaw, sa 'di paggalaw, sa takot kinain ng halimaw, ginuho ang puso ng kabataang dumayo.	7	2	f	f	2017-08-01 15:51:20.709836+00	2017-08-03 13:55:36.350295+00
143	\N	73	34	lílok	'di kita nilímot gaia ng paglímot ng:\r\n  1. ngaión sa kahápon\r\n  2. ulân sa mga úlap\r\n  3. naudlôt na mga pangárap\r\n\r\npagka't gaia ng púsong nilílok\r\nng oángis ng iông hioágà\r\nlukúbin man ng lúmot sa pangungulílà\r\nikao at ikao ang s'iang sisílai\r\nkapag alab ay muling binúhai\r\n	3	5	t	f	2017-07-31 18:22:45.463702+00	2017-08-06 11:11:04.64472+00
175	\N	89	29	Di Ko Alam	Di ko alam kung kaya pa\nDi ko alam kung kaya na\nAng alam ko lang damdamin ko\nIkaw pa din ang inuuna\n\nDi ko alam kung maari pa\nDi ko alam kung maari na\nPusong dati tinibok ay wala pa\nPusong ngayo'y tinitibok ay wala na\n\nWala na akong aasahan\nWala na akong sisilayan\nDahil ika'y tuluyan nang lumisan \nAt ako'y iyong iniwang luhaan\n\nSalamat sa pananatili kahit di mo ko mahal\nSalamat sa pagkukunwaring ako'y iyong pinapahalagahan\nPatawad kung di ako tumupad sa pangako\nPatawad kung lumingon ako kahit ang hindi paglingon ang tanging bilin mo	3	2	f	f	2017-08-04 06:06:17.976739+00	2017-08-21 12:19:11.374003+00
164	\N	83	26	oras	tik,  tak. \n\numawit ang orasan. \numalingawngaw\nsa dating tahimik na silid. \n\nang awit ay bumalot\nsa mga taong walang imik,\nna panay silip sa mukha\nng lumang orasan. \n\ntik, tak. \n\nlimang minuto pa. 	5	0	f	f	2017-08-03 11:49:37.255396+00	2017-08-11 09:17:31.774299+00
152	150	77	3	Gracielle	Natuwa akong basahin ang 'consonance' na ginamit (sayang at wala tayong salin ng talinghagang ito sa Filipino). Ipagpatuloy mo pa, kaibigan!	0	0	f	f	2017-08-02 14:07:46.536923+00	2017-08-02 14:07:46.536923+00
153	149	76	3	Kulang	Naniniwala akong Siya nga ang pagmumulan ng tunay na pag-ibig!	0	0	f	f	2017-08-02 14:09:29.799903+00	2017-08-02 14:09:29.799903+00
154	144	74	3	Ang lihim na Palabas	Malinaw ang larawang-diwa na ginamit. Nabigyang-buhay ng paggamit ng simbolismo ng palabas/entablado ang sinusubok iparating. Kudos, kaibigan!	0	0	f	f	2017-08-02 14:12:32.156969+00	2017-08-02 14:12:32.156969+00
155	139	72	3	Babae ng Aking mga Pangarap	Mahigawa. Nag-iwan ng bahid ng hiwaga sa isipan ng mambabasa. Mapapaisip ka na lang, "ito ba talaga ang gusto niyang sabihin... o iba pa?"	0	0	f	f	2017-08-02 14:15:03.536502+00	2017-08-02 14:15:03.536502+00
156	143	73	3	lílok	Ladino ba 'to? Maganda ha? Nakita ko ang tradisyunal na pag-uugnay ng lalim at talinghaga.	0	0	f	f	2017-08-02 14:16:43.411098+00	2017-08-02 14:16:43.411098+00
157	145	75	3	paalala	Siyang tunay!	0	0	f	f	2017-08-02 14:17:08.350765+00	2017-08-02 14:17:08.350765+00
158	\N	78	19	Ewan	Madalas maguluhan, di na alam ang mararamdaman, ano pa bang pinaglalaban, nararamdaman o tagal ng samahan, sana'y maliwanagan. Di ko na alam. Hindi ko na alam. 	0	0	f	t	2017-08-02 14:27:05.612121+00	2017-08-02 22:18:55.4352+00
176	175	89	19	Di Ko Alam	Pinaluha ako ng tula mo, mahal.	0	0	f	f	2017-08-04 08:44:10.6048+00	2017-08-04 08:44:10.6048+00
226	225	121	1	Kung maging tayo	Maligayang pagbati sa iyo Maria. Nawa'y ang iyong mga tinatagong damdamin at likha ay iyong ibahagi sa amin dito sa liham.ph!	0	0	f	f	2017-08-17 09:45:17.962872+00	2017-08-17 09:45:17.962872+00
165	\N	84	19	Sawa na	Nagbago na ako.\n\nOO NAGBAGO NA AKO!\n\nHindi para sayo. \n\nNagbago ako para sa sarili ko. \n\nNakakasawa na. 	2	0	f	t	2017-08-03 13:20:06.334778+00	2017-08-15 23:25:30.049+00
159	\N	79	37	Alam Mo, Ngunit Hindi...	Alam mong ispesyal ang araw na iyon, ngunit walang selebrasyon.\r\nAlam mong dapat nandun ka, ngunit pinili mong hindi pumunta.\r\nAlam mong ako ang nasa tabi mo, ngunit nasa iba ang atensyon mo.\r\nAlam mong ako dapat ang inuuna mo, ngunit ako na lang ang nagpipilit makuntento sa naibibigay mo.\r\n\r\nAlam mong akin dapat ang mga sandaling iyon, ngunit ang natatamo ko lang ay iyong paambon.\r\nAlam mong nalulungkot ako, ngunit tinatanggap mo na lang sa tuwing sinasabi kong ’ayos lang ako’.\r\nAlam mong ganoon dapat ang nais ko, ngunit ako nanaman ang babagay sa gusto mo.\r\nAlam mong ako’y nasasaktan, ngunit sinasabi mong normal lang yan sa nagmamahalan.\r\n\r\nOo, alam kong mahal mo ako, ngunit hindi nga lang buong-buo.\r\nAlam kong hindi dapat ako nanunumbat, ngunit minsan kasi’y nilulunod ako nitong lahat...\r\nAt alam kong mahal kita, ngunit hindi ko na alam kung hanggang kailan ko kaya.\r\nDahil sa tuwing nagbibigay ako sayo, alam kong nauubos na rin ako.	4	0	t	f	2017-08-03 05:10:54.536524+00	2017-08-16 23:47:19.675266+00
169	143	73	34	lílok	Hindi ako pamilyar sa Ladino, patawad. Ito ay pagtatangka sa Castillan na may pagka-Balagtas?	0	0	f	f	2017-08-04 00:52:39.732451+00	2017-08-04 00:52:39.732451+00
166	149	76	20	Kulang	Ang pinakadakilang pag-ibig ay ang pag-ibig ng Diyos...\r\nSiya ang simula at ang huli.	0	0	t	f	2017-08-03 13:32:32.866574+00	2017-08-03 13:39:05.951429+00
160	143	73	34	lílok	Patawad, ngunit ano ang "Ladino"?	0	0	f	t	2017-08-03 10:57:20.985787+00	2017-08-04 00:47:08.734564+00
168	162	81	3	liwayway	Tunay kong nakikita ang larawang-diwa ng iyong mga tula. :)	0	0	f	f	2017-08-03 14:05:42.707907+00	2017-08-03 14:05:42.707907+00
171	167	85	34	Ang oras ay isang ilusyon	(ma)kita kita	0	0	f	f	2017-08-04 01:25:02.29757+00	2017-08-04 01:25:02.29757+00
172	170	86	2	ibulông mo sa ákin	nakakabighani na mga salita na tila ba'y ibinubulong ng isang tunay na makata	0	0	f	f	2017-08-04 01:37:58.14856+00	2017-08-04 01:37:58.14856+00
167	\N	85	2	Ang oras ay isang ilusyon	Ngayon\r\nBukas \r\nat Kahapon\r\n\r\nsila nga ba ay ilusyon?\r\n\r\nSino nga ba sila?\r\n\r\nNawawala...\r\nang kahulugan nila...\r\nsa iyong mga mata\r\n\r\nAnong halaga\r\nna maintindihan\r\nang mga panahon\r\nkung hindi ka kasama?\r\n\r\nNa umikot ang daigdig\r\nat magpalit ng kulay ang langit\r\nmas pipiliin pang\r\nmahimlay sa iyong labi\r\n\r\nAng kahapon\r\nbukas\r\nat ngayon\r\n\r\nPareho lamang sila\r\nnaging pareho sila\r\nnang makita kita	2	1	t	f	2017-08-03 13:49:02.607299+00	2017-08-04 01:25:02.29757+00
178	170	86	26	ibulông mo sa ákin	kakaiba ang estilo ng pagsulat, at namangha ako sa bawat taludtod. ipagpatuloy mo, kaibigan!	0	0	f	f	2017-08-04 10:24:18.864661+00	2017-08-04 10:24:18.864661+00
177	\N	90	29	Pagpapaalam O Pagpapaalam	Minsan lang ako magutom, bakit ngayon pa?\nPumunta ako sa karinderya, nakita kitang may kasamang iba\n\nDi ko alam kung dapat ipaalam\nDi ko alam kung dapat nang magpaalam	1	0	f	f	2017-08-04 09:11:48.375895+00	2017-08-04 12:50:10.173664+00
163	\N	82	26	blanko	naiwang blanko\nang papel\nng manunulat\nna hindi makasulat. \n\nsalamin ng isipan\nang blankong papel\nng manunulat\nna hindi makasulat.\n\n(at ngayon lang napagtanto\nng manunulat \nna kanina pa nagsusulat\nna hindi na blanko\nang kanyang papel.)	4	0	f	f	2017-08-03 11:46:55.022014+00	2017-08-11 09:17:34.13549+00
162	\N	81	26	liwayway	Nakikita ko\nAng kadiliman\nNalulunod sa kaitiman\nSa kawalan\n\nNararamdaman ko\nAng kadiliman\nYumayapos ang kaitiman\nNahahapo ang paghinga\nSa kawalan\n\nBumukas ang mga mata\nKumawala ako\nSa kadiliman\nKumalas sa yapos\nNg kaitiman\nLumaya sa kamay\nNg kawalan\n\nNakikita ko\nAng unang sinag\nNg liwanag \n–nagwakas na\nang gabi. \n	4	1	f	f	2017-08-03 11:05:45.119954+00	2017-08-11 09:17:35.776605+00
161	\N	80	26	daluyong	Kalma. \nHinga. \nWalang alon\nSa karagatan\n\nKalma. \nHinga. \nMalumanay\nAng simoy ng hangin\n\n(sandali.)\n\nKaba. \nHapo. \nLumikha ang karagatan\nNg gulo\n\nKaba.\nHapo.\nGalit na galit \nAng hangin\nHumampas sa bato\nAng mga alon. \n\nNakikita ko ang daluyong\nSa iyong mga mata. \n\nKalma. \nHinga. \n\n\n\n\n	3	0	f	f	2017-08-03 11:04:26.768213+00	2017-08-11 09:17:37.81009+00
189	143	73	3	lílok	@kgabs\r\nAng ladino ay wikang Tagalog na nakasulat sa palabaybayang Kastila. Wala akong tiyak na halimbawang maibibigay sa iyo ngayon subalit tingin ko'y makatutulong ang 'Google.'	0	0	t	f	2017-08-05 16:20:10.939897+00	2017-08-05 16:20:51.004835+00
192	191	101	34	Bilin	nagustuhan ko ang paggamit ng "irony" sa iong liham. tumagos sa akin!	0	0	f	f	2017-08-06 08:24:56.521169+00	2017-08-06 08:24:56.521169+00
182	\N	94	39	Anu ba tayo?	"Anu ba tayo?" Sapat na ang masasayang araw na puno ng ngiti at ligaya ang labi nating dal'wa.\nTanong nila'y di dapat gumulo sa ating nararamdaman.\nMalikhain ang mga pusong tunay na nagiibigan.\nOo, espesyal ka... Espesyal ka sa aking puso at isipan, at alam ko na ganun din ako sayo. Tama ba?\n\nKaibigan? Higit sa magkaibigan?\nMagkasintahan? \nDi na importante kung sino o ano ang papel natin sa buhay ng bawat isa.\nDahil di man tayo araw araw naguusap at nagkikita, alam natin na sabik tayo makita ang ngiti ng bawat isa. \nKung maging tayo, darating ang pagkakataong yun sa tamang panahon. Ngunit di ako umaasa sinta dahil kung ito ay nararapat, ito ay kusa sa ating harap ay ilalatag.\n\nMasaya ako at masaya ka. Sapat na yun para sa pagmamahal kong wagas...\nPero wag kang magdarahop aking sinta. Dahil sa takdang panahon, alam kong maipaparamdam ko sayo ang tunay kong nararamdaman. \nOo, at alam kong kaya ko itong higitan, maging ito man ay iyong kalayaan.\nSandali lang. Sandali na lang mahal... 💑	2	0	f	f	2017-08-04 20:18:20.838936+00	2017-08-08 03:27:06.470777+00
193	175	89	34	Di Ko Alam	nagustuhan ko ang paggamit ng aliteración sa unang dalawang liña ng bawat talata.	0	0	f	f	2017-08-06 08:26:59.234965+00	2017-08-06 08:26:59.234965+00
194	180	92	2	tibôk ng pusò sa dapit-hápon	napakahusay ng pag-gamit ng mga letra. ipagpatuloy mo ang napakahusay na panunula kaibigan!	0	0	f	f	2017-08-07 00:42:21.632731+00	2017-08-07 00:42:21.632731+00
195	187	99	2	MJ	napakahusay. nararamdaman ko ang emosyon na nagmumula sa iyong likha.	0	0	f	f	2017-08-07 00:43:43.374779+00	2017-08-07 00:43:43.374779+00
199	\N	103	26	pagod	namimigat\r\nang mga matang\r\ndapat dati pang\r\nnakapikit. \r\n\r\nnahahapo\r\nang paghingang\r\ndapat dati pang\r\nkalmado. \r\n\r\nnalalapit\r\nang umagang\r\ndapat dati pang\r\nmalayo. \r\n\r\n"pagod na \r\nang katawang\r\ndapat dati pang\r\nnamamahinga.." \r\n\r\ntumutunog\r\nang orasang\r\ndapat dati pang\r\ntahimik. \r\n\r\n"kalahating oras pa." 	7	0	t	f	2017-08-07 14:56:37.302746+00	2017-08-11 09:16:55.082281+00
196	191	101	2	Bilin	mahusay na pagkakagamit ng pagsasalungat na ideya.	0	0	f	f	2017-08-07 00:45:00.429162+00	2017-08-07 00:45:00.429162+00
190	\N	100	29	Sa Pusod ng Gubat	Di ko maramdaman ang hampas ng hangin\nAng mga mata ko sa gumamela lamang nakatingin\nHindi malapitan, hanggang sulyap na lang\nNatatakot matinik sa masukal na damuhan	2	0	f	f	2017-08-06 02:33:37.063237+00	2017-08-09 05:40:49.378193+00
197	184	96	2	Munting Aklatan ni Inay	ako ay nadala mo sa ibang mundo. isang mundo na hindi sa akin, malamang ito ay sayo. naamoy ko ang mga lumang libro. Ang pagkadalisay ng iyong likha ay nakakaantig ng puso.	0	0	t	f	2017-08-07 00:46:14.913836+00	2017-08-07 00:46:29.185199+00
135	\N	68	31	Bakit?	Bakit kaylangan natin mag mahal?\r\n\r\nIsang tanong na di ko kayang sagutin. Hindi ko din alam kung bakit kaylangan masaktang ang taong nagmamahal lamang. Hindi ko alam kung bakit kaylangan natin iyakan ang taong nanakit sa atin. Hindi ko alam kung bakit tayo nasasaktan tuwing naalala o naiisip natin ang taong yun na may kasamang iba. Hindi ko alam.\r\n\r\nMahal, sa tuwing naalala kita, hindi ko alam kung saan ako nag kamali. Dahil ba sa naging distansya natin sa isa't isa o dahil ba sa aking mga naging pagkukulang? Mahal natin ang isa't isa, oo. Pero kulang pa pala yun.\r\n\r\nTatlong linggo mula nang ika'y umalis nabili ko ang tiket papuntang Estados Unidos para tuparin ang aking pangako na ika'y aking susunduin para bumalik sa ating Inang Bayan. Ngunit anong nangyari? Isang linggo ang nakalipas ako'y iyong iniwan. Nasaan na ang mga pangako at pangarap natin mahal? Nasaan na ang ating masaya at magandang kinabukasan na aking atat na atat na hinihintay?\r\n\r\nNaglaho ang lahat dahil ika'y nagbago habang ako, nandito parin. Ako parin ang taong minahal mo noon ngunit ayoko nang umasa pa na ika'y babalik dahil isa lang itong kahibangan. Gusto ko lang malaman mo at nang buong mundo na meron pang taong natitira na tapat at lubusang mag mahal sa taong akala niya'y karapat dapat ngunit hindi.\r\n\r\nHindi ako nagsisisi sa ating nakaraan mahal dahil isa lamang ito sa mga aral at alaala na aking babaunin hangang sa aking pag tanda.\r\n\r\nPaalam mahal.\r\n\r\nNagmamahal ng lubos,\r\nGuerrero	5	2	t	f	2017-07-31 07:18:51.885317+00	2017-08-09 00:31:53.766304+00
200	\N	104	34	bahà	sa ióng pagdating ang kasáma ay bahà\n  na bugsò ng bagió ng damdámin\numása ang pusò pagkatápos ng unós\n  na tibók nauà'y humupà\nngúnit sa ióng paglísan tilà \n  sumpà ay iníuan\npagka't ang damdámin na sánai natîrá\ntinangái ng lagunôs na pagsintá	5	0	f	f	2017-08-08 12:54:11.447934+00	2017-08-15 05:49:35.705304+00
191	\N	101	29	Bilin	Wag mong iwanan, baka mawala\nWag mong iwanan, baka mawala\nPaulit-ulit mong paalala\nSinasabi sa akin nung mga oras na may tayo pa\n\nOo aminado ako na burara ako.\nYan siguro ang dahilan kung bakit ka nawala sa buhay ko\nPero di ko maintindihan kung bakit ganito\nApat na taon na ang nakalipas ng iwan mo ko\nHindi pa din nawawala 'tong nararamdaman ko para sayo\n\nWag mong iwanan, baka mawala\nIniwan mo ko pero di pa din nawawala\n\nDi pa din nawawala tong nararamdaman ko\nMatagal na nang iwanan mo ako, pero hanggang ngayon nandito pa din ako\n	2	2	f	f	2017-08-06 02:52:22.577701+00	2017-08-09 05:40:48.697945+00
201	\N	105	29	Kamay ng Halimaw	Lumapat ang kamay\nNapaso akong muli\nAkala ko tapos na\nBabalik pala sa dati\n\nTakot na takot ako\nNang lumapat ang kamay mo\n\nBigla kong naramdamang ang kamay ng halimaw	3	1	f	f	2017-08-09 01:07:17.490034+00	2017-08-13 13:03:38.328882+00
221	\N	118	29	Sa Ikatlong Linggo ng Agosto	...\n\nParang tatakas yung puso ko sa dibdib ko\nNakita ka na naman\nNagpupumiglas na naman\n\nDi mawari kung pag-ibig o pagkalango\nDahil ba naparami ang nainom na kape\nO dahil nakita kang saki'y wala nang pake\n\nSa totoo lang kinakabahan ako\nDi ko alam kung matatapos ba\nDi ko alam kung aabot pa\n\nDi rin mapakali yung kalamnan ko\nDi ko alam kung tama pa\nO baka dapat bang tama na	2	0	f	f	2017-08-16 12:07:33.544645+00	2017-08-21 04:45:24.758753+00
281	\N	147	42	Ikaw pa rin	Tatlong taon na ang nakalipas\nStorya natin ay nagwakas\nSa bawat paglubog ng araw\nPalaisipan pa rin ang iyong pagbitaw\n\nTila ako'y nalunod sa salitang "bakit"\nBakit hindi ka na kumapit?\nBakit nagawa akong ipagpalit?\nBakit nandoon ka pa rin sa aking pagpikit?\n\nSana'y pagbilang ko hanggang tatlo\nPighati't kirot ay maglaho\nIsa, dalawa, tatlo\nIkaw pa rin ang nais ko\n\n	3	1	f	f	2017-09-20 22:16:14.96762+00	2018-01-01 15:10:55.56557+00
311	\N	164	48	Bakit	Bakit ka narito?\nBakit ka ba nandito?\n\nAkala sa isip lamang\nNgunit nandito ka.\n\nOo, ako umasa.\nPero hindi sa ganitong paraan.\n\nYun lamang ba?\nAng dahilan ng iyong pagpunta.\n\nO meron ka pang nais?\nPero hindi iyon ang nangyari.\n\nPero bakit?\nAno iyong dahilan?\n\nSa pagpunta at muling paglisan.	0	2	f	f	2018-02-06 08:59:01.181682+00	2018-02-07 14:32:24.730496+00
203	202	106	2	para sa kauna-unahang babaeng inibig ko	Naramdaman ko ang istorya ninyo. Ang umibig ay isang munting bagay na maganda, kahit masaktan ito ay mananatiling maganda.	0	0	f	f	2017-08-09 22:20:19.573131+00	2017-08-09 22:20:19.573131+00
206	201	105	34	Kamay ng Halimaw	Hahahaha!	0	0	f	f	2017-08-11 01:09:04.168023+00	2017-08-11 01:09:04.168023+00
208	\N	110	19	Mata	Isang tingin sa mga mata mo at nalunod ako...\n\nTama na, mali ito.\n\n	3	0	f	f	2017-08-13 09:21:13.108197+00	2017-08-13 23:40:00.515589+00
248	\N	130	3	Madilim ang Langit	Madilim ang langit.\r\nHindi dahil malapit na ang gabi,\r\nO nagbabadya ang ulan.\r\n\r\nMadilim ang langit\r\nDahil sa mga matang pumikit\r\nNang dumaan ang katotohanan.\r\n\r\nMadilim ang langit\r\nDahil ang piring ng hustisya ay sinuot\r\nHindi upang maging patas\r\nkundi magbulag-bulagan.\r\n\r\nMadilim ang langit\r\nDahil sa mga paniniwalang nabayaran\r\nO pagmamataas na hindi maiatras.\r\n\r\nMarami ang nakakakita ng totoo,\r\nSubalit ayaw maniwala.\r\nMaraming naniniwala,\r\nSa mga bagay na hindi totoo.\r\n\r\nSubalit...\r\nSa madilim na langit\r\nMas maaaninag\r\nAt mailalapit\r\nAng tunay na liwanag.\r\n	3	4	t	f	2017-08-21 12:06:43.837889+00	2017-08-23 22:44:08.485766+00
204	\N	107	2	Likha	Putik\nAko ay putik!\nako ay madumi\nnapakarumi at mabaho\nngunit mula sa putik nagmula ang tao...\n\nBakal\nAko ay bakal!\nako ay matigas\nmatigas at di nagpapatalo\nbumibigay sa apoy at pagpalo...\n\nKahoy\nAko ay kahoy!\nako ay ina-agos\nmadaling mabulok\nngunit nababago sa paglilok...\n\nAko ay\nputik, na pwedeng ihulma...\nbakal, na pwedeng puk-pukin...\nkahoy, na pwedeng lilukin...\n\nng mga kamay \nna kilala ang pagibig	2	0	f	f	2017-08-09 22:30:02.571655+00	2017-08-21 12:15:09.436978+00
207	\N	109	19	Kaibigan	\nSa tuwing kasama kita, walang papel ang hindi nabibigyan ng buhay\nWalang larawan ang nananatiling walang kulay...\n\n\nKaya mong dugtungan ang mga pinagtagpi tagping letra na aking sinasambit\nKaya mong bigyang kulay ang mga monokromatikong larawan na aking ginuguhit\nKaya mong basahin ang aking mga mata katulad ng isang libro\nKaya mong pawiin sa isang iglap lahat ng kalungkutang nadarama ko\nKaya mo akong bigyan ng enerhiya sa pamamagitan ng iyong mga ngiti\nKaya mo kong pangitiin sa pamamagitan ng mga simple mong pagbati\nMarami pa ngunit hindi ko maisa-isa\nBasta tandaan mo mahal kita	0	0	f	t	2017-08-13 00:35:28.400005+00	2017-08-13 09:21:50.269133+00
222	\N	119	29	Para Sa Kumitil ng Buhay Ko	\nNakakapagod na\nWala na akong pahinga\nNakakasakal ka na\nDi na ko makahinga\n\nKakayanin ko ang walang pahinga\nNgunit di ko alam kung kaya ko ang walang paghinga\nAko'y nanghihina na\nAko'y nasasakal na\nAko'y nagsasawa na\n\nAng pananatili sa pagmamahalan na walang pagmamahal ay tila masahol pa sa'yo... mahal kong bumitaw na\n\nTila ba ika'y bumitaw na pero pinaniniwala mo akong ika'y nakakapit pa\nTila ba lipon ng matatamis na salitang ipinakain mo ngunit lahat nama'y panis na\n\nMula nang kumapit ako\nBumitaw ka na sa'king kamay\nMula nang maging buhay kita\nNawalan na ako ng buhay\n\n	2	1	f	f	2017-08-16 12:08:43.515408+00	2017-08-17 09:51:50.26954+00
205	\N	108	29	Di Makatulog	\nDi ako makatulog kapag walang kape\nKailangan bago ako matulog iinom muna ako ng kape\nBago kasi ako makatulog, kinakailangan ko munang magising\nPara kayanin kong makatulog kahit wala ka na sa'king piling\nKailangan kong magising na wala ka na sa'king tabi	4	0	f	f	2017-08-10 11:20:40.603854+00	2017-08-13 13:06:39.679271+00
284	\N	150	34	mga pagsukó 	narito't itataás ko na\nang puting bandilà\nngunit kung para sa ano\nay hindi ko pa alam\nmaaaring pagsukò\nsa alai mong pag-suio\nmaaaring pagsukò dahil\nsa sarado mong pusò\nmaaaring natápos na\nang oalang hanggan\no di kaia'y maghintáy\nay 'di na kailángan	4	0	f	f	2017-09-27 15:32:48.927564+00	2017-10-18 09:43:08.018249+00
210	\N	112	4	Tula 4 - Ang Tasa	Sa aking mga tasa ako'y nagtitimpla ng masarap na kape,\nKapeng magbabangon sa akin sa bagong umaga.\nAng kapeng bubuo sa ating pinapangarap na tanawin,\nIyon ay ang maka-usap kang muli.\n\nSubalit ang tasa, minsan puno, minsan walang laman,\nSa iyong malambot na mga kamay, ito ay iyong pupunuin\nNa may kaunting tamis - at linamnam,\nSapagkat sa iyong timpla ako ay muling nagising.\n\nKung kaya't ang tasa kong ito ay huhugasan paunti-unti,\nSa malinis na tubig sa gripo at sabong lumilinis,\nUpang matanggal ng iyong alaalang naiwan\nPagkatapos nating tapusin itong pagdiriwang.	3	0	f	f	2017-08-13 13:03:26.294534+00	2017-08-13 13:11:59.964313+00
220	\N	117	26	pahinga	napapikit na \nang mga matang\ndati pang gustong\npumikit.\n\nnapakalma na\nang paghingang\ndating hinahangad\nang pagkalma. \n\nnalalayo pa\nang umagang\nna dati pang\nninanais na \nlumayo\n\n"namahinga na\nang katawang\nnaghahangad\nng pahinga." \n\ntahimik na\nang orasang\ndati pang \nhinahanap ang \nkatahimikan.\n\n"tapos na. \nmakakapagpahinga na." 	6	0	f	f	2017-08-15 14:49:11.980469+00	2017-08-21 03:59:32.996981+00
233	\N	125	2	Ang pagasa	Bayani\n\nAng salitang naghahatid ng pagasa\n\nAng salitang magtataboy sa kadiliman\n\nAng hinahanap\n\nPinaguusapan...\n\nKelan ka ba darating?\n\nAng bayani ay\n\nIkaw	2	0	f	f	2017-08-20 22:56:51.731872+00	2017-08-21 08:57:45.613489+00
312	296	160	47	Para sayo ang pagsuko (Ang Unang Bahagi)	Maraming salamat po #onezeronine.\n:-)\nSa Diyos ang lahat ng kapurihan!\nPagpalain ka nawa lagi ng Panginoon.	0	0	f	f	2018-02-06 15:26:26.643103+00	2018-02-06 15:26:26.643103+00
243	\N	129	34	ang sedementación ng puso (bawal hawakan)	gusto kong malaman mo na:\r\nhindi nagsimula bilang bato ang aking puso\r\ntibok nito ay gaia ng pitik ng apoi sa kalaliman ng gabi\r\nang dugông dumadaloi dito ay gaia ng ilog makatapos ang bagio\r\n\r\nhinintai kita mula pa nuong unang ito'y tumibok\r\nsa paghihintay ay nangagsipaghulog ang alikabok sa dibdib\r\ngaia ng pagkukumpol ng alikabok\r\nsa mga aklat na nakatiwangwang sa silid\r\n\r\nlumipas ang panahon at isa pa\r\nwala itong kalaban-labang nilamon ng gabok\r\nhanggang wari mo sa museo ito'y iskulptura na:\r\n"ang sedimentación ng puso (bawal hawakan)"\r\n\r\npag iong nakita sana ikao ay lumuha ng bahà dahil sa saia\r\nnang gabok ay anurin ng wagas na pagsinta\r\n	5	4	t	f	2017-08-21 05:28:40.411159+00	2017-08-22 20:36:59.988951+00
209	\N	111	19	Binhi	Simulan natin sa umpisa. Simulan nating sa kung paano tayo nagkakilala. Nang unang magtama ang ating mga mata, nang unang nakaramdam ako ng kakaiba, para sayo. \n\nNagsimula sa mga simpleng ngiti mo, sa mga simpleng pagbati mo. Doon, katulad ng binhi, unang natanim ang nararamdaman ko, para sayo. Mas lalo tayong nagkalapit, mas lalo ka kasing bumait. Tila ba binhing nadiligan, unti unting umusbong ang nararamdaman, para sayo. Lumipas ang mga araw, ang mga linggo, ang mga buwan, lalo pang lumalim ang nararamdaman sapagkat akin itong inalagaan. Katulad ng binhing ang ugat ay lumalaki na, nagkaroon na ng pundasyon, nagkaroon ng kakapitan, ang aking nararamdaman. \n\nAraw araw walang mintis, lagi mo akong kinakausap, kinakamusta. Pinaparamdam mong ako ay mahalaga. Para bang punong inaaruga. Lalong lumago ang nadarama, lalong lumalim. Nagbunga na ngang talaga. Nagbunga ng kasiyahan, ng kalungkutan, ng kilig. Ay ewan ba! Sinubukan kong pigilan, ngunit huli na...	7	4	f	f	2017-08-13 11:47:06.281985+00	2018-01-19 07:43:28.5174+00
211	202	106	1	para sa kauna-unahang babaeng inibig ko	> Salamat na ipinakita mo ang tunay na ikaw.\n\nMaraming salamat sa pagbahagi ng iyong naramdaman sa iyong unang pag-ibig, mabuhay ka hamaya!	0	0	f	f	2017-08-13 13:05:50.844862+00	2017-08-13 13:05:50.844862+00
285	\N	151	20	Pagsisisi	Pagwaksi sa mali, baliin ang dating gawi\r\nPara sa huli'y makita Kang nakangiti\r\n\r\n\r\nSa munti kong paraan na ito,\r\nAng buhay ko'y unti-unting nagbago...\r\nPagbabago na kahit kailanma'y hindi ko matatamo\r\nKundi dahil sa Iyong pag-ibig na hindi marunong mahapo	2	3	t	f	2017-10-15 14:33:49.109833+00	2018-01-01 14:43:21.284843+00
212	209	111	1	Binhi	> Tila ba binhing nadiligan, unti unting umusbong ang nararamdaman, para sayo.\n\nMalupit ka kaibigan! Maganda itong naisulat mong liham.	0	0	f	f	2017-08-13 13:08:39.09374+00	2017-08-13 13:08:39.09374+00
214	209	111	26	Binhi	napakaganda ng iyong liham! naramdaman ko ang bawat emosyon na lumalabas sa bawat salita.	0	0	f	f	2017-08-13 13:19:42.428191+00	2017-08-13 13:19:42.428191+00
213	209	111	19	Binhi	@onezeronine salamat kaibigan. Sadyang may pinanghuhugutan lamang. Napakasakit na katotohanan..	0	0	f	t	2017-08-13 13:13:14.916891+00	2017-08-13 15:30:39.089655+00
218	\N	116	2	Ang katotohanan	Ito ay nagpapalaya\nbumabasag sa mga tanikala\nna kumakapit sa ating mga paa\nhabang sinusubukan nating makalipad\n\nNagbibigay tapang\nNagbibigay lakas\nNagbibigay saya\n\nNagpapalaya\nat nagbibigay pahinga\nsa mga pagod na pusong\nnais lamang magmahal	3	0	f	f	2017-08-15 02:39:31.519726+00	2017-08-21 12:12:02.365373+00
215	\N	113	19	Taglagas 	hindi ko inakalang lalalim ng ganito ang nararamdaman.  hindi ko tuloy napaghandaan ang iyong paglisan. bigla na lang isang araw, nagising ako sa panibagong ikaw. tulad ng puno sa taglagas, sumabay ka sa agos ng pagbabago ng panahon. unti unting lumayo ang loob natin sa isa't isa. unti unting naglaho ang lambing sayong mga mata. ang mayabong na puno ng nararamdaman ko, unti unting nalagas. natutunan kong makalimot. natutunan kong bumitaw, katulad ng mga dahon sa mga sanga ng puno tuwing taglagas. \nand damdamin ko ay para bang naging puno sa taglamig. ang binhing itinanim, umusbong, at yumabong, ngayon ay tuyong sanga na lamang. akala ko yun na ang huli. pero tulad ng araw sa tagsibol, bigla ka na namang nagparamdam. biglang nandyan na naman ang lambing mo. biglang nandyan na naman ang mga ngiti mo. at katulad nga ng puno sa tagsibol, muling yumabong ang nararamdaman kong nilimot ko na. \nalam kong di magtatagal ay muli kang lilisan, katulad ng dati. bigla ka na namang magbabago at di maglalaon ay iiwan na naman ako. tulad ng mga dahon sa taglagas. 	2	0	f	f	2017-08-13 15:22:53.587931+00	2017-08-14 11:42:31.018741+00
219	209	111	2	Binhi	Mahusay na pagkakasulat kaibigan. Ito ay nagbigay ng pagpaaalala sa unang beses na ako ay namulat sa tawag ng pagibig.	0	0	f	f	2017-08-15 02:40:49.706349+00	2017-08-15 02:40:49.706349+00
228	\N	123	19	naguguluhan	At sa bawat yakap mula sayo, \n\npinapanalanging sana.. \n\nsana matauhan na ako.. \n\nKasi maling mali ito..	2	0	f	f	2017-08-20 01:29:36.560155+00	2017-08-25 15:59:03.830997+00
44	\N	31	7	Bilang	Isa - isang beses lang tayo mabubuhay sa mundo kaya't ating hanapin ang nagiisang tao para sa atin\r\n\r\n\r\nDalawa - mahal kita. Ang dalawang salitang hinahangad mong marinig.\r\n\r\n\r\nTatlo - tatlong uri ng pag-ibig na makikilala mo. Ang una, ang mali at ang huli.\r\n\r\n\r\nApat - bilang ng panahon na mayroon tayo. Tulad ng bilang ng mga yugto sa ating buhay. Pagkabata, pagbibinata/pagdadalaga, pagkatanda at pagkamatay.\r\n\r\n\r\nLima - limang pandamdam. Ngunit bakit may mga taong manhid? Bakit may mga taong hindi ginagamit nang husto ang mga ito?\r\n\r\n\r\nTayo'y binigyan ng iba't ibang biyaya ng Diyos, ito'y ating gamitin upang magbigay ng pagmamahal sa mga tao. Huwag natin itong sayangin.	2	0	t	f	2017-07-20 04:57:08.287747+00	2017-08-16 15:28:26.388303+00
223	222	119	2	Para Sa Kumitil ng Buhay Ko	hindi ko maisip ang paghihirap na iyong dinaranas. Nawa'y makahanap ka ng tunay na pagibig.	0	0	f	f	2017-08-16 23:43:39.299261+00	2017-08-16 23:43:39.299261+00
144	\N	74	33	Ang lihim na Palabas	Mga alaala ng iyong pag-ibig, \r\nkay sarap panoorin.\r\nSa entablado ng nakalipas, \r\nmuli kang gumanap bilang sa akin.\r\n\r\nKahit ako lang ang tagapanood,\r\nTanyag ka pa rin sa puso kong malungkot.\r\nSa gabi tayo ay umaawit,\r\nAyoko ng magwakas itong panaginip.\r\n\r\nAko ay isang taga hanga mo.\r\nUmiibig na mula noong mga bata pa tayo.\r\nSubalit sa mga sumunod na palabas,\r\nIba’t iba na ang gumanap bilang sayo.\r\n\r\nNaiwan akong magisa sa entablado.\r\nNaghihintay pa rin para sayo.\r\nNaghahangad ng susunod na kabanata.\r\nSa pagmamahalang tayong dalawa ang nagsimula.\r\n	5	1	t	f	2017-07-31 19:39:33.726692+00	2017-08-16 23:50:20.348186+00
230	229	124	19	kay fidel	gustong-gusto kong mapanuod ang pelikulang ito!	0	0	f	f	2017-08-20 09:22:57.185871+00	2017-08-20 09:22:57.185871+00
231	225	121	2	Kung maging tayo	simple ngunit malaman :)	0	0	f	f	2017-08-20 11:05:33.395114+00	2017-08-20 11:05:33.395114+00
216	\N	114	19	Pagkakamali	Hindi maitatama ng pagkakamali ang isa pang pagkakamali...\r\n\r\nAlam nating pareho na mali...\r\n\r\nPero bakit ...\r\n\r\nBakit ang katotohanang ito ay ating isinantabi...\r\n\r\nBakit tayo'y nakiagos na lamang sa sandali...\r\n\r\nBakit hinayaang malunod sa mga titig ng isa't isa...\r\n\r\nBakit ang lahat ay isinawalang bahala...\r\n\r\nMali...\r\n\r\nMaling mali talaga...\r\n\r\n	3	0	t	f	2017-08-14 06:28:42.510134+00	2017-08-21 12:12:54.83969+00
244	236	127	3	Ang Masama, Maganda at Mabuti	@anginiwannglubhaan\n@chocnut\n\nMaraming salamat! Ipaalam natin ang Mabuting Balita!	0	0	f	f	2017-08-21 07:24:38.807379+00	2017-08-21 07:24:38.807379+00
240	237	128	2	ang pag-ápao	Tunay nga na ikaw ay isang makata kaibigan	0	0	f	f	2017-08-21 04:42:44.140788+00	2017-08-21 04:42:44.140788+00
246	243	129	3	ang sedementación ng puso (bawal hawakan)	Malinaw na pagpili ng salita at sadyang makata. Ako'y tagahanga. Mahusay, kaibigan.	0	0	t	f	2017-08-21 10:17:21.166509+00	2017-08-21 10:17:43.551984+00
238	234	126	2	para kay mama	Tila ba'y sumasabay sa lungkot ng kalangitan	0	0	f	f	2017-08-21 04:40:28.096518+00	2017-08-21 04:40:28.096518+00
239	236	127	2	Ang Masama, Maganda at Mabuti	Mahusay!	0	0	f	f	2017-08-21 04:42:15.508932+00	2017-08-21 04:42:15.508932+00
236	\N	127	3	Ang Masama, Maganda at Mabuti	Sa simula...\r\nIsang Dakila ang lumikha\r\nBinuo ang sansinukuban gamit ang salita.\r\nBawat bigkas ay buhay.\r\nBawat kataga ay pag-ibig.\r\nAng lahat ay nakatalaga upang maging salamin ng Kanyang kaluwalhatian.\r\n\r\nSubalit...\r\nAng Kanyang nilikha ay nagkasala\r\nLaban sa kanyang kabanalan.\r\nLaban sa kanyang kabutihan.\r\nMula sa isa, nagmula ang sumpa.\r\nSumpang walang makakawala.\r\nAt ito,\r\nAng masamang balita.\r\n\r\nSa gitna...\r\nLahat ay hahanapin ang sarili.\r\nLahat ay tatalikod.\r\nWalang magiging mabuti.\r\nWalang nais maglingkod.\r\nWala.\r\n\r\nWalang makakasunod.\r\nLahat ng Kanyang batas ay di natupad.\r\nWalang maglilingkod.\r\nLahat ay sarili ang tanging hangad.\r\nLahat.\r\n\r\nNaisip mo na ba,\r\nKung bakit may kulang sa iyo?\r\nSa puso ay hungkag\r\nNa tila walang makabuo?\r\n\r\nIto ay dahil ang ating KASALANAN\r\nay pinipigilan tayo.\r\nLAHAT AY NAGKASALA.\r\nLAHAT AY NASA MASAMANG BALITA.\r\nWalang naghanap sa Kanyang kabutihan.\r\nLahat ng ating gawa ay parang basahan\r\nNa inaalay sa Maylalang ng lahat.\r\n\r\nSubalit...\r\nSa gitna ng pagkamakasarili,\r\nPinili ng Pag-ibig na ipakita\r\nKung ano ang Pag-ibig.\r\n\r\nAt ito,\r\nAng magandang balita.\r\n\r\nMinahal ng Hari ang sa Kanya'y nag-alsa.\r\nTinanggap ng Ama ang anak na nagpabaya.\r\nHinahap ng Pastol ang Kanyang tupang nawala.\r\nBinuksan ng Pinto ang bagong pag-asa.\r\n\r\nMula sa Isang tao pumasok ang kasalanan\r\nDahil sa Isang tao darating ang kalayaan.\r\n\r\nHanda ka na ba?\r\nIto ang mabuting balita.\r\nSa kabila ng ating kasalanan.\r\nPinili ng Anak na sundin ang Ama.\r\nSinalo ang parusa upang hustisya ay matugunan.\r\nIpinako sa Krus ang kordero upang ikaw at ako ay maging buo.\r\nMaging kompleto.\r\nAt ito ay isang Regalo.\r\nNa hindi mababayaran.\r\nHindi mapapalitan.\r\nSubalit maaaring tanggapin.\r\n\r\nManiniwala ka ba?\r\nNa ikaw ngayon ay nasa masamang sitwasyon?\r\nNa ang magliligtas sa iyo ay hindi tradisyon?\r\nNa nang sinabing "tapos na?"\r\nIkaw ang iniisip Niya?\r\n\r\nSa wakas...\r\nHihintayin ang pagbabalik.\r\nUpang tawagin ang lahat,\r\nHindi para tanggapin\r\nKundi para husgahan.\r\nKung ang kamay ng Maykapal ay papatong sa'yong ulo, makasisiguro ka ba?\r\nNa ang iyong walang hanggan...\r\nAy nasa piling Niya?\r\n\r\nPanalangin ko'y iyong matagpuan,\r\nAng mga sagot sa iyong katanungan.\r\n	4	3	t	f	2017-08-21 03:44:14.416414+00	2017-08-21 08:58:26.989426+00
247	243	129	34	ang sedementación ng puso (bawal hawakan)	@AngMangingibig salamat!	0	0	f	f	2017-08-21 10:44:52.158327+00	2017-08-21 10:44:52.158327+00
241	236	127	20	Ang Masama, Maganda at Mabuti	Para sa pag-ibig na hindi napaparam!\n\nNawa'y ang iyong likha ay mabasa ng madla, kaibigan. Ako ay isang tagahanga ng iyong mga akda ✍	0	0	f	f	2017-08-21 04:46:44.66514+00	2017-08-21 04:46:44.66514+00
249	181	93	3	Pero	Kung mali na ang pagmamahal, baka hindi na ito pag-ibig.	0	0	f	f	2017-08-21 12:17:27.11839+00	2017-08-21 12:17:27.11839+00
242	224	120	20	Di ko alam	Dhdbd	0	0	f	t	2017-08-21 04:48:35.399527+00	2017-08-21 04:48:47.533542+00
217	\N	115	1	Sa mga litratong iyong iniwan	Sa aking pagpikit, ang iyong mata ang aking nasisilip,\r\nSa kaunting liwanag, ang iyong ngiti ang namumulaklak,\r\nAt sa iyong kislap, ako ay iyong nabighani.\r\n\r\nAking binibini, bakit ang iyong kamay ay kasing layo ng mga isla?\r\nSa pagitan nito ay ang mga dagat,\r\nNa hindi ko kayang languyin dahil sa mapanganib na alon\r\nNgunit ganyon pa man ay hindi ko ito iiwasan.\r\n\r\nSapagkat sa mga iyong litratong iniwan sa akin,\r\nAko ay hindi makatulog, lalanguyin ko ang mga dagat kahit alam kong\r\nMasasaktan ako sa aking paglalakbay,\r\nPero ang makita kong mapawi ang aking lumbay\r\nSa pagtingin sa iyong muling nakaka-akit na ngiti,\r\nAng sakit, dalumhati at pagod ay maglalaho\r\nDahil ang iyong malambot na bisig ang sasalubong sa aking pagdating.	3	0	t	f	2017-08-14 11:42:21.619299+00	2017-08-21 04:52:35.809221+00
245	234	126	1	para kay mama	ahhhh ang sakit :'(	0	0	f	f	2017-08-21 08:58:19.79634+00	2017-08-21 08:58:19.79634+00
252	248	130	2	Madilim ang Langit	Napakahusay nito. Isang tunay na obra :)	0	0	f	f	2017-08-21 23:11:59.692276+00	2017-08-21 23:11:59.692276+00
258	\N	132	42	Ako'y Sundalo at Ama	mabibigat na yabag ang aking dala\nsa tuwing ako'y hahakbang \npatungo sa giyera\n\nngunit lalong bumigat \npati ang puso ay lubos na nahabag\nnang aking marinig ang mga katagang, \n\n"umuwi ka, itay."	3	2	f	f	2017-08-22 20:33:11.312431+00	2017-08-25 19:39:14.681345+00
253	243	129	2	ang sedementación ng puso (bawal hawakan)	Isang tunay na makata @kgabs :) Nawa'y wag kang tumigil sa pagsusulat	0	0	f	f	2017-08-21 23:13:38.160615+00	2017-08-21 23:13:38.160615+00
198	\N	102	2	Maglatag	Ako'y maglalatag na...\nupang matulog at magpahinga\n\nilang gabi na na ako'y naglalatag\nupang pawiin ang pagod na ibinigay ng mundo\nako'y naglalatag upang pawiin...\npawiin ang pagod ko.\n\nngunit ano na't hindi napapawi\nang uhaw at pait at ang galit\nng nakaraan na sumubok sa akin\nhindi makalimutang bangungot\n\nwalang magawa kung hindi bumangon\nsa kinahihigaan-at umahon\nsa langis, grasa at dumi \nng kahapon...\n\nnasaan ang pahinga at kapayapaan?\nang pagtanggap sa tadhana\nat kalimutan...\nkalimutan ang nakaraang lumisan\n\nako ay maglalatag para sa iba...\nnang sila ay makapag-pahinga\nang maglatag ng buhay, ng pagibig\nay hindi naaangkop para sa sarili\n\nsa aking paglatag na hindi para sa sarili...\nang pagod ay napawi na.	2	0	f	f	2017-08-07 00:59:19.811485+00	2017-08-21 12:16:12.747802+00
251	237	128	26	ang pag-ápao	nakamamangha ang iyong kakaibang estilo ng pagsulat :)	0	0	f	f	2017-08-21 13:22:49.046008+00	2017-08-21 13:22:49.046008+00
250	248	130	26	Madilim ang Langit	nakamamangha ang iyong mga tula, kaibigan. nakamumulat ng isipan ang iying mga sinusulat. ipagpatuloy mo, kaibigan!	0	0	f	f	2017-08-21 13:21:53.996928+00	2017-08-21 13:21:53.996928+00
237	\N	128	34	ang pag-ápao	ang aking pag-irog \r\nay gáia ng ilog\r\nang ióng pusò\r\nay gáia ng díke\r\n\r\nnangagsipaglúnod\r\nang manga bundôk\r\nsa umaápao na \r\npag-suiò	4	2	t	f	2017-08-21 03:54:38.367808+00	2017-08-22 00:35:07.753759+00
254	\N	131	40	Salamat	Salamat sa pagsubok \nNa ako'y mahalin\nSa bawat oras na inilaan\npara sa akin,\nsa mga nasabi mong\nnagpabago ng mga araw ko,\nSumaya ako.\n\nKaya salamat.\nDi man ako ang iyong ninais\nPara sa akin iyon ay\nnatumbasan mo rin.\n\nWalang pagsisi,\nWalang paninisi,\nMinahal kita\nKaya, Salamat.	2	0	f	f	2017-08-22 02:50:29.867358+00	2017-08-23 22:45:35.296326+00
255	234	126	34	para kay mama	mabigat!	0	0	f	f	2017-08-22 04:24:36.618522+00	2017-08-22 04:24:36.618522+00
256	248	130	3	Madilim ang Langit	Maraming salamat sa inyong puna. Subalit alam ko lang din na marami pang maaaring gawin upang umunlad. Kayo rin naman ay tunay na nakamamangha.	0	0	f	f	2017-08-22 06:58:11.46119+00	2017-08-22 06:58:11.46119+00
257	248	130	29	Madilim ang Langit	Napakaganda...	0	0	f	f	2017-08-22 10:22:56.406518+00	2017-08-22 10:22:56.406518+00
259	243	129	42	ang sedementación ng puso (bawal hawakan)	sana nga'y madala ito sa kanya ng hangin.	0	0	f	f	2017-08-22 20:36:59.988951+00	2017-08-22 20:36:59.988951+00
260	258	132	2	Ako'y Sundalo at Ama	"Mabibigat na yabag ang aking dala, sa tuwing ako'y hahakbang sa giyera"\n\nMahusay na pagpili ng mga salita. Magpatuloy ka sa pagsusulat kaibigan :)	0	0	f	f	2017-08-23 22:45:29.256879+00	2017-08-23 22:45:29.256879+00
283	\N	149	2	Ang isang estudyante na nagaaral ng kompyuter (IT)	Ang isang estudyante ng mga kursong tungkol sa kompyuter na walang kompyuter... \nay parang isang mandaragat na walang bangka...	1	0	f	f	2017-09-26 03:03:23.737098+00	2017-10-18 09:12:50.455712+00
262	261	133	1	Pag-ibig	> Sa pag-ibig kung saan maraming nasasaktan, umaasa't nahihirapan\n\nIsa sa mga masaklap at magandang katotohan sa buhay. Masarap umibig pero maari kang masaktan.	0	0	f	f	2017-08-24 09:56:50.526975+00	2017-08-24 09:56:50.526975+00
279	274	141	1	Desisyon	> At ang isip na nagsasabi na tama na, nagmumuhka ka ng tanga.\n\nMasakit kumapit sa tanong na hindi mo kayang sagutin.	0	0	f	f	2017-09-02 08:03:48.957108+00	2017-09-02 08:03:48.957108+00
261	\N	133	43	Pag-ibig	\nPag-ibig pag-ibig pagpumasok sa puso nino man hahamakin ang lahat masunod ka lamang, Ngunit ano nga ba ang Pag-Ibig? Ito bang isang Bagay na hindi mo makita ngunit iyong nararamdaman o ito bay isang bugso ng damdaming sumusukat sayong pagnanais sa mga bagay na nakikita lamang. Ano nga ba ang basehan ng isang umiibig?\n\nPag-ibig Pagibig bakit kay hirap mong arukin, kay hirap mo rin unawain. Oh Pag-ibig ika'y sadyang kay hirap mabatid kung hanggang saan ang dulo, ang dulo kung saan walang hangganan. Ika'y sadyang makapangyarihan na kayang hamakin ang lahat makamit ka lang. Oh Pag-ibig ano bang meron sayo kung saan ikay nagbubukod tanggi?\n\nSadya ngang ika'y bukod sa tangi sa lahat, sa lahat ng biyayang kaloob sa lahat. sana'y aking mawari ang ibig ipakahulugan, sa pag-ibig kung saan maraming nasasaktan, umaasa't nahihirapan. Ang aking tugon ay hanggang dito na lamang sa kadahilanang ang aking puso'y lubos ng nahihirapan.	2	1	f	f	2017-08-24 06:53:00.941929+00	2017-08-24 10:34:57.413025+00
265	\N	136	29	Apektado Pa Rin	Napakatagal na magmula nang lisanin ang kaisipan\nNa ika'y aking gusto at tanging ikaw lamang\nNgunit kahit pala lisanin ang kaisipan\nNakaukit na ang pag-ibig at hapding nararamdaman\n\nAkala ko'y wala na, pero bakit meron pa?\nAkala ko'y malaya na, pero bakit ako'y mas nasakal pa?\nAkala ko'y nakalimot na, pero bakit bawat detalye'y tandang tanda ko pa\nAkala ko'y tanggap ko na, pero bakit lumuha nang malamang may mahal ka nang iba?\n	2	0	f	f	2017-08-25 16:00:36.678528+00	2017-09-02 08:02:51.598721+00
264	\N	135	29	Apektado	Napakatagal na magmula nang lisanin ang kaisipan\nNa ika'y aking gusto at tanging ikaw lamang\nNgunit kahit pala lisanin ang kaisipan\nNakaukit na ang pag-ibig at hapding nararamdaman\n\nAkala ko'y wala na, pero bakit meron pa?\nAkala ko'y malaya na, pero bakit ako'y mas nasakal pa?\nAkala ko'y nakalimot na, pero bakit bawat detalye'y tandang tanda ko pa\nAkala ko'y tanggap ko na, pero bakit lumuha nang malamang may mahal ka nang iba?	0	0	f	t	2017-08-25 15:57:29.786253+00	2017-08-25 15:59:52.528977+00
266	263	134	19	Ang mga salitang may pero	napakasakit na katotohanan.	0	0	f	f	2017-08-25 16:07:04.176999+00	2017-08-25 16:07:04.176999+00
263	\N	134	1	Ang mga salitang may pero	At sa araw ng pagdadalamhati - \nIyong binanggit mo ang mga salitang\nGustong gusto kong marinig\nSa gitna ng mga payong\nNa umiikot kasama ang pagpatak ng mga ulan.\n\nAng mga bituin ay nakatago sa ulap,\nSa halip ito ay binalangkas ng iyong malakas na ihip\nPapunta sa aking malambot na mga tainga\nKung saan iyong binalangkas ang salitang,\n"Gusto kita pero..."\nAt hindi ko na narinig ang mga sumusunod.	1	1	f	f	2017-08-25 05:19:34.848039+00	2017-08-25 16:07:04.176999+00
268	258	132	42	Ako'y Sundalo at Ama	maraming salamat, kaibigan! :)	0	0	f	f	2017-08-25 19:39:14.681345+00	2017-08-25 19:39:14.681345+00
270	269	138	29	Paano	"Paano mo nga bang masasabi na tama na"\n\nTama na. Hindi na tama.	0	0	f	f	2017-08-26 10:15:10.735739+00	2017-08-26 10:15:10.735739+00
271	\N	139	29	Pasensya	Pagpapasensyahan kita na may nagustuhan kang iba habang tayo pa kasi hindi mo 'yon mapipigilan\nPero sana pagpasensyahan mo rin ako sa aking pag-iyak, sa di ko pagngiti, sa hindi ko pagtingin... pagpasensyahan mo rin sana na nasasaktan ako kasi hindi ko rin 'to mapipigilan\n\nWag mo sanang hilingin na di ako masaktan kasi lalo lamang na sumasakit ang lahat	3	0	f	f	2017-08-26 10:19:44.775643+00	2017-09-02 08:02:49.073137+00
273	269	138	2	Paano	paano? sabihin mo bilang tao :)	0	0	f	f	2017-08-26 14:23:18.03874+00	2017-08-26 14:23:18.03874+00
267	\N	137	29	Akala Ko	Akala ko sapat pa, iyon pala'y salat na\nAkala ko'y dapat pa, iyon pala'y awat na\n\nAkala ko'y tama pa, iyon pala'y mali na\nAkala ko'y ipagpapatuloy pa, iyon pala'y aalis ka na	2	0	f	f	2017-08-25 16:08:58.098607+00	2017-09-02 08:02:50.928779+00
282	\N	148	26	parada ng itim	may parada ng itim. \npinuno ang mga kalsada\nng karimlan.\n\nmay parada ng itim.\nnilikha ng mga taong\nlumalaban, \ntumututol,\nnagluluksa.\n\nmay parada ng itim.\nngunit, sa mga puso\nng mga taong\nsuot ang karimlan,\nnag-aalab ang\nliwanag. 	2	0	f	f	2017-09-21 13:55:56.239615+00	2017-10-18 09:43:10.941661+00
277	\N	144	26	bihag	ako ay bihag\nng sarili kong isipan\nng sarili kong iniisip. \n\nako ay bihag\nkinulong sa selda\nng kadiliman\nna matagal ko nang\ngustong takasan. \n\nako ay bihag\nng pagkabalisa. \n\ntulong.	4	0	f	f	2017-08-27 09:02:12.877624+00	2017-10-18 09:12:53.05854+00
269	\N	138	19	Paano	Paano mo nga ba malalaman kung kailangang itigil na\nPaano mo nga bang masasabi na tama na\nPaano mo nga ba tatapusin ang sinimulan\nPaano mo nga ba ipaiintindi na wala ng pinatutunguhan\n\nPaano ko ba sasabihin sayo, na ayoko na.\nPaano? \n	3	3	f	f	2017-08-26 05:52:23.506441+00	2018-01-01 15:09:16.341669+00
274	\N	141	44	Desisyon	Ako ay gagawa ng desisyon\nNgunit may dalawang desisyon na umaakit sakin.\nAng isa ay puso na nagsasabi kaya pa, maayos pa. \nAt ang isip na nagsasabi na tama na, nagmumuhka ka ng tanga.	4	2	f	f	2017-08-27 05:13:46.789507+00	2018-02-06 16:21:53.34415+00
272	\N	140	2	Sinasariwa ko ang ating pagmamahalan - Sulat ni adan kay eva	nasilayan kita sa hardin ng paraiso\n\nikaw ang tanging bulaklak sa tagsibol\n\nngunit ang iyong ilaw \n\nsa aking mata ay sumilaw\n\nang iyong bango \n\nay sapat upang alisin ang pagod ng katawan\n\nngunit sa iyong mga mata\n\nang Diyos mismo ay nagsilang\n\nng pagasa at pagibig\n\nsa ating mga puso	3	0	f	f	2017-08-26 14:19:02.415336+00	2017-09-02 08:02:48.359325+00
276	\N	143	44	Luha	Luhang nagsisilbi daan para maialis ang sakit na iyo nararama.\nLuhang nagsisilbing daan upang bumangon ka at ipaharap sa kanila na kaya ko na. Tapos na.	2	0	f	f	2017-08-27 05:27:17.180972+00	2017-10-18 09:12:53.720374+00
286	285	151	1	Pagsisisi	Dama ko ang iyong pagsisisi	0	0	f	f	2017-10-18 09:12:43.329429+00	2017-10-18 09:12:43.329429+00
275	\N	142	44	Kapit	Ako ay iyong lubid na matagal mo ng kinakapitan.\nAko ay iyong lubid na maaring maputol.\nPero may ginawa kang deaiayon na agad nag putol sa akin. Ang mga salitang \n"Sakit na sakit na ko habang kmakapit sayo. Pero mahal kita pero paalam na.	2	0	f	f	2017-08-27 05:17:37.360643+00	2017-10-18 09:12:54.599163+00
278	\N	145	4	Tula 5 - Ang iniwan mong pahina sa akin	Sa ating paglalakbay noong nakaraang taon,\nBiniyayaan mo ako ng ilang pahina sa aking buhay\nNa makasama ka sa oras na ako ay nasa\nKagipitan, pagdurusa at pangamba.\n\nAking papahalagahan ang mga matatamis na oras,\nNa tayo'y nagkasama sa araw-araw na biyaya mo sa akin\nKung saan ang mga mata natin ay nagtugma ng tingin,\nNakakasilaw at nakakabighani ang iyong titig sa akin.\n\nAt itong mga nakakatuwang pahina ng aking buhay na iyong\nPinagkaloob sa akin - hindi ko ito pupunitin,\nAt lalo ko itong pagyayamanin sa buong pagkatao ko\nSapagkat ako ay iyong nabago sa puso.\n\nAt kung ako ay mawawala sa mundong ito,\nAng kabanata na tayo'y magkasama ang aking \nNatatanging pinaka-gustong masalaysay habang \nnabubuhay ang alaala mo sa isipan ko.	2	0	f	f	2017-09-02 08:02:39.779422+00	2017-10-18 09:12:52.373337+00
287	285	151	2	Pagsisisi	Ito ay isang napakagandang tula tungkol sa pagbabago. maraming salamat sa iyong pagsulat.	0	0	f	f	2017-10-18 09:43:00.678986+00	2017-10-18 09:43:00.678986+00
280	\N	146	34	sa iong katahimikan	ang katahimikan mong gaia ng hatanggabi'y\ndinala ang mga kakaibang tunog sa akin:\n1. gaia ng tibok ng mga puso nating 'di tugma\n2. mga yapâk na unti-unting humihinà,\n3. buntunghiningâng kay lalim; 'di ka mahagip\n4. himig ng sinakiang tren palaio sa akin\n\nmainam pa iata kung ikao ay sumigao\npagka't batid kong ikao ay 'di naoalai	4	0	f	f	2017-09-20 16:18:33.897606+00	2017-10-18 09:43:11.43063+00
288	\N	152	19	Mahirap	Napakahirap mong hindi mahalin	1	0	f	f	2017-10-30 13:17:31.357527+00	2017-11-03 06:16:00.424105+00
202	\N	106	38	para sa kauna-unahang babaeng inibig ko	Binibini,\r\n\r\n\r\nPinili kita kahit hindi ka kapili-pili dahil alam kong hindi mo ako mabibigyan ng kaligayahan na matutumbasan nila. \r\n\r\nMay mga oras na gusto kitang sukuan, gusto kong sukuan ang nararamdaman ko sa iyo, gusto kong maghanap na mas hihigit pa sa iyo. \r\n\r\nNgunit kahit ginawa ko ang lahat, ikaw pa rin ang nangingibabaw sa damdamin ko. \r\n\r\nIkaw pa rin kahit may mga araw naiisip kong, “Nagkakagusto ako sa iba.” \r\n\r\nTuwing naiisip ko iyon, bigla kong masisilayan ang iyong mukha – ang mukha na tila walang pakialam sa mundo dahil walang kabaitan ang nasa puso mo kahit kapiranggot, ngunit ikaw ang tipong babaeng handang sumalungat sa iyong kakayahan upang magmahal nang tunay at magbigay ng nararapat na pagpapahalaga sa tao. \r\n\r\nKahit isasanla mo ang malaking aspeto ng iyong kaugalian, gawa ka at gagawa ng mga paraan upang maging malambing. \r\n\r\nAt, lahat nang iyon ay naaalala ko tuwing nakikita kita. \r\n\r\nInibig kita kahit wala akong pag-asa sa iyo, at kahit alam kong may ibang magbibigay ng tunay at matagalang kaligayahan. \r\n\r\nTinulungan mo akong bumalik sa katotohanan; tinulungan mo akong balansehin ang pag-iilusyon at sa pagiging makatotohanan, kaya salamat. \r\n\r\nSalamat sa mga oras na ningingitian mo ako kahit sinasabi mong hindi ka ang tipong tao na mahilig ngumiti. \r\n\r\nSalamat sa pag-aalala sa akin na may mga hangganan ang mga nararamdaman, at hindi ito dapat karaniwang nakahihigit sa isipan. \r\n\r\nSalamat na ipinakita mo ang tunay na ikaw. \r\n\r\nSalamat sa mga alaala.\r\n\r\n\r\nMananatili at mananatili,\r\n\r\nBolerang bata\r\n	4	2	t	f	2017-08-09 08:56:28.190486+00	2017-11-04 08:42:36.385153+00
290	\N	154	38	para sa ikalawang babaeng inibig ko	Aking Kawal,\n\n'Yan ang matatawag ko sa 'yo.\n \nIsa kang kawal ng bayang ito na patuloy lumalaban kahit ika'y nagkakasakit.\n\nAng iyong sandata ay ang ilang basong kape na nanlalamig na sa tabi ng bundok ng mga sagutang papel namin.\n\nIsa kang kawal para sa kapuwa mong kababaihan na patuloy lumalaban dahil naniniwala ka na kami ay ang pag-asa ng bayan.\n\nHawak-hawak mo ang sandata ng salita na sumiklab ng apoy ng gawa at magkaroon ng taos pusong unawa sa maralita.\n\nIsa kang kawal na lumaban, at nag-iwan ng sugat sa aking damdamin.\n\nSinabi mo, "May mahahanap pa akong iba," dahil alam mong hinding-hindi mo kayang ibigin din.\n\nInunawaan kita.\n\nAng mahalaga ay iyong pag-unawa sa akin.\n\nDahil sa 'yo, ako'y naging kawal din.\n\nNilabanan ko ang kirot na namumuot sa puso ko tuwing hihiga ako ng kama sapagkat ikaw ang una ang papasok sa aking isipan sa dulo ng gabi.\n\nNilabanan ko ang taksil ng kasaysayan. \n\nTumayo ako at ginamit ang aking tinig upang ipakita sa bayan na ako ang produkto ng iyong kagalingan.\n\nNgunit, nang lumaan ang panahon, tinuruan mo ako maging kawal para sa sarili.\n\nKailangan kong maging kawal upang ipagtanggol ko ang aking sarili at hindi dapat puro iba.\n\nSabi mo, "Hindi ko kinakailangan na lumaban ka para makilala ako bilang isang bayani.\n\nAng hinihiling ko lang na ikaw mismo ang maituturing na bayani ng iyong henerasyon."\n\nKaya salamat.\n\nSalamat na ikaw ang nagturo sa akin na lumaban.\n\nAng pag-ibig ko sa iyo ay ang turo sa akin ng daan patungo sa pagiging kapuwa kawal mo.\n\n\n\nLumalaban pa rin kahit wala na sa piling mo,\n\nAng Pag-asa ng Kabataan	1	0	f	f	2017-11-04 08:41:20.846013+00	2017-11-09 11:01:51.674012+00
289	\N	153	1	Kung iisipin mo ang mga sandaling hindi mo na mababalikan	Sa pagkadami-dami ng mga pagkakataong lumipas,\nAng iyong maamong pisngi, mahabang buhok at ang iyong mga mapupulang labing,\nAy nagiging laman ng aking isip sa bawat sandali\nSa aking mga malalalim na panaginip.\n\nNgunit ngayon ay wala na ang ating mga lambing,\nTayo ay nilamon na rin ng ating mga pangarap sa buhay,\nKung mararapatin gusto kong balikan ang kahapon din,\nPero hindi mo na magagalaw pabalik ang kamay ng orasan.	1	1	f	f	2017-11-03 06:15:29.364999+00	2018-02-06 15:29:07.571105+00
294	\N	158	9	Tokhang	Halakhak mo siyang aking naaalala.\nPinangarap ka noon makasama.\nHiwaga ng panahon, kay bilis sinta.\nHanggang di ka na nakita. Saan na kaya?Dasal ko'y itinupad naman, kay ligaya! Laking pasasalamat.\nSadyang kay hiwaga talaga.\nDati'y halakhak lang, ngayo'y nakahimlay ka na.	2	0	f	f	2017-11-11 09:07:44.982406+00	2017-11-13 01:50:33.748051+00
295	\N	159	9	Pasalubong	Napadaan ka pala; \nako'y nagalak ng mabalitaan.\nNabuhay muli ang mga alaala.\nDi gusto kang makita na,\nupang di na makagulo pa.\nSa iyo ako'y nasisiyahan;\nhangad ko'y pag-ibig \ntunay sa inyong samahan,\nmapa sa walang hanggan.	1	1	f	f	2017-11-29 08:35:22.938913+00	2018-01-13 01:30:46.545534+00
291	\N	155	38	sa aking bituin blg. 1	(para sa babaeng iniibig ko sa kasalukuyan)\r\n\r\nPag-ibig,\r\n\r\n'Wag na 'wag mong iisipin na malaki ang utang mo sa loob 'pag nagkakaroon ka ng oras ng kaligayahan.\r\n\r\nHindi ka karapat-dapat na matakot sa akin.\r\n\r\nHuwag ka mabahala kapag mas tinitignan ko ang iyong kalakasan kaysa sa iyong kahinaan.\r\n\r\nOo, masama ang iyong ugali, ngunit sapat na ba iyon upang lubayan kita?\r\n\r\nNahumaling nga ako sa kasanayan mo, pero nahulog ang aking loob sa iyong kahinaan.\r\n\r\nKakaiba, 'di ba?\r\n\r\nTotoo naman.\r\n\r\nAlam ko na napapaligiran ka ng mga taong nagagalit sa 'yo.\r\n\r\n"Pabibo" ka raw kasi.\r\n\r\nAt, naniniwala naman ako ro'n.\r\n\r\nKaya hindi naman ako makakapagtaka kung puro masasamang salita ang hinihilamos sa 'yo.\r\n\r\nNgunit, kinakailangan mo ng taong makakakita ng iyong kalakasan at kabutihan.\r\n\r\nNaramdaman ko iyon nang sinabi mo sa 'kin, "Bakit ba ako nanatili rito?" \r\n\r\nMaraming naiinggit sa kasanayan mo, kaya nakapagtataka talaga kung sinabi mo 'yan.\r\n\r\nAt, sa puntong iyon, nakita ko sa mata mo na kinakailangan mo ng taong na magsasabi, "Nandito pa rin naman ako, ha.\r\n\r\nNaniniwala pa rin ako sa iyo," at aaraw-arawin niya 'yon.\r\n\r\nKaya ako ang gumawa no'n.\r\n\r\nMas pinili kong tignan ang kalakasan mo kasi iyon ang magpapanatag sa loob mo sa mundo ng mga taong galit sa 'yo.\r\n\r\nBituin, 'wag mo na sila pansinin.\r\n\r\nNandito ako para tanggapin ka at baguhin ka para sa kapakanan mo.\r\n\r\nGusto kita magbago.\r\n\r\nGusto kita magbago.\r\n\r\nMagbago ka na mula sa kaugalian mo na iniiwasan mong maging maligaya kasi iniisip mo na iyon ay malaking utang sa mundo.\r\n\r\nKaya ang kapalit no'n ay magiging malungkot ka sa susunod na araw.\r\n\r\nBituin, baguhin mo na 'yon.\r\n\r\nAlam kong takot ka pa rin sa akin.\r\n\r\nTakot ka na may magagawa kang mali at masasaktan mo ako nang sobra dahil doon.\r\n\r\nTakot ka na masaktan ako.\r\n\r\nAyaw mo akong masaktan dahil sinabi mo, "Ikaw ang kauna-unahang tao na nagparamdam sa akin na mahalaga ako sa mundo."\r\n\r\nKaya lagi mo akong inaalagaan.\r\n\r\nNandiyan ka sa tabi ko tuwing ako ay may sakit.\r\n\r\nNaaalala mo pa ba noong pumunta ka pa sa clinic para kuhan ako ng Biogesic kasi masakit ang ulo ko.\r\n\r\nTapos nagtampo ka dahil sarado na pala sila.\r\n\r\nNakikinig ka sa mga kuwento ko ng kadramahan.\r\n\r\nMinsan nga, napapagalitan mo ako dahil sa mga kalokohan ko.\r\n\r\nLagi mo akong pinapaalala na, "Mag-aral ka nang mabuti. \r\n\r\nKaya mo 'yan, ha."\r\n\r\nGinanahan pa nga ako gumising ng hatinggabi upang mag-aral hanggang ala-sais ng umaga para sa markahang pagsusulit.\r\n\r\nNgunit, nagagalit ka 'pag ako ay napapagod.\r\n\r\nGusto mo na lagi ako may pahinga.\r\n\r\nDumating nga sa punto na sinabi mo, "Nagpipigil akong murahin ka.\r\n\r\nMagpahinga ka!"\r\n\r\nBituin, 'wag na 'wag kang matatakot sa akin dahil may takot din naman ako para sa 'yo.\r\n\r\nTakot ako na naghihirap ka dahil hindi ka naniniwala sa mga kakayahan mo.\r\n\r\nTakot ako na sa tuwing gigising ka at matutulog ka, iisipin mo na wala kang halaga.\r\n\r\nBituin, mahalagang-mahalaga ka.\r\n\r\nMahalaga ka sa akin.\r\n\r\nGusto mo na lagi akong masaya, 'di ba?\r\n\r\nAt, ikaw ang ligaya ko.\r\n\r\nKaya, gusto ko maging maligaya ka kasama ako.\r\n\r\n'Wag ka na matakot.\r\n\r\n(Kahit alam ko na hindi pala tapat ang iyong intensyon sa akin)\r\n\r\n\r\nNandiyan palagi dahil matigas ang ulo ko,\r\n\r\nKauna-unahan Mo	1	0	t	t	2017-11-04 09:13:23.425115+00	2017-12-02 12:43:56.829231+00
297	295	159	47	Pasalubong	Mahusay po! Maikli man pero epektibo. Nakakaantig ng damdamin.	0	0	f	f	2018-01-01 14:40:54.241551+00	2018-01-01 14:40:54.241551+00
298	285	151	47	Pagsisisi	Nakakapanggising!\nMahusay po.	0	0	f	f	2018-01-01 14:43:21.284843+00	2018-01-01 14:43:21.284843+00
299	269	138	47	Paano	Paano? Salitang mahirap makaapuhap ng paraang wasto.	0	0	f	f	2018-01-01 15:09:16.341669+00	2018-01-01 15:09:16.341669+00
300	281	147	47	Ikaw pa rin	Napakaganda at napakahusay!	0	0	f	f	2018-01-01 15:10:55.56557+00	2018-01-01 15:10:55.56557+00
303	\N	162	29	Sumusuko Na Ko	Marahil ako'y nagkulang\nHinayaang  ika'y malimutan\n\nAlam nang nagkakamali\nPatuloy lang sa pagkakamali\n\nInakalang tama ang akala\nNa hindi dapat maniwala\n\nSa aking muling pagluha\nIkaw ang nagpatahan, yumakap at naniwala	0	0	f	f	2018-01-20 13:50:40.268056+00	2018-01-20 13:50:40.268056+00
301	296	160	1	Para sayo ang pagsuko (Ang Unang Bahagi)	ISA KANG MAKATA penknife! Saludo ako sa tapang na iyong pinamalas sa pagsulat ng liham na ito.	0	0	f	f	2018-01-13 04:04:05.60497+00	2018-01-13 04:04:05.60497+00
302	\N	161	48	Pasensya Ka Na	Hindi ito ang aking gusto\nNa tayo magkalayo, iwanan ka o iwanan ako\nHindi ko kaya ibaon lahat sa limot\nIkaw, aking ligaya mula nuon hanggang ngayon\n\nNgunit pasensya ka na\nDahil nandito tayo ngayon\nNapaggitnaan ng labing walong kilometro\nNa hindi kailan man mapupuno ng kahit sino\n\nWag ka sana magalit sa aking pagbitaw\nPero sana malaman mo na ikaw ang nauna\nKahit gusto ko maiwan sa lugar na ito\nAlam ko, ako na lang laman nito\n\nNgiti mo lamang tanging hiling\nKahit sa pangarap ko na lang namamalagi\nPero hindi ko matutupad aking pangako\nNg mga labi ko na puno ng hinagpis\n\nMinsan ayoko na lang gumising\nSa mga panaginip natin sa nakaraan\nDahil alam ko kinabukasan\nSa tabi ko wala ka na\n\nLaman ka pa din ng aking mga dasal\nNa baka hindi pinapakinggan\nDahil mata mo hindi pa din magkita\nNg mga mata ko na laging puno ng luha\n\nTandaan mo palagi\nHindi ako umalis dahil ayaw ko na\nHindi kailaman na ito ang aking gusto\nNa tayo magkalayo, iwanan ka o iwanan ako	0	0	f	f	2018-01-16 09:31:18.460091+00	2018-01-16 09:31:18.460091+00
305	304	163	20	Wala	Marahil hindi pa ngayon ang inyong panahon, kaibigan. Nawa'y sa paglipas ng oras ay maghilom ang mga sugat na pareho ninyong natamo sa nagdaan na kahapon. 🙏\n\nMuli, salamat sa pagbabahagi ng iyong liham	0	0	f	f	2018-01-25 02:42:35.700167+00	2018-01-25 02:42:35.700167+00
304	\N	163	48	Wala	Wala na tayo\nIto tayo ngayon\n\nWala ka na\nKalayaan pinili mo\n\nWala na ko\nSarili ko'y nadudurog\n\nWalang dahilan\nPara ako'y nandito\n\nWala na ba\nPag-ibig mo'y aking tanong\n\nWala na nga ba\nPag-asang tinatamo	0	1	f	f	2018-01-24 13:55:46.697484+00	2018-01-25 02:42:35.700167+00
306	2	2	50	Para sa mga patuloy na lumalaban	Paano naman yung mga sumuko na? katulad ko :(	0	0	t	f	2018-01-25 11:08:39.718402+00	2018-01-25 11:08:58.359228+00
307	5	3	50	Pag-ibig	Nasa isip mo lamang ang mga positibo ng pag-ibig. wag ka masyado mag isip masasaktan ka lang.	0	0	f	f	2018-01-25 11:10:10.969203+00	2018-01-25 11:10:10.969203+00
308	9	7	50	Liham para sa hokage	wag mo hanapan ng pag ibig ang isang hokage. dahil sila ay likas na ninja. wala kang mapapala.	0	0	f	f	2018-01-25 11:12:33.116267+00	2018-01-25 11:12:33.116267+00
9	\N	7	2	Liham para sa hokage	Ginoong hokage nasaan ang pagibig na iyong ipinaglalaban? Nasaan ang mga yakap na ibinigay ng iyong mga magulang?\r\n\r\nNasaan ang katotohanan sa iyong mga salita, nasaan ang kislap sa iyong mga mata.\r\n\r\n**Patay na ba? Patay na?**\r\n\r\nSa kanaisang humanap ng pagibig, ikaw ay lumisan sa iyong pamanang-tawag ng kadakilaan.\r\n\r\nsusuko ka na lamang ba sa huwad na imahe... ng katawan na pinagbuhol buhol, sa ilusyon ng pagibig na sa puso mo'y kumakahon.\r\n\r\nBumasag ka't umahon. Hindi ka mababaon, sa pagiisip na ang pagibig ay mababaw, mula sa puso mo ay sisikat. \r\n\r\nIsang lumalagablab, \r\n\r\nnagsusumigaw\r\n\r\nna bagong araw.	0	1	f	f	2017-07-12 15:52:06.507058+00	2018-01-25 11:12:33.116267+00
309	115	59	50	Ninakaw na Tsokolate	hindi ba pwedeng nagkamali lang? bawal bang humingi ng paumanhin?	0	0	f	f	2018-01-25 11:14:44.482681+00	2018-01-25 11:14:44.482681+00
115	\N	59	1	Ninakaw na Tsokolate	Sa aming hapag-kainan ay iyong ninakaw,\nAng tsokolate kong pinaghirapan.\nNa wala man lang paalam at kami ay iyong\npinaghiwalay ng landas.\nAng tsokolate kong inaasam-asam ay wala na\nWala na sa aking mga mata,\nPaalam aking tsokolate.\n\nNgunit bibili ulit ako ng isa sa tindahan,\nDahil natuto na akong pahalagahan ka.\nIkaw ay madaling mawala.\nAng iyong natatanging tamis \nay aking nagustuhan.	2	4	f	f	2017-07-28 14:00:44.98977+00	2018-01-25 11:14:44.482681+00
310	15	11	50	Patak	sigurado ka ba na nabilang mo ang patak ng ulan?	0	0	f	f	2018-01-25 11:15:46.317579+00	2018-01-25 11:15:46.317579+00
296	\N	160	47	Para sayo ang pagsuko (Ang Unang Bahagi)	Arkey,\n\nMahal ko,alam kong hindi mo mabibigyang pansin ang kapirasong liham na to para sayo. Itong mga salitang nagmula pa sa kasulok-sulokang bahagi ng puso kong sayo lang lumulukso. Mangalay man ang kamay ko, magkanda tulo man ang luha ko, itutuloy ko ito kasi hindi ko na kayang itago-- ang hirap at sakit ng kabiguang natamo ko sayo.\n\nBalikan natin noong  ika-8 ng Pebrero, araw na dumating ka. Pinagtagpo tayo ng mapaglarong tadhana. Nahulog ako sayo at ganun ka rin. Nagmahalan tayo kahit mali. Binalewala ang mga panghuhusga ng iba. Kumapit sa isa't isa kahit kakarumpot lang ang pag-asa. Nangako ka pa nga diba? Sa kaligayahan at kalungkutan, walang iwanan sa ating dalawa. Natatandaan mo pa ba,ha? \nKaso siguro hindi na... Natakpan na kasi ng mga hindi kasiya-siyang pangyayari sa ating relasyon. Nilunod ng mga luhang hindi ko alam kung ilan ang pumatak hanggang sa naging malabo.\nNaguguluhan ako. Nasasaktan ng sobra ngayon. Bakit humantong sa ganito ang lahat? Hindi ba ako karapat-dapat? Sayo ba'y di sapat?\nPakisagot mo naman po nang matapat.\n\nMas mahal mo siguro siya.\nSa kanya ka siguro mas masaya. Sa kanya ka siguro mas humahanga. Oo. Sa kanya ka. Ganun din siya para sayo.\nPaano naman kaya ako? \n\n Sumisikip ang dibdib ko. Hanggang dito na lang muna ako.\n\n(Itutuloy)	1	2	f	f	2018-01-01 14:35:57.222948+00	2018-02-06 15:26:26.643103+00
313	289	153	47	Kung iisipin mo ang mga sandaling hindi mo na mababalikan	Tagos sa puso. \nNakakapanghinayang nga lang talaga, na di na natin pa kayang baguhin ang mga natapos ng nangyari.	0	0	f	f	2018-02-06 15:29:07.571105+00	2018-02-06 15:29:07.571105+00
315	274	141	47	Desisyon	Isip at puso?\nMahirap po kung saan ka papanig.\nSiguro, dapat magkasama na lang. Babalansehin kung anong kulang sa pagitan ng dalawa.\nDagdagan din natin ng pananampalataya!	0	0	f	f	2018-02-06 16:21:53.34415+00	2018-02-06 16:21:53.34415+00
316	\N	166	47	Lingid Sa Kanya	Oo...\nSiya nga...\n\nPakisabi na lang na mahal ko siya.\n\n-Mula sa babaeng nakatitig sa 'di kalayuan\n	0	0	f	f	2018-02-06 16:26:21.704633+00	2018-02-06 16:26:21.704633+00
317	311	164	47	Bakit	"Bakit?"\n\nIsang salita. Limang letra. Isang tanong na naghahanap ng maraming kasagutan.\nMinsan, masarap malaman ang katotohanan.\nPero may mga bagay na kapag iyong nalaman,hindi mo maiiwasang masaktan.	0	0	f	f	2018-02-07 13:53:35.03751+00	2018-02-07 13:53:35.03751+00
318	311	164	48	Bakit	Siguro nga penknife. \nPero mayroon ako karapatan sa katotohanan.\nDi bale ako'y masaktan.\n\nKatotohanan ang tunay na magpapalaya sa akin.	0	0	f	f	2018-02-07 14:32:24.730496+00	2018-02-07 14:32:24.730496+00
319	\N	167	29	Kaibahan	Mahal, oo mataas ang “pain tolerance” ko\nNgunit di ibigsabihin na mabilis ding mahilom ang sugat ko\nLalo na kung katulad at kasing lalim ito ng idinulot mo\nLalo pang masakit kung ang sugat na itong tinutukoy ko ay mula sayo mismo	0	0	f	f	2018-02-13 04:55:20.369304+00	2018-02-13 04:55:20.369304+00
320	\N	168	48	Bulaklak	Gusto ko ng mga bulaklak\nNgunit hindi ang bulaklak na alam mo\n\nAyaw ko ng mga rosas\nKahit taon taon mo iyong inaabot\n\nAyaw ko ng mirasol\nPinapaalala neto ang kataksilan ko\n\nAyaw ko ng mga bulaklak\nMga bulaklak na alam mo\n\nAyaw ko ng mga salita\nNa mabulaklak tulad ng mga harana noon\n\nAng bulaklak na nais ko\nAy ang damdaming namumulaklak sa puso mo\n\nNgunit ano nga ba ang laman nito,\nNgitngit o Pag-irog?	0	0	f	f	2018-02-13 14:38:24.536174+00	2018-02-13 14:38:24.536174+00
321	314	165	1	Para sayo ang pagsuko (Ang Ikalawa at Huling Bahagi)	Maraming salamat sa pagbabahagi ng iyong pakiramdam sa liham.ph. Isa kang tunay na makata.	0	0	f	f	2018-02-14 16:26:17.291354+00	2018-02-14 16:26:17.291354+00
314	\N	165	47	Para sayo ang pagsuko (Ang Ikalawa at Huling Bahagi)	Arkey,\n\nSa hindi inaasahang pangyayari at pagkakataon, nagbago bigla ang ikot ng ating mundo. Yung dating mahahaba at malalambing nating pag-uusap, ang madalas nating pagkikita at pagsasama, yung dating masaya nating biruan at kuwentuhan.... Nasaan na yung mga dati na iyon?\nTinangay na ng malamig na simoy ng hangin ang dati ay marubdob nating pag-ibig. Natabunan na ng laging tampuhan,bangayan at hindi pagkakaunawaan.\nTuluyan mo nang ibinaon sa limot ang ating kahapon. Nakalimutan mo na ring may TAYO dahil masaya ka na sa mayroon KAYO ngayon.\n\nSiguro nga hanggng dito na lang ang ating kuwento. Masakit mang tanggapin pero ano pa bang magagawa ko? Ano pang saysay na umasa, kumapit at lumaban ako? Kung ikaw na mismo ang bumitaw at kusang lumayo.\n\nNakamarka pa rin sa aking alaala ang masakit na katotohanang nagpabago sa lahat. Noong panahong binitiwan mo ang mga katagang nagdulot ng sakit at nagpamanhid sa akin.\n"Tama na. Ayoko na.\nHindi na kita mahal."\n \nHindi ako makagalaw nang mga sandaling iyon. Masakit... Oo. Pero salamat.\nSinabi mo kung ano talaga ang nasa loob mo.\n\nLumipas ang maraming oras at araw. Sa isang pagkakataon, nakita kita. Nakita kitang may kausap. Alam kong siya yun. Napatigil ako saglit sa kinatatayuan ko. Naaninag ko ang kislap sayong mga mata. Ang mga ngiti sa labi mong abot hanggang tainga.\nNapayuko ako noon. Hindi ko nakita ang ganoong awra mo nung tayo pa. Kaya siguro tama ang naging desisyon mong ipinagpalit mo ako sa kanya.\nDahil mas masaya ka sa piling niya.\n\nSa pagtatapos ko ng liham na ito, asahan mong susuko na ako. Hindi na ako aasa at maghihintay na baka bukas, biglang bumalik sa dati ang lahat. Hindi na ako aasa pa na babalik ka sa akin, na babalik ang dating tayo... Hindi na po.\nPinagtagpo nga tayo ng tadhana pero hindi tayo ang inilaan para sa isa't isa. \n\nGusto kitang pasalamatan. Sa sobrang dami, hindi ko maapuhap ang eksaktong salita. Heto na lang.\nMaraming salamat ha?\n\nPatawad din. Aminado akong nagkulangako sayo. Nakalimot. Nabalewala kita. Nasaktan ka. Hindi kasi ako perpekto na tao. Kaya patawad, mahal ko.\n\nHanggang sa muli... Hanggang sa muling pagtatagpo ng landas nating dalawa. At sana... Sa sandaling mangyari yon, wala na ang hinanakit at lungkot sa ating mga puso. Sana, totoong masaya na ako sa kung anong meron tayo. Sana, nahanap na natin ang tunay na kaligayahan at naghilom na ang mga sugat na gawa ng nakaraan.\n\nAdios.\n\nPaalam, mahal ko.\n\nT T\n\nAng taong minsang nagmahal sayo,\nR. M. D. M.\n	0	1	f	f	2018-02-06 15:52:49.23581+00	2018-02-14 16:26:17.291354+00
\.


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: posting; Owner: lihamph
--

SELECT pg_catalog.setval('post_post_id_seq', 321, true);


--
-- Data for Name: topic; Type: TABLE DATA; Schema: posting; Owner: lihamph
--

COPY topic (topic_id, title, author_id, upvote_count, reply_count, is_deleted, created_date, last_updated_date) FROM stdin;
50	Paalam	19	2	0	f	2017-07-28 05:34:48.556792+00	2017-08-04 06:07:46.90106+00
54	pagkakaiba	26	4	1	f	2017-07-28 11:38:10.648072+00	2017-08-16 23:54:40.524375+00
36	Sigarilyo at Alak	25	4	3	f	2017-07-25 13:24:54.440477+00	2017-07-31 14:31:37.97547+00
45	ulan	26	3	2	f	2017-07-27 01:59:48.297784+00	2017-07-28 08:21:12.405226+00
20	Liham para kay nikki - unang kabanata	2	1	0	f	2017-07-16 01:13:43.19755+00	2017-07-18 00:11:28.183677+00
3	Pag-ibig	3	6	3	f	2017-07-12 10:49:06.29448+00	2018-01-25 11:10:10.969203+00
33	Luha	19	4	2	f	2017-07-24 17:25:05.311685+00	2017-07-26 09:58:50.771738+00
4	Tama Na	5	0	0	f	2017-07-12 11:12:55.563494+00	2017-07-12 11:12:55.563494+00
17	Panatang Makabayan	6	2	1	f	2017-07-15 03:52:15.361776+00	2017-08-04 02:38:35.143065+00
27	Saloobin	13	1	1	f	2017-07-17 14:27:18.946436+00	2017-07-18 06:03:54.068364+00
59	Ninakaw na Tsokolate	1	2	4	f	2017-07-28 14:00:44.98977+00	2018-01-25 11:14:44.482681+00
46	makata	26	4	3	f	2017-07-27 04:31:00.0027+00	2017-07-28 08:21:18.424353+00
31	Bilang	7	2	0	f	2017-07-20 04:57:08.287747+00	2017-08-16 15:28:26.388303+00
13	Salamat	11	0	0	f	2017-07-13 13:21:04.599535+00	2017-07-13 13:21:04.599535+00
14	Ako lamang	11	0	0	f	2017-07-13 13:22:06.698535+00	2017-07-13 13:22:06.698535+00
15	Liwanag	11	0	0	f	2017-07-13 13:25:48.736847+00	2017-07-13 13:25:48.736847+00
16	malaya	14	0	0	f	2017-07-14 07:14:06.984256+00	2017-07-14 07:14:06.984256+00
10	Ere at Plano	9	1	1	f	2017-07-13 02:44:29.768663+00	2017-07-15 17:24:01.662558+00
2	Para sa mga patuloy na lumalaban	2	0	2	f	2017-07-12 08:33:08.266768+00	2018-01-25 11:08:39.718402+00
9	Langit	7	1	2	f	2017-07-13 01:02:59.669683+00	2017-07-15 17:25:18.708762+00
8	Bata ka pa talaga...	8	1	0	f	2017-07-12 16:03:31.076756+00	2017-07-15 17:25:19.872761+00
52	tatlo	26	5	3	f	2017-07-28 05:56:30.706815+00	2017-07-29 07:47:54.355019+00
19	Gutom	15	1	0	f	2017-07-15 05:00:09.401398+00	2017-07-15 17:30:12.393174+00
30	Para san ka gumigising?	21	1	0	f	2017-07-19 02:00:50.486755+00	2017-07-20 07:05:12.930492+00
28	Ang pag-ikot	2	1	1	f	2017-07-18 00:16:27.103929+00	2017-07-20 07:05:14.944311+00
38	kadiliman	26	4	2	f	2017-07-26 09:02:59.785645+00	2017-07-27 12:27:54.568873+00
18	Liham Para Kay Nikky - Ikaunang Kabanata	2	2	0	t	2017-07-15 04:49:01.658867+00	2017-07-16 01:13:55.567763+00
55	pagkakatulad	26	4	2	f	2017-07-28 11:39:52.846112+00	2017-08-16 23:54:31.532022+00
21	Si lola	16	0	0	f	2017-07-16 05:32:31.001185+00	2017-07-16 05:32:31.001185+00
22	Pangungulila	16	0	0	f	2017-07-16 05:34:48.467443+00	2017-07-16 05:34:48.467443+00
23	Tungkulin	17	0	0	f	2017-07-16 05:41:22.957903+00	2017-07-16 05:41:22.957903+00
25	Tungkod	18	0	0	t	2017-07-16 14:46:04.068672+00	2017-07-22 06:02:18.21964+00
66	Minsan	19	3	2	f	2017-07-30 03:16:47.940496+00	2017-08-04 06:07:51.136421+00
47	Hiling	19	4	5	f	2017-07-27 11:28:46.986221+00	2017-08-04 03:59:25.613379+00
24	Lihim	17	2	2	f	2017-07-16 05:43:14.834427+00	2017-07-17 00:07:17.676724+00
72	Babae ng Aking mga Pangarap	32	5	2	f	2017-07-31 14:29:56.830983+00	2017-08-16 23:50:53.770675+00
48	Sana	19	3	0	f	2017-07-27 12:34:36.295305+00	2017-08-04 03:59:27.695592+00
84	Sawa na	19	2	0	t	2017-08-03 13:20:06.334778+00	2017-08-15 23:25:30.049+00
79	Alam Mo, Ngunit Hindi...	37	4	0	f	2017-08-03 05:10:54.536524+00	2017-08-16 23:47:19.675266+00
35	pagibig 	25	0	0	t	2017-07-25 13:23:50.441153+00	2017-07-25 13:24:21.093556+00
34	Bungang-isip na tula	24	1	0	f	2017-07-25 10:13:10.821396+00	2017-07-26 05:07:50.037295+00
32	Tula 3 - Paniniwala sa nawala	4	3	0	f	2017-07-24 15:28:24.683926+00	2017-07-26 05:17:10.491632+00
51	Bitaw	19	3	2	f	2017-07-28 05:54:29.09809+00	2017-08-04 06:07:46.088693+00
58	Apoy	29	1	0	f	2017-07-28 12:52:43.965363+00	2017-07-28 13:07:38.549033+00
40	Umaga	19	2	0	f	2017-07-26 09:20:16.524281+00	2017-08-04 04:00:01.834111+00
42	kasinungalingan 	26	4	4	f	2017-07-26 13:32:34.007309+00	2017-07-27 06:39:58.630584+00
43	Pamilya	27	0	1	f	2017-07-26 16:14:27.284806+00	2017-07-27 06:40:34.327253+00
6	Tula 1 - Ang simula at ang huli	4	2	0	f	2017-07-12 13:08:43.411143+00	2017-07-27 06:49:00.955647+00
89	Di Ko Alam	29	3	2	f	2017-08-04 06:06:17.976739+00	2017-08-21 12:19:11.374003+00
12	Magkasama	11	1	0	f	2017-07-13 13:20:31.816766+00	2017-07-30 06:25:34.196629+00
41	wala	26	3	3	f	2017-07-26 12:38:50.999856+00	2017-07-27 06:57:46.357487+00
26	Tula 2 - Anino mo sa ulan	4	3	2	f	2017-07-17 13:44:15.610754+00	2017-07-27 07:03:58.224841+00
65	Hindi	19	0	0	t	2017-07-30 03:13:05.060447+00	2017-07-30 10:06:40.695605+00
64	Bakit	19	2	0	f	2017-07-30 03:04:19.718586+00	2017-08-04 06:07:49.950893+00
62	hiraya	26	2	0	f	2017-07-29 15:15:07.427174+00	2017-08-16 23:52:16.300343+00
39	hapunan	26	1	0	t	2017-07-26 09:14:29.040613+00	2017-08-13 07:25:15.99896+00
53	Takot	19	3	1	f	2017-07-28 06:24:39.485747+00	2017-08-04 06:07:50.246702+00
91	panaginip	26	3	0	f	2017-08-04 13:12:24.992032+00	2017-08-11 09:17:30.618136+00
49	Selos	2	3	4	f	2017-07-28 00:27:01.990406+00	2017-07-28 06:25:08.420934+00
68	Bakit?	31	5	2	f	2017-07-31 07:18:51.885317+00	2017-08-02 11:38:59.737533+00
7	Liham para sa hokage	2	0	1	f	2017-07-12 15:52:06.507058+00	2018-01-25 11:12:33.116267+00
29	Dagupan	9	4	1	f	2017-07-18 15:03:08.412437+00	2017-07-29 02:34:30.685057+00
44	Kita Kita	3	3	0	f	2017-07-26 16:46:09.834228+00	2017-08-20 08:07:53.391225+00
78	Ewan	19	0	0	t	2017-08-02 14:27:05.612121+00	2017-08-02 22:18:55.4352+00
57	pagkikita	26	3	1	f	2017-07-28 11:45:25.690059+00	2017-07-29 07:46:35.838427+00
60	Mainis ka	2	3	1	f	2017-07-29 07:46:05.084905+00	2017-07-30 11:39:38.730272+00
61	Ang engkwentro	2	1	1	f	2017-07-29 07:55:00.097604+00	2017-07-30 11:41:18.544033+00
11	Patak	2	0	2	f	2017-07-13 08:47:18.691912+00	2018-01-25 11:15:46.317579+00
67	paano	26	3	2	f	2017-07-30 13:19:52.972882+00	2017-08-11 09:17:45.721171+00
70	tadhana, anadhat	26	1	0	t	2017-07-31 13:04:24.966862+00	2017-07-31 13:19:57.963736+00
75	paalala	26	4	1	f	2017-08-01 10:14:25.987336+00	2017-08-11 09:17:40.277254+00
71	tadhana, anahdat	26	4	1	f	2017-07-31 13:20:23.539291+00	2017-08-11 09:17:42.162162+00
76	Kulang	2	2	2	f	2017-08-01 14:11:25.527251+00	2017-08-03 13:34:22.105801+00
69	daan	26	2	0	f	2017-07-31 12:19:20.2605+00	2017-08-11 09:17:44.622224+00
56	luha	26	3	2	f	2017-07-28 11:42:40.773221+00	2017-08-16 23:53:57.099731+00
74	Ang lihim na Palabas	33	5	1	f	2017-07-31 19:39:33.726692+00	2017-08-16 23:50:20.348186+00
80	daluyong	26	3	0	f	2017-08-03 11:04:26.768213+00	2017-08-11 09:17:37.81009+00
82	blanko	26	4	0	f	2017-08-03 11:46:55.022014+00	2017-08-11 09:17:34.13549+00
77	Gracielle	35	7	2	f	2017-08-01 15:51:20.709836+00	2017-08-03 13:55:36.350295+00
63	Anong oras na ba? Paano ba basahin 'to?	29	3	0	f	2017-07-29 17:35:10.703441+00	2017-08-03 14:25:24.65204+00
86	ibulông mo sa ákin	34	7	2	f	2017-08-04 00:58:51.08354+00	2017-08-06 11:11:00.664349+00
81	liwayway	26	4	1	f	2017-08-03 11:05:45.119954+00	2017-08-11 09:17:35.776605+00
5	Nalilito	6	1	0	f	2017-07-12 12:54:27.107213+00	2017-08-04 02:38:33.96425+00
85	Ang oras ay isang ilusyon	2	2	1	f	2017-08-03 13:49:02.607299+00	2017-08-04 01:25:02.29757+00
87	Di Ko Alam	29	0	0	t	2017-08-04 06:05:40.178096+00	2017-08-04 06:06:39.726291+00
88	Di Ko Alam	29	0	0	t	2017-08-04 06:06:16.349173+00	2017-08-04 06:06:45.633571+00
37	Pagtatagpo	19	2	1	f	2017-07-26 08:41:43.106864+00	2017-08-04 06:07:42.46345+00
1	Sa mga huni ng mga ibon	1	1	2	f	2017-07-12 08:19:46.844711+00	2017-11-05 14:27:41.332474+00
90	Pagpapaalam O Pagpapaalam	29	1	0	f	2017-08-04 09:11:48.375895+00	2017-08-04 12:50:10.173664+00
73	lílok	34	3	5	f	2017-07-31 18:22:45.463702+00	2017-08-06 11:11:04.64472+00
83	oras	26	5	0	f	2017-08-03 11:49:37.255396+00	2017-08-11 09:17:31.774299+00
106	para sa kauna-unahang babaeng inibig ko	38	4	2	f	2017-08-09 08:56:28.190486+00	2017-08-13 13:05:50.844862+00
146	sa iong katahimikan	34	4	0	f	2017-09-20 16:18:33.897606+00	2017-10-18 09:43:11.43063+00
108	Di Makatulog	29	4	0	f	2017-08-10 11:20:40.603854+00	2017-08-13 13:06:39.679271+00
95	Pag Ibig ng Isang Ina	39	1	0	f	2017-08-04 20:19:03.492392+00	2017-08-05 07:00:32.298596+00
128	ang pag-ápao	34	4	2	f	2017-08-21 03:54:38.367808+00	2017-08-21 13:22:54.008731+00
112	Tula 4 - Ang Tasa	4	3	0	f	2017-08-13 13:03:26.294534+00	2017-08-13 13:11:59.964313+00
98	Tanglaw sa Dilim	39	1	0	f	2017-08-04 20:21:57.762034+00	2017-08-05 07:00:34.2176+00
97	Tanglaw sa Dilim	39	1	1	f	2017-08-04 20:21:57.288833+00	2017-08-05 07:00:35.104662+00
117	pahinga	26	6	0	f	2017-08-15 14:49:11.980469+00	2017-08-21 03:59:32.996981+00
92	tibôk ng pusò sa dapit-hápon	34	5	1	f	2017-08-04 13:49:14.326096+00	2017-08-07 00:42:21.632731+00
164	Bakit	48	0	2	f	2018-02-06 08:59:01.181682+00	2018-02-07 14:32:24.730496+00
99	MJ	35	4	1	f	2017-08-05 01:51:14.838844+00	2017-08-07 00:43:47.465989+00
110	Mata	19	3	0	f	2017-08-13 09:21:13.108197+00	2017-08-13 23:40:00.515589+00
96	Munting Aklatan ni Inay	39	1	1	f	2017-08-04 20:20:18.605633+00	2017-08-07 00:46:14.913836+00
94	Anu ba tayo?	39	2	0	f	2017-08-04 20:18:20.838936+00	2017-08-08 03:27:06.470777+00
113	Taglagas 	19	2	0	f	2017-08-13 15:22:53.587931+00	2017-08-14 11:42:31.018741+00
129	ang sedementación ng puso (bawal hawakan)	34	5	4	f	2017-08-21 05:28:40.411159+00	2017-08-22 20:36:59.988951+00
152	Mahirap	19	1	0	f	2017-10-30 13:17:31.357527+00	2017-11-03 06:16:00.424105+00
101	Bilin	29	2	2	f	2017-08-06 02:52:22.577701+00	2017-08-09 05:40:48.697945+00
100	Sa Pusod ng Gubat	29	2	0	f	2017-08-06 02:33:37.063237+00	2017-08-09 05:40:49.378193+00
130	Madilim ang Langit	3	3	4	f	2017-08-21 12:06:43.837889+00	2017-08-23 22:44:08.485766+00
104	bahà	34	5	0	f	2017-08-08 12:54:11.447934+00	2017-08-15 05:49:35.705304+00
131	Salamat	40	2	0	f	2017-08-22 02:50:29.867358+00	2017-08-23 22:45:35.296326+00
118	Sa Ikatlong Linggo ng Agosto	29	2	0	f	2017-08-16 12:07:33.544645+00	2017-08-21 04:45:24.758753+00
120	Di ko alam	40	1	1	f	2017-08-17 08:43:31.950823+00	2017-08-21 04:48:35.399527+00
115	Sa mga litratong iyong iniwan	1	3	0	f	2017-08-14 11:42:21.619299+00	2017-08-21 04:52:35.809221+00
103	pagod	26	7	0	f	2017-08-07 14:56:37.302746+00	2017-08-11 09:16:55.082281+00
133	Pag-ibig	43	2	1	f	2017-08-24 06:53:00.941929+00	2017-08-24 10:34:57.413025+00
109	Kaibigan	19	0	0	t	2017-08-13 00:35:28.400005+00	2017-08-13 09:21:50.269133+00
124	kay fidel	26	3	1	f	2017-08-20 08:34:12.876968+00	2017-08-21 08:57:45.107886+00
125	Ang pagasa	2	2	0	f	2017-08-20 22:56:51.731872+00	2017-08-21 08:57:45.613489+00
105	Kamay ng Halimaw	29	3	1	f	2017-08-09 01:07:17.490034+00	2017-08-13 13:03:38.328882+00
151	Pagsisisi	20	2	3	f	2017-10-15 14:33:49.109833+00	2018-01-01 14:43:21.284843+00
119	Para Sa Kumitil ng Buhay Ko	29	2	1	f	2017-08-16 12:08:43.515408+00	2017-08-17 09:51:50.26954+00
167	Kaibahan	29	0	0	f	2018-02-13 04:55:20.369304+00	2018-02-13 04:55:20.369304+00
127	Ang Masama, Maganda at Mabuti	3	4	3	f	2017-08-21 03:44:14.416414+00	2017-08-21 08:58:26.989426+00
140	Sinasariwa ko ang ating pagmamahalan - Sulat ni adan kay eva	2	3	0	f	2017-08-26 14:19:02.415336+00	2017-09-02 08:02:48.359325+00
126	para kay mama	26	8	4	f	2017-08-21 00:24:19.584547+00	2017-08-25 15:58:31.336241+00
123	naguguluhan	19	2	0	f	2017-08-20 01:29:36.560155+00	2017-08-25 15:59:03.830997+00
139	Pasensya	29	3	0	f	2017-08-26 10:19:44.775643+00	2017-09-02 08:02:49.073137+00
135	Apektado	29	0	0	t	2017-08-25 15:57:29.786253+00	2017-08-25 15:59:52.528977+00
156	kalyo	26	2	0	f	2017-11-06 12:46:23.796736+00	2018-01-26 23:56:49.830235+00
121	Kung maging tayo	40	2	2	f	2017-08-17 08:50:32.634969+00	2017-08-20 11:05:33.395114+00
137	Akala Ko	29	2	0	f	2017-08-25 16:08:58.098607+00	2017-09-02 08:02:50.928779+00
134	Ang mga salitang may pero	1	1	1	f	2017-08-25 05:19:34.848039+00	2017-08-25 16:07:04.176999+00
122	buhos ng damdamin	38	2	1	f	2017-08-17 11:55:31.334458+00	2017-08-20 11:06:41.892986+00
116	Ang katotohanan	2	3	0	f	2017-08-15 02:39:31.519726+00	2017-08-21 12:12:02.365373+00
114	Pagkakamali	19	3	0	f	2017-08-14 06:28:42.510134+00	2017-08-21 12:12:54.83969+00
107	Likha	2	2	0	f	2017-08-09 22:30:02.571655+00	2017-08-21 12:15:09.436978+00
102	Maglatag	2	2	0	f	2017-08-07 00:59:19.811485+00	2017-08-21 12:16:12.747802+00
93	Pero	19	3	1	f	2017-08-04 13:57:21.661708+00	2017-08-21 12:17:27.11839+00
157	Kuyakoy	9	2	0	f	2017-11-08 14:06:12.084271+00	2017-11-09 11:01:48.684227+00
136	Apektado Pa Rin	29	2	0	f	2017-08-25 16:00:36.678528+00	2017-09-02 08:02:51.598721+00
138	Paano	19	3	3	f	2017-08-26 05:52:23.506441+00	2018-01-01 15:09:16.341669+00
132	Ako'y Sundalo at Ama	42	3	2	f	2017-08-22 20:33:11.312431+00	2017-08-25 19:39:14.681345+00
149	Ang isang estudyante na nagaaral ng kompyuter (IT)	2	1	0	f	2017-09-26 03:03:23.737098+00	2017-10-18 09:12:50.455712+00
154	para sa ikalawang babaeng inibig ko	38	1	0	f	2017-11-04 08:41:20.846013+00	2017-11-09 11:01:51.674012+00
160	Para sayo ang pagsuko (Ang Unang Bahagi)	47	1	2	f	2018-01-01 14:35:57.222948+00	2018-02-06 15:26:26.643103+00
147	Ikaw pa rin	42	3	1	f	2017-09-20 22:16:14.96762+00	2018-01-01 15:10:55.56557+00
153	Kung iisipin mo ang mga sandaling hindi mo na mababalikan	1	1	1	f	2017-11-03 06:15:29.364999+00	2018-02-06 15:29:07.571105+00
145	Tula 5 - Ang iniwan mong pahina sa akin	4	2	0	f	2017-09-02 08:02:39.779422+00	2017-10-18 09:12:52.373337+00
158	Tokhang	9	2	0	f	2017-11-11 09:07:44.982406+00	2017-11-13 01:50:33.748051+00
144	bihag	26	4	0	f	2017-08-27 09:02:12.877624+00	2017-10-18 09:12:53.05854+00
143	Luha	44	2	0	f	2017-08-27 05:27:17.180972+00	2017-10-18 09:12:53.720374+00
142	Kapit	44	2	0	f	2017-08-27 05:17:37.360643+00	2017-10-18 09:12:54.599163+00
168	Bulaklak	48	0	0	f	2018-02-13 14:38:24.536174+00	2018-02-13 14:38:24.536174+00
150	mga pagsukó 	34	4	0	f	2017-09-27 15:32:48.927564+00	2017-10-18 09:43:08.018249+00
148	parada ng itim	26	2	0	f	2017-09-21 13:55:56.239615+00	2017-10-18 09:43:10.941661+00
155	sa aking bituin blg. 1	38	1	0	t	2017-11-04 09:13:23.425115+00	2017-12-02 12:43:56.829231+00
141	Desisyon	44	4	2	f	2017-08-27 05:13:46.789507+00	2018-02-06 16:21:53.34415+00
159	Pasalubong	9	1	1	f	2017-11-29 08:35:22.938913+00	2018-01-13 01:30:46.545534+00
165	Para sayo ang pagsuko (Ang Ikalawa at Huling Bahagi)	47	0	1	f	2018-02-06 15:52:49.23581+00	2018-02-14 16:26:17.291354+00
161	Pasensya Ka Na	48	0	0	f	2018-01-16 09:31:18.460091+00	2018-01-16 09:31:18.460091+00
111	Binhi	19	7	4	f	2017-08-13 11:47:06.281985+00	2018-01-19 07:43:28.5174+00
162	Sumusuko Na Ko	29	0	0	f	2018-01-20 13:50:40.268056+00	2018-01-20 13:50:40.268056+00
163	Wala	48	0	1	f	2018-01-24 13:55:46.697484+00	2018-01-25 02:42:35.700167+00
166	Lingid Sa Kanya	47	0	0	f	2018-02-06 16:26:21.704633+00	2018-02-06 16:26:21.704633+00
\.


--
-- Name: topic_topic_id_seq; Type: SEQUENCE SET; Schema: posting; Owner: lihamph
--

SELECT pg_catalog.setval('topic_topic_id_seq', 168, true);


--
-- Data for Name: upvote; Type: TABLE DATA; Schema: posting; Owner: lihamph
--

COPY upvote (person_id, post_id, created_date) FROM stdin;
1	24	2017-07-15 17:21:05.715803+00
2	13	2017-07-15 17:23:49.161361+00
2	12	2017-07-15 17:25:18.708762+00
2	11	2017-07-15 17:25:19.872761+00
2	25	2017-07-15 17:25:32.829732+00
4	24	2017-07-15 17:39:34.296025+00
4	8	2017-07-16 04:12:43.310981+00
1	31	2017-07-16 14:05:54.853844+00
2	31	2017-07-17 00:04:13.832938+00
4	35	2017-07-17 13:44:22.874684+00
2	35	2017-07-18 00:08:52.99466+00
2	5	2017-07-18 00:10:29.319311+00
2	27	2017-07-18 00:11:28.183677+00
1	36	2017-07-18 06:03:54.068364+00
1	40	2017-07-19 09:29:43.68582+00
2	40	2017-07-19 12:49:35.939967+00
9	5	2017-07-19 14:12:07.351244+00
1	44	2017-07-20 07:05:07.26+00
1	41	2017-07-20 07:05:12.930492+00
1	38	2017-07-20 07:05:14.944311+00
1	35	2017-07-20 07:05:18.79871+00
20	5	2017-07-20 09:10:08.592136+00
1	5	2017-07-24 10:49:11.17641+00
23	23	2017-07-24 13:19:47.565525+00
4	46	2017-07-24 15:28:28.511636+00
4	47	2017-07-25 00:44:05.820943+00
1	47	2017-07-25 02:50:34.036806+00
20	40	2017-07-25 06:57:04.875395+00
7	47	2017-07-25 08:30:52.215668+00
1	46	2017-07-25 15:31:19.856858+00
1	52	2017-07-26 05:07:48.616123+00
1	50	2017-07-26 05:07:50.037295+00
2	47	2017-07-26 05:17:03.228327+00
2	46	2017-07-26 05:17:10.491632+00
2	52	2017-07-26 05:18:25.558075+00
19	56	2017-07-26 09:07:25.619161+00
19	52	2017-07-26 09:09:11.231684+00
26	56	2017-07-26 09:14:47.56643+00
26	54	2017-07-26 09:14:52.975817+00
2	61	2017-07-26 23:36:31.839718+00
2	59	2017-07-26 23:37:09.503671+00
2	56	2017-07-26 23:39:22.643245+00
26	57	2017-07-27 00:52:40.00465+00
26	59	2017-07-27 00:52:44.812006+00
26	61	2017-07-27 00:52:48.787604+00
3	61	2017-07-27 01:00:47.781906+00
26	5	2017-07-27 05:00:04.100313+00
20	63	2017-07-27 05:39:05.543735+00
1	61	2017-07-27 06:39:58.630584+00
1	63	2017-07-27 06:40:40.412662+00
1	58	2017-07-27 06:40:53.146609+00
3	56	2017-07-27 06:47:18.88244+00
1	8	2017-07-27 06:49:00.955647+00
3	70	2017-07-27 06:53:45.741353+00
3	59	2017-07-27 06:57:46.357487+00
26	79	2017-07-27 12:04:05.027871+00
19	70	2017-07-27 12:12:57.244235+00
19	69	2017-07-27 12:22:13.632739+00
1	79	2017-07-27 14:25:10.681482+00
1	87	2017-07-27 14:25:11.151903+00
1	70	2017-07-27 14:25:11.432856+00
2	79	2017-07-28 00:28:27.06934+00
1	89	2017-07-28 02:18:28.662088+00
19	89	2017-07-28 04:06:16.372577+00
26	87	2017-07-28 05:52:23.355356+00
26	89	2017-07-28 05:52:24.392592+00
1	97	2017-07-28 05:58:09.070586+00
1	96	2017-07-28 05:58:09.505311+00
1	94	2017-07-28 05:58:09.822842+00
19	97	2017-07-28 06:02:28.901226+00
1	101	2017-07-28 07:08:19.129974+00
1	69	2017-07-28 07:08:21.461979+00
26	96	2017-07-28 07:13:17.408096+00
26	97	2017-07-28 07:13:21.168921+00
26	69	2017-07-28 08:21:12.405226+00
26	70	2017-07-28 08:21:18.424353+00
19	106	2017-07-28 12:37:45.981224+00
19	107	2017-07-28 12:39:01.914816+00
19	108	2017-07-28 12:39:57.096432+00
19	109	2017-07-28 12:40:47.853594+00
19	114	2017-07-28 13:07:38.549033+00
26	108	2017-07-28 13:19:41.957305+00
26	109	2017-07-28 13:19:41.971066+00
26	107	2017-07-28 13:19:43.860345+00
26	106	2017-07-28 13:19:54.079591+00
1	115	2017-07-28 14:00:57.664904+00
19	5	2017-07-28 19:44:26.964082+00
26	40	2017-07-29 02:34:30.685057+00
9	106	2017-07-29 05:44:13.245149+00
9	97	2017-07-29 05:45:10.27678+00
2	109	2017-07-29 07:46:35.838427+00
2	107	2017-07-29 07:46:37.799592+00
2	97	2017-07-29 07:47:54.355019+00
2	101	2017-07-29 07:59:22.338904+00
19	119	2017-07-29 13:28:11.161128+00
1	119	2017-07-29 14:08:51.154993+00
1	18	2017-07-30 06:25:34.196629+00
26	129	2017-07-30 11:38:20.240539+00
26	127	2017-07-30 11:38:41.895195+00
26	126	2017-07-30 11:39:05.185256+00
26	125	2017-07-30 11:39:17.9983+00
26	119	2017-07-30 11:39:38.730272+00
26	121	2017-07-30 11:41:18.544033+00
26	115	2017-07-30 11:41:58.094309+00
1	129	2017-07-30 12:35:51.542148+00
26	133	2017-07-30 13:20:05.089703+00
1	135	2017-07-31 07:48:43.571448+00
1	126	2017-07-31 10:01:35.322678+00
26	135	2017-07-31 10:26:14.037778+00
19	135	2017-07-31 11:06:00.903615+00
19	133	2017-07-31 11:06:02.750749+00
26	136	2017-07-31 12:24:50.412948+00
26	137	2017-07-31 13:04:41.511954+00
26	138	2017-07-31 13:20:45.512347+00
32	52	2017-07-31 14:31:37.97547+00
1	139	2017-07-31 14:39:56.369488+00
1	138	2017-07-31 14:40:03.880072+00
1	125	2017-07-31 14:40:07.368899+00
19	139	2017-07-31 22:26:27.198144+00
1	144	2017-08-01 00:56:25.399437+00
1	143	2017-08-01 00:56:25.610547+00
26	139	2017-08-01 10:14:38.333649+00
26	145	2017-08-01 10:15:04.713652+00
26	144	2017-08-01 10:44:10.309272+00
26	143	2017-08-01 10:44:11.984402+00
2	139	2017-08-01 13:54:11.586052+00
2	135	2017-08-01 13:54:14.807139+00
2	138	2017-08-01 13:54:51.744407+00
2	144	2017-08-01 13:55:28.897837+00
2	145	2017-08-01 13:56:09.394266+00
35	150	2017-08-01 15:51:56.580995+00
19	150	2017-08-02 04:14:03.187679+00
2	150	2017-08-02 06:08:19.495243+00
26	150	2017-08-02 08:35:41.023179+00
26	149	2017-08-02 08:35:54.185328+00
7	135	2017-08-02 11:38:59.737533+00
3	150	2017-08-02 14:08:16.982465+00
19	159	2017-08-03 10:48:37.708599+00
34	143	2017-08-03 11:00:08.848105+00
26	162	2017-08-03 11:05:52.956883+00
26	161	2017-08-03 11:05:53.882176+00
26	164	2017-08-03 11:53:09.753182+00
26	159	2017-08-03 11:53:11.348404+00
26	163	2017-08-03 11:53:16.257649+00
19	164	2017-08-03 12:36:49.697761+00
19	163	2017-08-03 12:36:52.693414+00
19	162	2017-08-03 12:36:55.675454+00
19	161	2017-08-03 12:36:57.187507+00
20	150	2017-08-03 13:28:33.379631+00
20	145	2017-08-03 13:29:30.564777+00
20	144	2017-08-03 13:30:22.390384+00
20	149	2017-08-03 13:34:22.105801+00
1	167	2017-08-03 13:55:28.698652+00
1	165	2017-08-03 13:55:29.591932+00
1	164	2017-08-03 13:55:30.638495+00
1	162	2017-08-03 13:55:33.202613+00
1	150	2017-08-03 13:55:36.350295+00
1	159	2017-08-03 13:55:40.708493+00
2	164	2017-08-03 13:57:42.978892+00
2	163	2017-08-03 13:57:44.582626+00
3	167	2017-08-03 14:08:33.256173+00
20	126	2017-08-03 14:25:24.65204+00
34	170	2017-08-04 00:59:03.998339+00
20	170	2017-08-04 01:27:20.08979+00
2	170	2017-08-04 01:38:59.198451+00
1	7	2017-08-04 02:38:33.96425+00
1	23	2017-08-04 02:38:35.143065+00
29	79	2017-08-04 03:59:25.613379+00
29	87	2017-08-04 03:59:27.695592+00
29	58	2017-08-04 04:00:01.834111+00
29	54	2017-08-04 06:07:42.46345+00
29	96	2017-08-04 06:07:46.088693+00
29	94	2017-08-04 06:07:46.90106+00
29	127	2017-08-04 06:07:49.950893+00
29	101	2017-08-04 06:07:50.246702+00
29	129	2017-08-04 06:07:51.136421+00
29	165	2017-08-04 06:07:52.914504+00
19	175	2017-08-04 08:51:03.591565+00
19	170	2017-08-04 08:51:12.317497+00
26	175	2017-08-04 10:24:28.20221+00
26	170	2017-08-04 10:24:35.670427+00
19	177	2017-08-04 12:50:10.173664+00
34	180	2017-08-04 13:52:52.119728+00
26	181	2017-08-04 14:18:18.546737+00
26	180	2017-08-04 14:18:26.351157+00
26	179	2017-08-04 23:21:59.327388+00
35	187	2017-08-05 01:51:26.916835+00
26	187	2017-08-05 05:42:36.695812+00
1	183	2017-08-05 07:00:32.298596+00
1	184	2017-08-05 07:00:32.580601+00
1	187	2017-08-05 07:00:33.808725+00
1	186	2017-08-05 07:00:34.2176+00
1	185	2017-08-05 07:00:35.104662+00
1	182	2017-08-05 07:00:36.365454+00
1	181	2017-08-05 07:00:37.036466+00
1	180	2017-08-05 07:00:37.64196+00
1	179	2017-08-05 07:00:38.721045+00
20	180	2017-08-05 15:10:02.737751+00
33	170	2017-08-05 18:15:16.344362+00
29	170	2017-08-06 11:11:00.664349+00
2	180	2017-08-07 00:41:44.757478+00
2	187	2017-08-07 00:43:47.465989+00
2	190	2017-08-07 00:43:58.973253+00
2	191	2017-08-07 00:45:05.530762+00
2	199	2017-08-07 22:29:44.860716+00
20	182	2017-08-08 03:27:06.470777+00
26	199	2017-08-08 10:39:37.861922+00
19	199	2017-08-08 12:25:02.244521+00
34	200	2017-08-08 12:54:22.028334+00
26	200	2017-08-08 13:09:38.475573+00
34	199	2017-08-08 15:37:30.139556+00
1	201	2017-08-09 05:22:16.312981+00
1	200	2017-08-09 05:40:44.883673+00
1	199	2017-08-09 05:40:45.574116+00
1	198	2017-08-09 05:40:46.130303+00
1	191	2017-08-09 05:40:48.697945+00
1	190	2017-08-09 05:40:49.378193+00
1	202	2017-08-09 09:21:18.687453+00
26	201	2017-08-09 10:07:58.734897+00
26	202	2017-08-09 11:23:05.787293+00
2	200	2017-08-09 22:18:46.777591+00
2	202	2017-08-09 22:20:25.667377+00
1	204	2017-08-10 01:55:31.924793+00
38	199	2017-08-10 10:02:41.674165+00
2	205	2017-08-11 06:11:50.689246+00
29	199	2017-08-11 09:16:55.082281+00
29	179	2017-08-11 09:17:30.618136+00
29	164	2017-08-11 09:17:31.774299+00
29	163	2017-08-11 09:17:34.13549+00
29	162	2017-08-11 09:17:35.776605+00
29	161	2017-08-11 09:17:37.81009+00
29	145	2017-08-11 09:17:40.277254+00
29	138	2017-08-11 09:17:42.162162+00
29	136	2017-08-11 09:17:44.622224+00
29	133	2017-08-11 09:17:45.721171+00
29	181	2017-08-11 09:21:11.159803+00
26	205	2017-08-12 12:25:49.471856+00
4	210	2017-08-13 13:03:29.782326+00
4	209	2017-08-13 13:03:35.170491+00
4	208	2017-08-13 13:03:35.600037+00
4	205	2017-08-13 13:03:37.229466+00
4	201	2017-08-13 13:03:38.328882+00
4	202	2017-08-13 13:03:39.669667+00
1	210	2017-08-13 13:03:52.203867+00
1	209	2017-08-13 13:06:38.328973+00
1	208	2017-08-13 13:06:38.970696+00
1	205	2017-08-13 13:06:39.679271+00
19	210	2017-08-13 13:11:59.964313+00
26	209	2017-08-13 13:19:01.685202+00
29	215	2017-08-13 23:37:02.682609+00
29	209	2017-08-13 23:39:48.250591+00
29	208	2017-08-13 23:40:00.515589+00
1	217	2017-08-14 11:42:25.493144+00
1	216	2017-08-14 11:42:30.456348+00
1	215	2017-08-14 11:42:31.018741+00
19	217	2017-08-14 12:35:00.565925+00
2	209	2017-08-15 02:40:55.281053+00
1	218	2017-08-15 02:43:06.116574+00
29	216	2017-08-15 05:41:04.146995+00
29	200	2017-08-15 05:49:35.705304+00
26	220	2017-08-16 02:00:38.855396+00
2	220	2017-08-16 09:48:41.7161+00
7	44	2017-08-16 15:28:26.388303+00
2	222	2017-08-16 23:43:43.690082+00
29	159	2017-08-16 23:47:19.675266+00
29	144	2017-08-16 23:50:20.348186+00
29	139	2017-08-16 23:50:53.770675+00
29	108	2017-08-16 23:53:57.099731+00
29	107	2017-08-16 23:54:31.532022+00
29	106	2017-08-16 23:54:40.524375+00
1	225	2017-08-17 09:51:43.316331+00
1	224	2017-08-17 09:51:43.932125+00
1	220	2017-08-17 09:51:46.018482+00
1	222	2017-08-17 09:51:50.26954+00
1	221	2017-08-17 09:51:52.992044+00
1	227	2017-08-18 03:05:15.605725+00
38	220	2017-08-18 09:28:50.778721+00
26	218	2017-08-19 00:50:41.26202+00
1	228	2017-08-20 05:17:36.927049+00
26	63	2017-08-20 08:07:53.391225+00
19	229	2017-08-20 09:23:16.568906+00
2	225	2017-08-20 11:05:04.424292+00
2	227	2017-08-20 11:06:41.892986+00
26	229	2017-08-20 12:33:15.182942+00
26	233	2017-08-21 00:41:45.370016+00
19	234	2017-08-21 03:11:17.822144+00
3	234	2017-08-21 03:12:30.040958+00
3	220	2017-08-21 03:13:52.26494+00
34	237	2017-08-21 03:54:43.244242+00
34	220	2017-08-21 03:59:32.996981+00
26	236	2017-08-21 04:36:29.07046+00
26	234	2017-08-21 04:36:31.453826+00
20	234	2017-08-21 04:38:29.077893+00
2	234	2017-08-21 04:40:38.83051+00
2	236	2017-08-21 04:42:19.116823+00
20	236	2017-08-21 04:42:47.893809+00
2	237	2017-08-21 04:42:52.444686+00
2	221	2017-08-21 04:45:24.758753+00
20	217	2017-08-21 04:52:35.809221+00
34	243	2017-08-21 05:31:56.813496+00
1	229	2017-08-21 08:57:45.107886+00
1	233	2017-08-21 08:57:45.613489+00
1	237	2017-08-21 08:58:25.47139+00
1	243	2017-08-21 08:58:25.825831+00
1	236	2017-08-21 08:58:26.989426+00
1	234	2017-08-21 08:58:27.446147+00
3	243	2017-08-21 10:16:44.255629+00
34	234	2017-08-21 10:41:59.90692+00
3	218	2017-08-21 12:12:02.365373+00
3	216	2017-08-21 12:12:54.83969+00
3	209	2017-08-21 12:14:14.982195+00
3	204	2017-08-21 12:15:09.436978+00
3	198	2017-08-21 12:16:12.747802+00
3	175	2017-08-21 12:19:11.374003+00
1	248	2017-08-21 13:13:43.640863+00
26	248	2017-08-21 13:22:02.166325+00
26	237	2017-08-21 13:22:54.008731+00
26	243	2017-08-21 13:23:46.228434+00
2	243	2017-08-21 23:13:44.851636+00
1	254	2017-08-22 07:55:39.176283+00
1	258	2017-08-23 10:17:49.913061+00
26	258	2017-08-23 11:39:47.714603+00
2	248	2017-08-23 22:44:08.485766+00
2	258	2017-08-23 22:44:16.886316+00
2	254	2017-08-23 22:45:35.296326+00
1	261	2017-08-24 06:54:52.589551+00
26	261	2017-08-24 10:34:57.413025+00
1	263	2017-08-25 05:22:00.082419+00
29	234	2017-08-25 15:58:31.336241+00
29	228	2017-08-25 15:59:03.830997+00
1	265	2017-08-25 17:32:49.504879+00
1	267	2017-08-25 17:32:50.28525+00
29	269	2017-08-26 10:15:23.886891+00
19	271	2017-08-26 12:09:08.356943+00
1	269	2017-08-27 01:46:54.886541+00
1	271	2017-08-27 01:46:55.72546+00
1	272	2017-08-27 01:46:57.04757+00
29	272	2017-08-27 02:48:24.406722+00
26	277	2017-08-27 10:03:37.150645+00
19	274	2017-08-27 10:27:24.299781+00
19	277	2017-08-27 10:27:33.773442+00
4	277	2017-09-02 08:02:45.230472+00
4	278	2017-09-02 08:02:45.735591+00
4	276	2017-09-02 08:02:46.545599+00
4	275	2017-09-02 08:02:46.890865+00
4	274	2017-09-02 08:02:47.626936+00
4	272	2017-09-02 08:02:48.359325+00
4	271	2017-09-02 08:02:49.073137+00
4	269	2017-09-02 08:02:49.740478+00
4	267	2017-09-02 08:02:50.928779+00
4	265	2017-09-02 08:02:51.598721+00
29	274	2017-09-09 15:02:08.10099+00
34	280	2017-09-20 16:19:20.052066+00
20	281	2017-09-21 01:42:55.067748+00
26	280	2017-09-21 13:49:43.535853+00
29	280	2017-09-22 00:52:10.906321+00
2	281	2017-09-26 03:03:54.203527+00
34	284	2017-09-27 15:36:01.271467+00
26	282	2017-09-30 10:33:00.946602+00
26	284	2017-09-30 10:33:02.466026+00
1	285	2017-10-18 09:12:49.665999+00
1	284	2017-10-18 09:12:50.106582+00
1	283	2017-10-18 09:12:50.455712+00
1	282	2017-10-18 09:12:50.911615+00
1	281	2017-10-18 09:12:51.350425+00
1	280	2017-10-18 09:12:51.734936+00
1	278	2017-10-18 09:12:52.373337+00
1	277	2017-10-18 09:12:53.05854+00
1	276	2017-10-18 09:12:53.720374+00
1	275	2017-10-18 09:12:54.599163+00
1	274	2017-10-18 09:12:59.032939+00
2	285	2017-10-18 09:43:07.388273+00
2	284	2017-10-18 09:43:08.018249+00
1	289	2017-11-03 06:16:00.00817+00
1	288	2017-11-03 06:16:00.424105+00
45	1	2017-11-05 14:27:41.332474+00
20	293	2017-11-09 03:02:12.759384+00
1	292	2017-11-09 11:01:47.574713+00
1	293	2017-11-09 11:01:48.684227+00
1	291	2017-11-09 11:01:49.714806+00
1	290	2017-11-09 11:01:51.674012+00
1	294	2017-11-11 10:49:19.101074+00
26	294	2017-11-13 01:50:33.748051+00
1	296	2018-01-13 01:30:45.806025+00
1	295	2018-01-13 01:30:46.545534+00
9	209	2018-01-19 07:43:28.5174+00
26	292	2018-01-26 23:56:49.830235+00
\.


SET search_path = core, pg_catalog;

--
-- Name: person person_person_id_pkey; Type: CONSTRAINT; Schema: core; Owner: lihamph
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_person_id_pkey PRIMARY KEY (person_id);


--
-- Name: person person_username_key; Type: CONSTRAINT; Schema: core; Owner: lihamph
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_username_key UNIQUE (username);


SET search_path = posting, pg_catalog;

--
-- Name: post post_post_id_pkey; Type: CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_post_id_pkey PRIMARY KEY (post_id);


--
-- Name: topic topic_topic_id_pkey; Type: CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_topic_id_pkey PRIMARY KEY (topic_id);


--
-- Name: upvote upvote_person_id_post_id_pkey; Type: CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY upvote
    ADD CONSTRAINT upvote_person_id_post_id_pkey PRIMARY KEY (person_id, post_id);


--
-- Name: post post_author_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_author_id_fkey FOREIGN KEY (author_id) REFERENCES core.person(person_id);


--
-- Name: post post_topic_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES topic(topic_id);


--
-- Name: topic topic_author_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_author_id_fkey FOREIGN KEY (author_id) REFERENCES core.person(person_id);


--
-- Name: post topic_parent_post_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY post
    ADD CONSTRAINT topic_parent_post_id_fkey FOREIGN KEY (parent_post_id) REFERENCES post(post_id);


--
-- Name: upvote upvote_person_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY upvote
    ADD CONSTRAINT upvote_person_id_fkey FOREIGN KEY (person_id) REFERENCES core.person(person_id);


--
-- Name: upvote upvote_post_id_fkey; Type: FK CONSTRAINT; Schema: posting; Owner: lihamph
--

ALTER TABLE ONLY upvote
    ADD CONSTRAINT upvote_post_id_fkey FOREIGN KEY (post_id) REFERENCES post(post_id);


--
-- PostgreSQL database dump complete
--

