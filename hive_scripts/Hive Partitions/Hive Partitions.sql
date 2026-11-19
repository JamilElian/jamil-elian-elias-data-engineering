-- ============================================================================
-- Lab: Hive Partitions (Dynamic Partitioning & Partition Pruning)
-- Tool: Cloudera Hue (Hive Editor)
-- User: training
-- ============================================================================

-- Enable non-strict dynamic partitioning in Hive
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=5000;
SET hive.exec.max.dynamic.partitions.pernode=2000;


-- ----------------------------------------------------------------------------
-- SETUP: Database & External Tables Creation
-- ----------------------------------------------------------------------------
DROP DATABASE IF EXISTS training_movies CASCADE;
CREATE DATABASE training_movies;
USE training_movies;

-- 1. movie_title
CREATE EXTERNAL TABLE movie_title (
    tconst STRING,
    titleType STRING,
    primaryTitle STRING,
    originalTitle STRING,
    isAdult STRING,
    startYear STRING,
    endYear STRING,
    runtimeMinutes STRING,
    genres ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/movie_title/'
TBLPROPERTIES ('external.table.purge'='true', 'skip.header.line.count'='1');

LOAD DATA INPATH '/tmp/training/raw/title.basics.tsv'
OVERWRITE INTO TABLE movie_title;

-- 2. movie_crew
CREATE EXTERNAL TABLE movie_crew (
    tconst STRING,
    directors ARRAY<STRING>,
    writers ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/movie_crew/'
TBLPROPERTIES ('external.table.purge'='true', 'skip.header.line.count'='1');

LOAD DATA INPATH '/tmp/training/raw/title.crew.tsv'
OVERWRITE INTO TABLE movie_crew;

-- 3. movie_crew_info
CREATE EXTERNAL TABLE movie_crew_info (
    nconst STRING,
    primaryName STRING,
    birthYear STRING,
    deathYear STRING,
    primaryProfession ARRAY<STRING>,
    knownForTitles ARRAY<STRING>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/movie_crew_info/'
TBLPROPERTIES ('external.table.purge'='true', 'skip.header.line.count'='1');

LOAD DATA INPATH '/tmp/training/raw/name.basics.tsv'
OVERWRITE INTO TABLE movie_crew_info;

-- 4. ratings
CREATE EXTERNAL TABLE ratings (
    tconst STRING,
    averageRting DOUBLE,
    numVotes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/ratings/'
TBLPROPERTIES ('external.table.purge'='true', 'skip.header.line.count'='1');

LOAD DATA INPATH '/tmp/training/raw/title.ratings.tsv'
OVERWRITE INTO TABLE ratings;


-- ----------------------------------------------------------------------------
-- PART 1: Exploration & Baseline Explain Plan
-- ----------------------------------------------------------------------------

-- 1 - Use movies database and describe tables
USE training_movies;
DESCRIBE movie_title;
DESCRIBE movie_crew;
DESCRIBE movie_crew_info;
DESCRIBE ratings;

-- 2 - Do some practice queries to become familiar with data (Limit to 5 rows)
SELECT * FROM movie_title LIMIT 5;
SELECT * FROM movie_crew LIMIT 5;
SELECT * FROM movie_crew_info LIMIT 5;
SELECT * FROM ratings LIMIT 5;

-- 3 - Execute Explain Plan on unpartitioned table
EXPLAIN EXTENDED
SELECT COUNT(*) FROM movie_title WHERE startYear = '1999';


-- ----------------------------------------------------------------------------
-- PART 2: Dynamic Partitioning on movie_title (by startYear)
-- ----------------------------------------------------------------------------

-- 4 - Drop and Create the movie_title_partition table
DROP TABLE IF EXISTS movie_title_partition;

CREATE EXTERNAL TABLE movie_title_partition (
    tconst STRING,
    titleType STRING,
    primaryTitle STRING,
    originalTitle STRING,
    isAdult STRING,
    endYear STRING,
    runtimeMinutes STRING,
    genres ARRAY<STRING>
)
PARTITIONED BY (startYear STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/movie_title_partition/'
TBLPROPERTIES ('external.table.purge'='true');

DESCRIBE FORMATTED movie_title_partition;

-- 5 - Load movie_title_partition using movie_title table (partition column MUST be last)
INSERT INTO TABLE movie_title_partition
PARTITION (startYear)
SELECT
    tconst,
    titleType,
    primaryTitle,
    originalTitle,
    isAdult,
    endYear,
    runtimeMinutes,
    genres,
    startYear
FROM movie_title;

-- 6 - Execute the same explain plan query on the new partitioned table (Partition Pruning)
EXPLAIN EXTENDED
SELECT COUNT(*) FROM movie_title_partition WHERE startYear = '1999';


-- ----------------------------------------------------------------------------
-- PART 3: Dynamic Partitioning on movie_crew_info (by birthYear)
-- ----------------------------------------------------------------------------

-- 7 - Drop and create the partitioned table
DROP TABLE IF EXISTS movie_crew_info_partition;

CREATE EXTERNAL TABLE movie_crew_info_partition (
    nconst STRING,
    primaryName STRING,
    deathYear STRING,
    primaryProfession ARRAY<STRING>,
    knownForTitles ARRAY<STRING>
)
PARTITIONED BY (birthYear STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/movie_crew_info_partition/'
TBLPROPERTIES ('external.table.purge'='true');

-- 8 - Load the partitioned table (partition column MUST be last)
INSERT INTO TABLE movie_crew_info_partition
PARTITION (birthYear)
SELECT
    nconst,
    primaryName,
    deathYear,
    primaryProfession,
    knownForTitles,
    birthYear
FROM movie_crew_info;

-- 9 - Execute a query on the table on a specific birth year
SELECT * FROM movie_crew_info_partition WHERE birthYear = '1989' LIMIT 20;

-- 10 - List the partitions for the partitioned table
SHOW PARTITIONS movie_crew_info_partition;


-- ----------------------------------------------------------------------------
-- PART 4: Practice SQL & ACID Delete on Partitioned Table
-- ----------------------------------------------------------------------------

-- 11 - Title in uppercase of non-adult movies of 'Short' genre with runtime > 60 min
SELECT UPPER(primaryTitle)
FROM movie_title_partition
WHERE isAdult = '0'
  AND CAST(runtimeMinutes AS INT) > 60
  AND ARRAY_CONTAINS(genres, 'Short')
LIMIT 20;

-- 12 - Delete all movie titles with startYear = '1959'
-- Note: Direct DELETE on an external/non-transactional table fails:
-- DELETE FROM movie_title_partition WHERE startYear = '1959';

-- Solution: Create a partitioned ACID transactional ORC table
DROP TABLE IF EXISTS movie_title_acid_part;

CREATE TABLE movie_title_acid_part (
    tconst STRING,
    titleType STRING,
    primaryTitle STRING,
    originalTitle STRING,
    isAdult STRING,
    endYear STRING,
    runtimeMinutes STRING,
    genres ARRAY<STRING>
)
PARTITIONED BY (startYear STRING)
STORED AS ORC
TBLPROPERTIES ('transactional'='true');

INSERT INTO TABLE movie_title_acid_part
PARTITION (startYear)
SELECT
    tconst,
    titleType,
    primaryTitle,
    originalTitle,
    isAdult,
    endYear,
    runtimeMinutes,
    genres,
    startYear
FROM movie_title_partition;

DELETE FROM movie_title_acid_part WHERE startYear = '1959';
SELECT COUNT(*) FROM movie_title_acid_part WHERE startYear = '1959';

-- 13 - Total runtime minutes of 'Short' titles in 2001
SELECT SUM(CAST(runtimeMinutes AS INT)) AS total_runtime_minutes
FROM movie_title_partition
WHERE startYear = '2001'
  AND ARRAY_CONTAINS(genres, 'Short');