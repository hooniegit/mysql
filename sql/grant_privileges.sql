/*
grant options
    - SELECT
    - INSERT
    - UPDATE
    - DELETE
    - CREATE
    - DROP
    - ALTER
    - GRANT OPTION
    - CREATE TEMPORARY TABLES
    - SHOW DATABASES
    - LOCK TABLES:
    - REFERENCES
    - CREATE ROUTINE
    - ALTER ROUTINE
    - EXECUTE
    - FILE
    - PROCESS
    - SUPER
*/

-- base structure
GRANT <privileges, .. > ON <database>.<tablename> TO '<username>'@'<host>';
FLUSH PRIVILEGES;

-- example
GRANT ALL PRIVILEGES ON *.* TO 'spotify'@'%';
FLUSH PRIVILEGES;

-- example
GRANT SELECT ON stream.measurement TO 'kafka'@'11.22.33.44';
FLUSH PRIVILEGES;
