## Lab Overview

The objective of this lab is to understand the differences between standard virtual views and **Hive Materialized Views**. Using the `training_movies` database populated with IMDb datasets (`title.basics`, `title.crew`, `name.basics`, and `title.ratings`), the script demonstrates how to create virtual views, convert an external table into an ACID transactional ORC table, materialize query results, rebuild views after underlying data modifications (`DELETE` + `ALTER MATERIALIZED VIEW ... REBUILD`), and inspect or drop materialized views.

---

## Lab Workflow

The lab is structured into a cluster data-staging setup followed by four SQL stages:

| Stage | Steps | Operations Covered | Key Commands |
| :--- | :--- | :--- | :--- |
| **Environment Setup** | Prerequisites | Authenticate via Kerberos, download/unzip IMDb `.tsv.gz` datasets locally, and upload them to HDFS `/tmp/training/raw/`. | `kinit`, `wget`, `gunzip`, `hdfs dfs -put` |
| **SQL Setup** | Database & External Tables | Drop/recreate `training_movies` and load raw IMDb TSV files into 4 external tables (`movie_title`, `movie_crew`, `movie_crew_info`, `ratings`). | `CREATE DATABASE`, `CREATE EXTERNAL TABLE`, `LOAD DATA INPATH`, `ALTER TABLE ... SET TBLPROPERTIES` |
| **Part 1: Exploration** | **Steps 1 - 2** | Select the `training_movies` database, inspect table schemas, and run exploratory queries. | `USE`, `DESCRIBE`, `SELECT ... LIMIT 5` |
| **Part 2: Standard Views** | **Steps 3 - 4** | Create and query two standard views (`movie_year` for movies and `title_releases` for titles after 2015). | `DROP VIEW`, `CREATE VIEW ... AS SELECT` |
| **Part 3: Materialized Views** | **Steps 5 - 11** | Create a transactional ORC table (`movie_title_transaction`), build `mv_movie_title`, test `DELETE` + `REBUILD`, list/drop the view, and create a custom joined materialized view (`mv_top_rated_movies`). | `CREATE TABLE ... STORED AS ORC`, `CREATE MATERIALIZED VIEW`, `ALTER MATERIALIZED VIEW ... REBUILD`, `SHOW MATERIALIZED VIEWS`, `DROP MATERIALIZED VIEW` |

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
2. Paste the contents of `DE_Labs_MaterializedViews.sql` and execute the blocks sequentially (`Ctrl + Enter`).
3. Note in **Step 8** that Hive prohibits direct `DELETE` or `UPDATE` statements on a materialized view; modifications must be applied to the underlying transactional table (`movie_title_transaction`) followed by `ALTER MATERIALIZED VIEW mv_movie_title REBUILD`.
