DROP SCHEMA IF EXISTS core CASCADE;
DROP SCHEMA IF EXISTS audit CASCADE;
DROP SCHEMA IF EXISTS posting CASCADE;

CREATE SCHEMA core;
CREATE SCHEMA audit;
CREATE SCHEMA posting;
SET search_path = core;

SELECT 'Schema initialized' AS result;
