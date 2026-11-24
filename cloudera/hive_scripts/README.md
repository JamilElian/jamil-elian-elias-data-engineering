# Welcome to Hive Scripts!

During my **"Cloudera Data Engineering"** course, I completed a series of hands-on SQL labs using **Apache Hive**, **Apache Impala**, and **Cloudera Hue**. In this directory, you will find all of them organized by topic! :)

---

## Description

* Each lab is stored in its own dedicated folder named after the lab topic.
* Inside each folder, you will find two files:
  * **`.sql` file:** The HiveQL / Impala SQL script containing the DDL and DML queries for the lab.
  * **`README.md` file:** A detailed summary of the lab objectives, HDFS data staging commands, workflow, and execution steps.

---

## Tech Stack

* **Apache Hive:** Data warehouse infrastructure for querying and managing large datasets on HDFS (HiveQL, ACID transactional tables, Partitioning, RegexSerDe, Complex Types).
* **Apache Impala:** High-performance MPP SQL query engine for low-latency analytics over HDFS and Parquet tables.
* **Hadoop HDFS:** Distributed file system for storing and staging raw datasets (`IMDb`, `Dualcore`, `Loyalty` data).
* **Cloudera Hue:** Web-based SQL editor and interface used to execute queries and inspect database metadata.

---

## How to Run the Scripts

To replicate these labs in your own cluster or compatible Hive/Impala environment:

1. Ensure you have a working environment with **Hadoop / HDFS**, **Apache Hive**, and **Apache Impala** configured (such as Cloudera Data Platform / CDP).
2. Check the individual `README.md` inside each lab folder to stage the required source datasets into **HDFS** (`hdfs dfs -put ...`) before running the queries.
3. Open **Cloudera Hue** (or Beeline / Impala Shell) and load the `<NAME_OF_SCRIPT>.sql` file.
4. Execute the SQL statements sequentially to create the databases/tables, load the data, run the analytical queries, and clean up temporary objects if required.

---

## Labs Summary

* **Hive SQL (`Hive SQL/`):** Covers core Hive DDL/DML operations, creating databases, contrasting `MANAGED` vs. `EXTERNAL` tables, ingesting data from HDFS (`LOAD DATA INPATH`, `CTAS`), and working with storage formats like Textfile and Parquet.
* **Hive Transactions (`Hive Transactions/`):** Explores ACID compliance and concurrency in Hive using transactional ORC tables (`transactional=true`) to perform row-level `INSERT`, `UPDATE`, and `DELETE` operations.
* **Materialized Views (`Materialized Views/`):** Demonstrates the difference between standard logical views and materialized views, leveraging automated query rewrite optimizations and view invalidation/rebuilding.
* **Hive Joins (`Hive Joins/`):** Implements multi-table relational joins (`INNER`, `LEFT OUTER`, `FULL OUTER`) and join optimization strategies over large IMDb datasets.
* **Hive Partitions (`Hive Partitions/`):** Covers static and dynamic partitioning (`PARTITIONED BY`) to organize HDFS directory structures and accelerate analytical queries via partition pruning.
* **Analyzing Text with Hive (`Analyzing Text with Hive/`):** Parses semi-structured Apache web logs using `RegexSerDe` and `REGEXP_EXTRACT`, and performs NLP text mining (`SENTENCES`, `NGRAMS`, `EXPLODE`) on Dualcore product reviews.
* **Complex Data (`Complex Data/`):** Defines, queries, and unnests nested data structures (`MAP`, `ARRAY`, and `STRUCT`) using dot notation, key/index lookups, and `LATERAL VIEW EXPLODE`, materializing Parquet tables for cross-engine querying with Impala.
