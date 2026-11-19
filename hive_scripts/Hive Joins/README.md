## Lab Overview

The objective of this lab is to become familiar with **Hive Joins** and query optimization techniques on Hadoop. Using the `training_movies` database populated with IMDb datasets (`title.basics`, `title.crew`, `name.basics`, and `title.ratings`), the script covers standard inner joins on primary keys (`tconst`), expression-based joins using string UDFs (`SUBSTR`), execution plan inspection (`EXPLAIN`), converting external tables into managed transactional ORC tables, and creating a materialized view (`mv_movie_ratings`) backed by a multi-table join.

---

## Lab Workflow

The lab is structured into a cluster data-staging setup followed by three SQL stages:

| Stage | Steps | Operations Covered | Key Commands |
| :--- | :--- | :--- | :--- |
| **Environment Setup** | Prerequisites | Authenticate via Kerberos, download/unzip IMDb `.tsv.gz` datasets locally, and upload them to HDFS `/tmp/training/raw/`. | `kinit`, `wget`, `gunzip`, `hdfs dfs -put` |
| **SQL Setup** | Database & External Tables | Drop/recreate `training_movies` and load raw IMDb TSV files into 4 external tables (`movie_title`, `movie_crew`, `movie_crew_info`, `ratings`). | `CREATE DATABASE`, `CREATE EXTERNAL TABLE`, `LOAD DATA INPATH`, `ALTER TABLE ... SET TBLPROPERTIES` |
| **Part 1: Joins & Explain** | **Steps 1 - 3** | Inspect schemas, join `movie_title` with `ratings` on `tconst`, join `movie_title` with `movie_crew_info` using `SUBSTR`, and inspect query execution plans. | `DESCRIBE`, `JOIN ... ON`, `SUBSTR()`, `EXPLAIN` |
| **Part 2: Materialized View** | **Steps 4 - 6** | Create managed transactional ORC copies (`int_movie_title`, `int_ratings`), build the joined `mv_movie_ratings` materialized view (`startYear > 2001` and `averageRting > 5.5`), and query it. | `CREATE TABLE ... STORED AS ORC`, `CREATE MATERIALIZED VIEW`, `SELECT ... LIMIT 5` |
| **Part 3: Optional Challenge** | **Bonus** | Join all four tables (`movie_title`, `ratings`, `movie_crew`, `movie_crew_info`) using `LATERAL VIEW EXPLODE` to resolve director names. | `JOIN`, `LATERAL VIEW EXPLODE()`, `SPLIT()` |

---

## ⚙️ How to Run

### 1. Stage the IMDb Datasets in HDFS (Cluster Terminal)
Before running the SQL script in Hue, download the IMDb files and upload them to HDFS:

```bash
# Authenticate with Kerberos (if enabled in your cluster)
echo {password.global} | kinit {user.global}

# Download and extract IMDb datasets locally
rm -rf /var/tmp/dev/training
mkdir -p /var/tmp/dev/training
cd /var/tmp/dev/training

wget -nv [https://datasets.imdbws.com/title.basics.tsv.gz](https://datasets.imdbws.com/title.basics.tsv.gz)
wget -nv [https://datasets.imdbws.com/title.crew.tsv.gz](https://datasets.imdbws.com/title.crew.tsv.gz)
wget -nv [https://datasets.imdbws.com/name.basics.tsv.gz](https://datasets.imdbws.com/name.basics.tsv.gz)
wget -nv [https://datasets.imdbws.com/title.ratings.tsv.gz](https://datasets.imdbws.com/title.ratings.tsv.gz)

gunzip title.basics.tsv.gz
gunzip title.crew.tsv.gz
gunzip name.basics.tsv.gz
gunzip title.ratings.tsv.gz

# Upload TSV files to HDFS and set permissions
hdfs dfs -rm -r -f /tmp/training/raw
hdfs dfs -mkdir -p /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/training/title.basics.tsv /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/training/title.crew.tsv /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/training/name.basics.tsv /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/training/title.ratings.tsv /tmp/training/raw
hdfs dfs -chmod -R 777 /tmp/training/raw

hdfs dfs -mkdir -p /tmp/training/movies
hdfs dfs -chmod -R 777 /tmp/training/movies
```

### 2. Execute the Hive SQL Script in Cloudera Hue
1. Open **Cloudera Hue** and navigate to the **Hive** query editor.
2. Paste the contents of `Hive Joins.sql` and execute the blocks sequentially (`Ctrl + Enter`).
3. Inspect the output of the `EXPLAIN` statements in **Step 3** to observe how Hive optimizes standard key joins versus function-based (`SUBSTR`) joins.
