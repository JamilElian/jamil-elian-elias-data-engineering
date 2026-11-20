-- ============================================================================
-- Lab: Complex Data Types in Hive (MAP, ARRAY, STRUCT & LATERAL VIEW EXPLODE)
-- Tool: Cloudera Hue (Hive Editor)
-- User: training
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SETUP: Database Creation
-- ----------------------------------------------------------------------------
DROP DATABASE IF EXISTS training_analyst CASCADE;
CREATE DATABASE training_analyst;
USE training_analyst;


-- ----------------------------------------------------------------------------
-- PART 1: Creating, Loading & Querying Complex Types (MAP, ARRAY, STRUCT)
-- ----------------------------------------------------------------------------

-- 1 - Create a text file-based external table with complex data types
DROP TABLE IF EXISTS loyalty_program;

CREATE EXTERNAL TABLE loyalty_program (
    cust_id INT,
    fname STRING,
    lname STRING,
    email STRING,
    level STRING,
    phone MAP<STRING, STRING>,
    order_ids ARRAY<INT>,
    order_value STRUCT<
        min: INT,
        max: INT,
        avg: INT,
        total: INT
    >
)
ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '|'
    COLLECTION ITEMS TERMINATED BY ','
    MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE
LOCATION '/tmp/training/dualcore/loyalty_program/'
TBLPROPERTIES ('external.table.purge'='true');

-- 2 - Inspect sample data (Run in cluster terminal: head /var/tmp/dev/data/da/loyalty_data.txt)

-- 3 - Load the data into the loyalty_program table
LOAD DATA INPATH '/tmp/training/raw/loyalty_data.txt'
OVERWRITE INTO TABLE loyalty_program;

-- 4 - Select the HOME phone number (MAP lookup) for customer ID 1200866
SELECT phone['HOME'] AS home
FROM loyalty_program
WHERE cust_id = 1200866;

-- 5 - Select the third element from order_ids (ARRAY 0-based index) for customer ID 1200866
SELECT order_ids[2] AS third
FROM loyalty_program
WHERE cust_id = 1200866;

-- 6 - Select the total attribute from order_value (STRUCT dot notation) for customer ID 1200866
SELECT order_value.total
FROM loyalty_program
WHERE cust_id = 1200866;


-- ----------------------------------------------------------------------------
-- PART 2: Bonus Exercise 1 - Hive Table-Generating Functions (EXPLODE)
-- ----------------------------------------------------------------------------

-- 7 - Return the order IDs for customer ID 1200866, one per row
SELECT EXPLODE(order_ids) AS order_id
FROM loyalty_program
WHERE cust_id = 1200866;

-- 8 - Return cust_id and order_id (one per row) for customers with average order > $900 (90,000 cents)
SELECT cust_id, order_id
FROM loyalty_program
LATERAL VIEW EXPLODE(order_ids) o AS order_id
WHERE order_value.avg > 90000;


-- ----------------------------------------------------------------------------
-- OPTIONAL: Create a Parquet version of loyalty_program for Impala queries
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS loyalty_program_parquet;

CREATE TABLE loyalty_program_parquet
STORED AS PARQUET AS
SELECT * FROM loyalty_program;