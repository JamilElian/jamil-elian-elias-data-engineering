# Welcome to Zeppelin Notebooks!

During my course of "Cloudera Spark Big Data Developer", I did labs related to **Apache Zeppelin**.

In this file you will find them all! :)

---

## Description

* For each lab, there will be a **JSON File** and a **README.md File** as well. These 2 files will be inside of **Folder** with the name of the lab.

* The **README.md File** will have a sum up of the lab.

---

## Tech Stack

* **Hadoop HDFS:** Distributed file system for storing large datasets across clusters.
* **Apache Zeppelin:** Interactive notebook environment executing shell commands via the `%sh` interpreter and documentation via `%md`.

---

## How to run all notebooks

To replicate this analysis in your own cluster or compatible Spark/Zeppelin environment:

1. Ensure you have a working environment with **Hadoop / HDFS** and **Spark 2.x** configured (such as HDP 2.6+ or HDCloud).
2. Import the `NAME_OF_NOTEBOOK` notebook into Apache Zeppelin.
3. Additionally, add the necessary files (if required) to the directories specified for each lab to ensure the JSON file functions optimally. (Note: the README for each lab will specify which files are needed and where they should be added.)
4. Run the paragraphs sequentially (`Shift + Enter`) to download the dataset into HDFS, execute the transformations, and clean up the temporary file afterward.

---

## Labs Summary

* **Apache Spark in 5 Minutes (`Apache Spark in 5 Minutes/`):** Quickstart lab introducing interactive distributed data exploration in Zeppelin using Spark DataFrames and SQL.
* **MarkDown Tutorial (`MarkDown Tutorial/`):** Demonstrates how to structure rich documentation, formatting, and dynamic text cells using the `%md` interpreter in Apache Zeppelin.
* **HDFS Tutorial (`HDFS Tutorial/`):** Covers foundational Hadoop Distributed File System shell commands (`hdfs dfs`) directly from Zeppelin `%sh` paragraphs.
* **Working with HDFS (`Working with HDFS/`):** Explores reading, writing, and managing distributed files and directories in HDFS through Spark APIs.
* **Working with YARN (`Wroking with YARN/`):** Demonstrates submitting, configuring, and monitoring Spark applications running on Apache YARN cluster resources.
* **RDD Tests (`RDD Tests/`):** Experiments with low-level Resilient Distributed Datasets (RDDs), testing lazy evaluation, lineage, transformations, and actions.
* **Working with RDDs (`Working with RDDs/`):** Applies functional programming transformations (`map`, `filter`, `flatMap`, `reduceByKey`) on distributed datasets using the RDD API.
* **Introducing DataFrames (`Introducing DataFrames/`):** Covers creating Spark DataFrames, inspecting inferred schemas (`printSchema()`), and executing basic relational projections and filters.
* **Reading and Writing DataFrames (`Reading and Writing DataFrames/`):** Demonstrates ingesting and persisting structured data across multiple formats (CSV, JSON, Parquet) and Hive tables.
* **Working with Columns (`Working with Columns/`):** Explores column expressions (`col`, `$`), type casting, conditional logic (`when`/`otherwise`), and built-in `pyspark.sql.functions` / `org.apache.spark.sql.functions`.
* **Combining and Splitting DataFrames (`Combining and Splitting DataFrames/`):** Covers relational joins (`inner`, `left`, `outer`), set operations (`union`, `intersect`), and dataset splitting (`randomSplit`).
* **Summarizing and Grouping DataFrames (`Summarizing and Grouping DataFrames/`):** Performs grouped aggregations (`groupBy`, `agg`, `rollup`, `cube`) and summary statistics on large datasets.
* **Working with Complex Types (`Working with Complex Types/`):** Manipulates nested arrays, maps, and structs in Spark DataFrames using functions like `explode`, `struct`, and array/map accessors.
* **Working with Windows (`Working with Windows/`):** Implements analytical window functions (`row_number`, `rank`, `dense_rank`, `lag`, `lead`, and moving averages) over partitioned and ordered DataFrame windows.
* **Working with UDFs (`Working with UDFs/`):** Covers defining, registering, and applying custom User-Defined Functions (UDFs) in PySpark, Scala, and Spark SQL.
* **Explore Query Execution (`Explore Query Execution/`):** Inspects Catalyst logical and physical execution plans (`explain(True)`) across single-source scans and multi-source joins (`Exchange` shuffles), correlating them with DAGs, jobs, and stages in the **Spark Application UI**.
* **Spark Integration with Hive (`Spark Integration with Hive/`):** Contrasts Spark-created external tables (`'TRANSLATED_TO_EXTERNAL'='TRUE'`) with Hive-managed ACID transactional ORC tables (`%jdbc(hive)`), implementing the **Spark Staging → Hive CTAS Production** pattern (`staging.customer` → `prod.customer`) using TPC-DS data.
