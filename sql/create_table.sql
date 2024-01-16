-- create table
-- base structure
CREATE TABLE <tablename> VALUES (
    <column_name> <data_type> <null_option(skip)> <increment_option(skip)> <primary_option(skip)>,
    <column_name> <data_type> <null_option(skip)> <increment_option(skip)>,
    ..
    FOREIGN KEY (<column_name>) REFERENCES <database>.<tablename>(column_name), -- if foreign key exists
    ..
);

-- example
CREATE TABLE demo_table VALUES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    value VARCHAR(20) NOT NULL
);

-- example
CREATE TABLE sample_table VALUES (
    id INT AUTO_INCREMENT PRIMARY KEY,
    demo_id INT NOT NULL,
    value VARCHAR(20) NOT NULL,
    FOREIGN KEY (demo_id) REFERENCES demo_table(id)
);

-- create view table
-- base structure
CREATE VIEW <database>.<tablename> AS
SELECT ..

-- example
CREATE VIEW views.grade AS
SELECT *
FROM information.grade;

-- example
CREATE VIEW views.location_4_params AS
SELECT
    s.sensor_id,
    s.sensor_name,
    s.unit,
    g.grade,
    g.bottom_value,
    g.top_value,
    g.alert_id
FROM
    information.sensor s
JOIN
    information.grade g ON s.sensor_id = g.sensor_id
WHERE
    s.location_id = 4;
    