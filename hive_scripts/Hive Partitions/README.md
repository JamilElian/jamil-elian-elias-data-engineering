## Lab Overview

The objective of this lab is to understand how **Hive Partitions** improve query performance and organize data directories in HDFS. Using the `training_movies` database populated with IMDb datasets (`title.basics`, `title.crew`, `name.basics`, and `title.ratings`), the script compares `EXPLAIN EXTENDED` execution plans before and after partitioning `movie_title` by `startYear`, creates a second partitioned table (`movie_crew_info_partition` partitioned by `birthYear`), lists generated partitions, runs analytical UDF queries (`UPPER`, `ARRAY_CONTAINS`), and demonstrates how to resolve `DELETE` restrictions by migrating to an ACID-enabled ORC partitioned table.

---

## Lab Workflow

The lab is structured into a cluster data-staging setup followed by four SQL stages:

| Stage | Steps | Operations Covered | Key Commands |
| :--- | :--- | :--- | :--- |
| **Environment Setup** | Prerequisites | Authenticate via Kerberos, download/unzip IMDb `.tsv.gz` datasets locally, and upload them to HDFS `/tmp/training/raw/`. | `kinit`, `wget`, `gunzip`, `hdfs dfs -put` |
| **SQL Setup** | Database & External Tables | Drop/recreate `training_movies` and load raw IMDb TSV files into 4 external tables (`movie_title`, `movie_crew`, `movie_crew_info`, `ratings`). | `CREATE DATABASE`, `CREATE EXTERNAL TABLE`, `LOAD DATA INPATH`, `ALTER TABLE ... SET TBLPROPERTIES` |
| **Part 1: Exploration & Baseline** | **Steps 1 - 3** | Inspect schemas, run sample `LIMIT 5` queries, and capture a baseline `EXPLAIN EXTENDED` plan on the unpartitioned `movie_title` table. | `USE`, `DESCRIBE`, `SELECT ... LIMIT 5`, `EXPLAIN EXTENDED` |
| **Part 2: Title Partitioning** | **Steps 4 - 6** | Create `movie_title_partition` partitioned by `startYear`, load it via dynamic partitioning, and compare the `EXPLAIN EXTENDED` plan to observe partition pruning. | `CREATE EXTERNAL TABLE ... PARTITIONED BY`, `INSERT INTO ... PARTITION(startYear)`, `EXPLAIN EXTENDED` |
| **Part 3: Crew Partitioning** | **Steps 7 - 10** | Create and populate `movie_crew_info_partition` partitioned by `birthYear`, filter by a specific birth year (`1989`), and list all partitions. | `PARTITIONED BY (birthYear STRING)`, `SHOW PARTITIONS` |
| **Part 4: Practice & ACID Delete** | **Steps 11 - 13** | Query uppercase titles for `'Short'` movies over 60 minutes, convert to an ACID ORC partitioned table (`movie_title_acid_part`) to delete `startYear = '1959'`, and sum runtime minutes for `'Short'` titles in `2001`. | `UPPER()`, `ARRAY_CONTAINS()`, `STORED AS ORC TBLPROPERTIES ('transactional'='true')`, `DELETE FROM`, `SUM()` |

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
2. Paste the contents of `DE_Labs_HivePartitions.sql` and execute the blocks sequentially (`Ctrl + Enter`).
3. Ensure the `SET hive.exec.dynamic.partition.mode=nonstrict;` statements at the top of the script are executed before running the `INSERT INTO ... PARTITION(...)` statements in **Steps 5 and 8**.
