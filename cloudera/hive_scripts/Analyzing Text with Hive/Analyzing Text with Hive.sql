-- ============================================================================
-- Lab: Analyzing Text with Hive (RegexSerDe, Regexp, N-grams & Text Mining)
-- Tool: Cloudera Hue (Hive Editor)
-- User: training
-- ============================================================================

-- ----------------------------------------------------------------------------
-- SETUP: Database & Base External Tables Creation
-- ----------------------------------------------------------------------------
DROP DATABASE IF EXISTS training_analyst CASCADE;
CREATE DATABASE training_analyst;
USE training_analyst;

-- 1. Create and populate the ratings table
DROP TABLE IF EXISTS ratings;

CREATE EXTERNAL TABLE ratings (
    posted TIMESTAMP,
    cust_id INT,
    prod_id INT,
    rating TINYINT,
    message STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/dualcore/ratings/'
TBLPROPERTIES ('external.table.purge'='true');

LOAD DATA INPATH '/tmp/training/raw/ratings_2018.txt' OVERWRITE INTO TABLE ratings;
LOAD DATA INPATH '/tmp/training/raw/ratings_2019.txt' INTO TABLE ratings;

-- 2. Create and populate the products table
DROP TABLE IF EXISTS products;

CREATE EXTERNAL TABLE products (
    prod_id INT,
    brand STRING,
    name STRING,
    price INT,
    cost INT,
    shipping_wt TINYINT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/dualcore/products/'
TBLPROPERTIES ('external.table.purge'='true');

LOAD DATA INPATH '/tmp/training/raw/products.txt' OVERWRITE INTO TABLE products;


-- ----------------------------------------------------------------------------
-- PART 1: Creating and Populating the Web Logs Table (RegexSerDe)
-- ----------------------------------------------------------------------------

-- 1 - Create the web_logs table
DROP TABLE IF EXISTS web_logs;

CREATE EXTERNAL TABLE web_logs (
    ip_address STRING,
    date_string STRING,
    request STRING,
    status STRING,
    bytes STRING,
    referer STRING,
    user_agent STRING,
    cookie STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = "^([\\d.]+) \\S+ \\S+ \\[(.+?)\\] \"(.+?)\" (\\d{3}) (\\d+) \"(.+?)\" \"(.+?)\" \"SESSIONID=(\\d+)\"\\s*"
)
LOCATION '/tmp/training/dualcore/weblogs/'
TBLPROPERTIES ('external.table.purge'='true');

-- 2 - Populate the table by loading the access.log file
LOAD DATA INPATH '/tmp/training/raw/access.log' OVERWRITE INTO TABLE web_logs;

-- 3 - Verify that the data is loaded correctly (Top 3 searched terms)
SELECT term, COUNT(term) AS num
FROM (
    SELECT LOWER(REGEXP_EXTRACT(request, '/search\\?phrase=(\\S+)', 1)) AS term
    FROM web_logs
    WHERE request REGEXP '/search\\?phrase='
) term
GROUP BY term
ORDER BY num DESC
LIMIT 3;


-- ----------------------------------------------------------------------------
-- PART 2: Bonus Exercise 1 - Analyzing Numeric Product Ratings
-- ----------------------------------------------------------------------------

-- 4 - Review the ratings table structure
DESCRIBE ratings;

-- 5 - Find the product that customers like most (at least 50 ratings)
SELECT prod_id, FORMAT_NUMBER(avg_rating, 2) AS avg_rating
FROM (
    SELECT
        prod_id,
        AVG(rating) AS avg_rating,
        COUNT(*) AS num
    FROM ratings
    GROUP BY prod_id
) rated
WHERE num >= 50
ORDER BY avg_rating DESC
LIMIT 1;

-- 6 - Find the product with the lowest average among products with at least 50 ratings
SELECT prod_id, FORMAT_NUMBER(avg_rating, 2) AS avg_rating
FROM (
    SELECT
        prod_id,
        AVG(rating) AS avg_rating,
        COUNT(*) AS num
    FROM ratings
    GROUP BY prod_id
) rated
WHERE num >= 50
ORDER BY avg_rating ASC
LIMIT 1;


-- ----------------------------------------------------------------------------
-- PART 3: Bonus Exercise 2 - Analyzing Rating Comments (N-grams & Text Search)
-- ----------------------------------------------------------------------------

-- 7 - Find the five most common bigrams (two-word combinations) for prod_id 1274673
SELECT EXPLODE(NGRAMS(SENTENCES(LOWER(message)), 2, 5)) AS bigrams
FROM ratings
WHERE prod_id = 1274673;

-- 8 - Modify the previous query to find the five most common trigrams
SELECT EXPLODE(NGRAMS(SENTENCES(LOWER(message)), 3, 5)) AS trigrams
FROM ratings
WHERE prod_id = 1274673;

-- 9 - Look at a few comments containing the phrase 'ten times more'
SELECT message
FROM ratings
WHERE prod_id = 1274673
  AND LOWER(message) LIKE '%ten times more%'
LIMIT 3;

-- 10 - Find all distinct comments containing the word 'red' for product ID 1274673
SELECT DISTINCT message
FROM ratings
WHERE prod_id = 1274673
  AND LOWER(message) LIKE '%red%';

-- 11 - Display the record for product ID 1274673 in the products table
SELECT *
FROM products
WHERE prod_id = 1274673;

-- 12 - Identify similar products in the products table
SELECT *
FROM products
WHERE name LIKE '%16GB USB Flash Drive%';