-- ============================================================================
-- Lab: Introduction to Hive SQL (External vs. Managed Tables)
-- Tool: Cloudera Hue (Hive / Spark SQL Editor)
-- Note: Replace '${USER}' with your actual Hadoop username before running.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SETUP: Database Creation
-- ----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ${USER}_marvel;
USE ${USER}_marvel;


-- ----------------------------------------------------------------------------
-- PART 1: External Table (marvel_comics_raw)
-- ----------------------------------------------------------------------------

-- 1 - Display the Hive tables
SHOW TABLES;

-- 2 - Drop table marvel_comics_raw if it exists
DROP TABLE IF EXISTS marvel_comics_raw;

-- 3 - Create a marvel_comics_raw external table
CREATE EXTERNAL TABLE marvel_comics_raw (
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
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/tmp/${USER}/data/';

-- 4 - Display the Hive tables again
SHOW TABLES;

-- 5 - Describe the marvel_comics_raw table to confirm the data types
DESCRIBE marvel_comics_raw;

-- 6 - Load the marvel_comics data into our marvel_comics_raw table
-- Note: LOAD DATA moves the file from /raw/ into the external table directory /data/
LOAD DATA INPATH '/tmp/${USER}/raw/marvel-wikia-data.csv'
OVERWRITE INTO TABLE marvel_comics_raw;

-- 7 - Confirm successful load
SELECT * FROM marvel_comics_raw LIMIT 20;

-- 8 - Confirm that the data has been moved to its location in HDFS
-- (Run in terminal / Hue File Browser):
-- hdfs dfs -ls /tmp/${USER}/data/


-- ----------------------------------------------------------------------------
-- PART 2: Managed Table Stored as ORC (marvel_comics)
-- ----------------------------------------------------------------------------

-- 9 - Drop table marvel_comics if it exists
DROP TABLE IF EXISTS marvel_comics;

-- 10 - Create a marvel_comics managed table stored as ORC
CREATE TABLE marvel_comics (
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
STORED AS ORC;

-- 11 - Insert the data from the external table into the managed ORC table
INSERT INTO TABLE marvel_comics
SELECT * FROM marvel_comics_raw;

-- 12 - Confirm successful load
SELECT * FROM marvel_comics LIMIT 20;

-- 13 - Check the location of the files in HDFS
SHOW CREATE TABLE marvel_comics;


-- ----------------------------------------------------------------------------
-- PART 3: Cleanup & Lifecycle Comparison (External vs. Managed)
-- ----------------------------------------------------------------------------

-- 14 - Drop the raw (external) table
DROP TABLE marvel_comics_raw;

-- 15 - Check that the table has been deleted from metastore
SHOW TABLES;

-- 16 - Check that the raw data is still in HDFS (external table preserves data)
-- (Run in terminal / Hue File Browser):
-- hdfs dfs -ls /tmp/${USER}/data/

-- 17 - Drop the managed table
DROP TABLE marvel_comics;

-- 18 - Check that the marvel_comics table is no longer in metastore
SHOW TABLES;

-- 19 - Check that the underlying files are gone too from HDFS/S3 (managed table deletes data)
-- (Run in terminal / Hue File Browser):
-- hdfs dfs -ls -R <WAREHOUSE_BASE>/warehouse/tablespace/managed/hive/${USER}_marvel.db/marvel_comics