## Lab Overview

The objective of this lab is to understand the behavioral differences between **External** and **Managed** tables in Hive / Spark SQL using the FiveThirtyEight **Marvel Wikia** dataset (`marvel-wikia-data.csv`). It demonstrates how dropping an external table removes only the metastore definition while preserving underlying HDFS files, whereas dropping a managed table removes both metadata and stored ORC data files.

---

## Lab Workflow

The SQL script is organized into three main stages following the lab guide:

| Stage | Steps | Operations Covered | Key SQL / HDFS Commands |
| :--- | :--- | :--- | :--- |
| **Setup** | Prerequisites | Authenticate via Kerberos, download `marvel-wikia-data.csv` into HDFS staging, and create the `<USER>_marvel` database. | `kinit`, `hdfs dfs -put`, `CREATE DATABASE`, `USE` |
| **Part 1: External Table** | **Steps 1 - 8** | Inspect tables, create the CSV-backed `marvel_comics_raw` external table, verify schema, move data from `/raw/` via `LOAD DATA`, and preview records. | `CREATE EXTERNAL TABLE`, `DESCRIBE`, `LOAD DATA INPATH`, `SELECT ... LIMIT 20` |
| **Part 2: Managed ORC Table** | **Steps 9 - 13** | Create the `marvel_comics` managed table stored as ORC, populate it from `marvel_comics_raw`, preview records, and inspect its warehouse path. | `CREATE TABLE ... STORED AS ORC`, `INSERT INTO TABLE`, `SHOW CREATE TABLE` |
| **Part 3: Lifecycle Cleanup** | **Steps 14 - 19** | Drop the external table and confirm CSV files remain in HDFS; drop the managed table and confirm ORC files are deleted from the warehouse. | `DROP TABLE`, `SHOW TABLES`, `hdfs dfs -ls` |

---

## How to Run in Cloudera Hue

1. **Stage the raw dataset in HDFS** (via cluster terminal before opening Hue):
   ```bash
   mkdir -p /var/tmp/dev/training/data/marvel
   wget -nv -O /var/tmp/dev/training/data/marvel/marvel-wikia-data.csv [https://github.com/fivethirtyeight/data/raw/master/comic-characters/marvel-wikia-data.csv](https://github.com/fivethirtyeight/data/raw/master/comic-characters/marvel-wikia-data.csv)
   hdfs dfs -mkdir -p /tmp/training/raw /tmp/training/data
   hdfs dfs -put -f /var/tmp/dev/training/data/marvel/marvel-wikia-data.csv /tmp/training/raw
   hdfs dfs -chmod -R 777 /tmp/training/raw /tmp/training/data
   ```
2. Open **Cloudera Hue** and navigate to the **Hive** or **Spark SQL** editor.
3. Paste the contents of `Hive SQL.sql`.
4. Highlight and run each statement step-by-step (`Ctrl + Enter`) to observe the metastore and HDFS behavior at every stage.
