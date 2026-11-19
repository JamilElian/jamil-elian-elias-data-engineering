-- ============================================================================
-- Lab: Hive Joins & Materialized Views on Joins
-- Tool: Cloudera Hue (Hive Editor)
-- User: training
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
-- PART 1: Table Inspection & Join Queries
-- ----------------------------------------------------------------------------

-- Inspect schemas
USE training_movies;
DESCRIBE movie_title;
DESCRIBE movie_crew;
DESCRIBE movie_crew_info;
DESCRIBE ratings;

-- 1 - Join movie_title and ratings using the tconst key (Limit 5 rows)
SELECT
    movie_title.titleType,
    movie_title.primaryTitle,
    movie_title.originalTitle,
    ratings.averageRting
FROM movie_title
JOIN ratings ON (movie_title.tconst = ratings.tconst)
LIMIT 5;

-- 2 - Join movie_title and movie_crew_info using SUBSTR on keys (Limit 5 rows)
SELECT
    movie_title.titleType,
    movie_title.originalTitle,
    movie_title.startYear,
    movie_crew_info.primaryName,
    movie_crew_info.birthYear,
    movie_crew_info.primaryProfession
FROM movie_title
JOIN movie_crew_info
    ON (SUBSTR(movie_title.tconst, 3, 9) = SUBSTR(movie_crew_info.nconst, 3, 9))
LIMIT 5;

-- 3 - Execute Explain Plans on Join statements
EXPLAIN
SELECT
    movie_title.titleType,
    movie_title.primaryTitle,
    movie_title.originalTitle,
    ratings.averageRting
FROM movie_title
JOIN ratings ON (movie_title.tconst = ratings.tconst)
LIMIT 5;

EXPLAIN
SELECT
    movie_title.titleType,
    movie_title.originalTitle,
    movie_title.startYear,
    movie_crew_info.primaryName,
    movie_crew_info.birthYear,
    movie_crew_info.primaryProfession
FROM movie_title
JOIN movie_crew_info
    ON (SUBSTR(movie_title.tconst, 3, 9) = SUBSTR(movie_crew_info.nconst, 3, 9))
LIMIT 5;


-- ----------------------------------------------------------------------------
-- PART 2: Materialized View over Joined Managed Tables
-- ----------------------------------------------------------------------------

-- 4 - Create managed (transactional ORC) versions of movie_title and ratings
DROP TABLE IF EXISTS training_movies.int_movie_title;
CREATE TABLE training_movies.int_movie_title
STORED AS ORC
TBLPROPERTIES ('transactional'='true') AS
SELECT * FROM training_movies.movie_title;

DROP TABLE IF EXISTS training_movies.int_ratings;
CREATE TABLE training_movies.int_ratings
STORED AS ORC
TBLPROPERTIES ('transactional'='true') AS
SELECT * FROM training_movies.ratings;

-- 5 - Drop and Create the materialized view
DROP MATERIALIZED VIEW IF EXISTS training_movies.mv_movie_ratings;

CREATE MATERIALIZED VIEW IF NOT EXISTS training_movies.mv_movie_ratings AS
SELECT
    int_movie_title.titleType,
    int_movie_title.primaryTitle,
    int_movie_title.originalTitle,
    int_ratings.averageRting
FROM int_movie_title
JOIN int_ratings ON (int_movie_title.tconst = int_ratings.tconst)
WHERE int_movie_title.startYear > 2001
  AND int_ratings.averageRting > 5.5;

-- 6 - Execute a Query on the materialized view (Limit 5 rows)
SELECT * FROM training_movies.mv_movie_ratings LIMIT 5;


-- ----------------------------------------------------------------------------
-- PART 3: Optional Challenge (Multi-Table Join)
-- ----------------------------------------------------------------------------

-- Join movie_title, ratings, movie_crew, and movie_crew_info (exploding directors array)
SELECT
    t.titleType,
    t.primaryTitle,
    t.startYear,
    r.averageRting,
    r.numVotes,
    ci.primaryName AS director_name
FROM movie_title t
JOIN ratings r ON t.tconst = r.tconst
JOIN movie_crew c ON t.tconst = c.tconst
LATERAL VIEW EXPLODE(SPLIT(c.directors[0], ',')) dir_tbl AS director_id
JOIN movie_crew_info ci ON director_id = ci.nconst
WHERE t.titleType = 'movie'
  AND r.numVotes > 50000
LIMIT 10;