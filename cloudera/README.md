# Cloudera Data Engineering & Spark Labs

Welcome! This directory contains my hands-on labs, SQL scripts, and Apache Zeppelin notebooks focused on **Big Data engineering, data modeling, and distributed query optimization** on **Cloudera Data Platform (CDP)** using **Apache Hive**, **Apache Impala**, and **Apache Spark (PySpark & Scala)**.

---

## 🛠️ Tech Stack & Tools

* **Big Data Ecosystem:** Cloudera Data Platform (CDP), Apache Hive, Apache Impala, Apache Hadoop (HDFS)
* **Distributed Processing:** Apache Spark 3 (PySpark, Scala, Spark SQL, Catalyst Optimizer)
* **Analytics & IDEs:** Apache Zeppelin (Livy & JDBC interpreters), Cloudera Hue
* **Storage & File Formats:** HDFS, Apache Parquet, Apache ORC (ACID Transactional), RegexSerDe, Delimited Textfiles, JSON, CSV

---

## 📂 Directory Structure

```text
cloudera/
├── hive_scripts/           # Hive & Impala SQL labs executed in Cloudera Hue (.sql & READMEs)
├── zeppelin_notebooks/     # Interactive Apache Zeppelin notebooks in PySpark & Scala (.json & READMEs)
└── README.md               # Overview and documentation of Cloudera labs
```

---

## 🧪 Summary of Completed Labs

### 1. Hive & Impala Data Engineering (`hive_scripts/`)
* **Hive Fundamentals & Architecture:** Database/table management (`MANAGED` vs. `EXTERNAL`), data ingestion (`LOAD DATA INPATH`, `CTAS`), and file formats (Textfile, Parquet, ORC).
* **ACID Transactions & Concurrency:** Transactional ORC tables supporting row-level `INSERT`, `UPDATE`, and `DELETE` operations.
* **Views & Materialized Views:** Query abstraction and automated query rewrite optimizations.
* **Joins & Partitioning:** Static and dynamic partitioning strategies for partition pruning and join optimization on large datasets (IMDb).
* **Text Analytics & Log Parsing:** Semi-structured Apache web log parsing with `RegexSerDe`, regex extraction (`REGEXP_EXTRACT`), and NLP n-gram mining (`SENTENCES`, `NGRAMS`, `EXPLODE`) on Dualcore product reviews.
* **Complex Data Types:** Defining, querying, and unnesting `MAP`, `ARRAY`, and `STRUCT` columns (`LATERAL VIEW EXPLODE`) and exporting to Parquet for Impala interoperability.

### 2. Apache Spark Distributed Processing (`zeppelin_notebooks/`)
* **Explore Query Execution Plans & Spark UI (`PySpark` & `Scala`):**
  * Analyzed Catalyst logical and physical execution plans (`explain(True)`) across single-source (`HiveTableScan` + `Filter`) and multi-source join queries (`Exchange` shuffle boundaries).
  * Correlated execution plans with DAG visualizations, jobs, stages, and task metrics in the **Spark Application UI**.
* **Spark & Hive Interoperability (`PySpark` & `Scala`):**
  * Generated synthetic TPC-DS `customer` data (`dsdgen`) and staged it in HDFS (`/spark-perf/tpcds/customer`).
  * Contrasted Spark-created external tables (`'TRANSLATED_TO_EXTERNAL'='TRUE'`) with Hive-managed ACID transactional ORC tables (`%jdbc(hive)`), implementing the **Spark Staging → Hive CTAS Production** pattern (`staging.customer` → `prod.customer`).
