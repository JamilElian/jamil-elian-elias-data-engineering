-- ============================================================================
-- Lab: Hive Transactions (Hive ACID)
-- Tool: Cloudera Hue (Hive Editor)
--       Full ACID operations (UPDATE/DELETE/COMPACT) require Hive ACID enabled.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SETUP: Database Creation
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS training_dev;
USE training_dev;


-- ----------------------------------------------------------------------------
-- PART 1: Insert-Only Transactional Table (dc_comics_acid_insert)
-- ----------------------------------------------------------------------------

-- 1 - Drop table dc_comics_acid_insert if it exists
DROP TABLE IF EXISTS dc_comics_acid_insert;

-- 2 - Create and describe the table
CREATE TABLE dc_comics_acid_insert (
    page_id STRING,
    name STRING,
    urlslug STRING,
    ID STRING,
    ALIGN STRING,
    EYE STRING,
    HAIR STRING,
    SEX STRING,
    GSM STRING,
    ALIVE STRING,
    APPEARANCES INT,
    FIRST_APPEARANCES STRING,
    YEAR STRING
)
STORED AS ORC
TBLPROPERTIES ('transactional'='true', 'transactional_properties'='insert_only');

DESCRIBE dc_comics_acid_insert;

-- 3 - Insert the 3 rows into table dc_comics_acid_insert using 3 insert statements
INSERT INTO dc_comics_acid_insert VALUES (1422, "Batman (Bruce Wayne)", "\/wiki\/Batman_(Bruce_Wayne)", "Secret Identity", "Good Characters", "Blue Eyes", "Black Hair", "Male Characters", "", "Living Characters", 3093, "1939, May", 1939);
INSERT INTO dc_comics_acid_insert VALUES (23387, "Superman (Clark Kent)", "\/wiki\/Superman_(Clark_Kent)", "Secret Identity", "Good Characters", "Blue Eyes", "Black Hair", "Male Characters", "", "Living Characters", 2496, "1986, October", 1986);
INSERT INTO dc_comics_acid_insert VALUES (1458, "Green Lantern (Hal Jordan)", "\/wiki\/Green_Lantern_(Hal_Jordan)", "Secret Identity", "Good Characters", "Brown Eyes", "Brown Hair", "Male Characters", "", "Living Characters", 1565, "1959, October", 1959);

-- 4 - Query the dc_comics_acid_insert to verify data was inserted
SELECT * FROM dc_comics_acid_insert;


-- ----------------------------------------------------------------------------
-- PART 2: Full ACID Transactional Table (dc_comics_acid)
-- ----------------------------------------------------------------------------

-- 5 - Drop the dc_comics_acid table and create the table
DROP TABLE IF EXISTS dc_comics_acid;

CREATE TABLE dc_comics_acid (
    page_id STRING,
    name STRING,
    urlslug STRING,
    ID STRING,
    ALIGN STRING,
    EYE STRING,
    HAIR STRING,
    SEX STRING,
    GSM STRING,
    ALIVE STRING,
    APPEARANCES INT,
    FIRST_APPEARANCES STRING,
    YEAR STRING
)
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

-- 6 - Do a multi-value insert into table
INSERT INTO dc_comics_acid VALUES
    (1422, "Batman (Bruce Wayne)", "\/wiki\/Batman_(Bruce_Wayne)", "Secret Identity", "Good Characters", "Blue Eyes", "Black Hair", "Male Characters", "", "Living Characters", 3093, "1939, May", 1939),
    (1458, "Green Lantern (Hal Jordan)", "\/wiki\/Green_Lantern_(Hal_Jordan)", "Secret Identity", "Good Characters", "Brown Eyes", "Brown Hair", "Male Characters", "", "Living Characters", 1565, "1959, October", 1959),
    (23387, "Superman (Clark Kent)", "\/wiki\/Superman_(Clark_Kent)", "Secret Identity", "Good Characters", "Blue Eyes", "Black Hair", "Male Characters", "", "Living Characters", 2496, "1986, October", 1986);

-- Check active/recent transactions (optional diagnostic)
SHOW TRANSACTIONS;

-- 7 - Query the dc_comics_acid table
SELECT * FROM dc_comics_acid;

-- 8 - Run DELETE, UPDATE, and SELECT statements on the ACID table
DELETE FROM dc_comics_acid WHERE page_id = 23387;
UPDATE dc_comics_acid SET name = "Robin (Dick Grayson)" WHERE page_id = 1422;
SELECT * FROM dc_comics_acid;

-- Check transactions after DML modifications
SHOW TRANSACTIONS;


-- ----------------------------------------------------------------------------
-- PART 3: Delta File Compaction
-- ----------------------------------------------------------------------------

-- 9 - Complete a minor compaction on the table
ALTER TABLE dc_comics_acid COMPACT 'minor'
    WITH OVERWRITE TBLPROPERTIES ("compactor.mapreduce.map.memory.mb"="3072");

-- 10 - Show compactions
SHOW COMPACTIONS;