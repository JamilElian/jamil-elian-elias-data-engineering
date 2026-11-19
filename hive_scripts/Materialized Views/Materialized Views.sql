-- ============================================================================
-- Lab: Hive Views & Materialized Views
-- Tool: Cloudera Hue (Hive Editor)
-- Note: Materialized views with automatic query rewrite / rebuild require
--       ACID-enabled transactional source tables (ORC).
-- ============================================================================

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
    averageRating DOUBLE,
    numVotes INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/tmp/training/movies/ratings/'
TBLPROPERTIES ('external.table.purge'='true', 'skip.header.line.count'='1');

LOAD DATA INPATH '/tmp/training/raw/title.ratings.tsv'
OVERWRITE INTO TABLE ratings;


-- ----------------------------------------------------------------------------
-- PART 1: Inspect Schema & Practice Queries
-- ----------------------------------------------------------------------------

-- 1 - Use movies database and describe tables
USE training_movies;
DESCRIBE movie_title;
DESCRIBE movie_crew;
DESCRIBE movie_crew_info;
DESCRIBE ratings;

-- 2 - Do some practice queries to become familiar with data
SELECT * FROM movie_title LIMIT 5;
SELECT * FROM movie_crew LIMIT 5;
SELECT * FROM movie_crew_info LIMIT 5;
SELECT * FROM ratings LIMIT 5;


-- ----------------------------------------------------------------------------
-- PART 2: Standard Hive Views
-- ----------------------------------------------------------------------------

-- 3 - Drop and Create the views
DROP VIEW IF EXISTS movie_year;
DROP VIEW IF EXISTS title_releases;

CREATE VIEW movie_year AS
SELECT primaryTitle, startYear
FROM movie_title
WHERE titleType = "movie";

CREATE VIEW title_releases AS
SELECT primaryTitle, startYear
FROM movie_title
WHERE startYear > 2015;

-- 4 - Query the new views (Limit to 5)
SELECT * FROM movie_year LIMIT 5;
SELECT * FROM title_releases LIMIT 5;


-- ----------------------------------------------------------------------------
-- PART 3: Materialized Views on Transactional ORC Tables
-- ----------------------------------------------------------------------------

-- 5 - Drop and create the transactional table
DROP TABLE IF EXISTS movie_title_transaction;

CREATE TABLE movie_title_transaction
STORED AS ORC AS
SELECT * FROM movie_title;

ALTER TABLE movie_title_transaction
SET TBLPROPERTIES ('transactional'='true');

-- 6 - Create a materialized view and describe the view
DROP MATERIALIZED VIEW IF EXISTS mv_movie_title;

CREATE MATERIALIZED VIEW mv_movie_title AS
SELECT primaryTitle, startYear
FROM movie_title_transaction
WHERE titleType = "movie";

DESCRIBE FORMATTED training_movies.mv_movie_title;

-- 7 - Execute a query on the materialized view
SELECT * FROM mv_movie_title LIMIT 5;

-- 8 - Can you delete movie titles from the year 2000 and rebuild the materialized view?
-- Note: Direct DML on a materialized view is NOT allowed and will raise an error:
-- DELETE FROM mv_movie_title WHERE startYear = '2000';

-- Instead, delete from the underlying transactional table and rebuild the materialized view:
DELETE FROM movie_title_transaction WHERE startYear = '2000';
ALTER MATERIALIZED VIEW mv_movie_title REBUILD;

-- 9 - Show the materialized views in the movies database
SHOW MATERIALIZED VIEWS IN training_movies;

-- 10 - Drop the Materialized view
DROP MATERIALIZED VIEW training_movies.mv_movie_title;

-- 11 - Practice SQL: Create your own materialized view (Top-rated movies with > 10,000 votes)
DROP MATERIALIZED VIEW IF EXISTS mv_top_rated_movies;

CREATE MATERIALIZED VIEW mv_top_rated_movies AS
SELECT
    t.primaryTitle,
    t.startYear,
    r.averageRating,
    r.numVotes
FROM movie_title_transaction t
JOIN ratings r ON t.tconst = r.tconst
WHERE t.titleType = 'movie'
  AND r.numVotes > 10000;

SELECT * FROM mv_top_rated_movies LIMIT 10;