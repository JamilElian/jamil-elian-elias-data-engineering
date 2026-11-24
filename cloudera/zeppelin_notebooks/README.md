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

* **Apache Spark in 5 Minutes (`apache_spark_in_5_minutes/`):** Quickstart lab introducing interactive distributed data exploration in Zeppelin using Spark DataFrames and SQL.
* **MarkDown Tutorial (`markdown_tutorial/`):** Demonstrates how to structure rich documentation, formatting, and dynamic text cells using the `%md` interpreter in Apache Zeppelin.
* **HDFS Tutorial (`HDFS_tutorial/`):** Covers foundational Hadoop Distributed File System shell commands (`hdfs dfs`) directly from Zeppelin `%sh` paragraphs.
* **Working with HDFS (`working_with_HDFS/`):** Explores reading, writing, and managing distributed files and directories in HDFS through Spark APIs.
* **Working with YARN (`wroking_with_YARN/`):** Demonstrates submitting, configuring, and monitoring Spark applications running on Apache YARN cluster resources.
* **RDD Tests (`RDD_tests/`):** Experiments with low-level Resilient Distributed Datasets (RDDs), testing lazy evaluation, lineage, transformations, and actions.
* **Working with RDDs (`working_with_RDDs/`):** Applies functional programming transformations (`map`, `filter`, `flatMap`, `reduceByKey`) on distributed datasets using the RDD API.
* **Introducing DataFrames (`introducing_dataframes/`):** Covers creating Spark DataFrames, inspecting inferred schemas (`printSchema()`), and executing basic relational projections and filters.
* **Reading and Writing DataFrames (`reading_and_writing_dataframes/`):** Demonstrates ingesting and persisting structured data across multiple formats (CSV, JSON, Parquet) and Hive tables.
* **Working with Columns (`working_with_columns/`):** Explores column expressions (`col`, `$`), type casting, conditional logic (`when`/`otherwise`), and built-in `pyspark.sql.functions` / `org.apache.spark.sql.functions`.
* **Combining and Splitting DataFrames (`combining_and_splitting_dataframes/`):** Covers relational joins (`inner`, `left`, `outer`), set operations (`union`, `intersect`), and dataset splitting (`randomSplit`).
* **Summarizing and Grouping DataFrames (`summarizing_and_grouping_dataframes/`):** Performs grouped aggregations (`groupBy`, `agg`, `rollup`, `cube`) and summary statistics on large datasets.
* **Working with Complex Types (`working_with_complex_types/`):** Manipulates nested arrays, maps, and structs in Spark DataFrames using functions like `explode`, `struct`, and array/map accessors.
* **Working with Windows (`working_with_windows/`):** Implements analytical window functions (`row_number`, `rank`, `dense_rank`, `lag`, `lead`, and moving averages) over partitioned and ordered DataFrame windows.
* **Working with UDFs (`working_with_UDFs/`):** Covers defining, registering, and applying custom User-Defined Functions (UDFs) in PySpark, Scala, and Spark SQL.
* **Explore Query Execution (`explore_query_execution/`):** Inspects Catalyst logical and physical execution plans (`explain(True)`) across single-source scans and multi-source joins (`Exchange` shuffles), correlating them with DAGs, jobs, and stages in the **Spark Application UI**.
* **Spark Integration with Hive (`spark_integration_with_hive/`):** Contrasts Spark-created external tables (`'TRANSLATED_TO_EXTERNAL'='TRUE'`) with Hive-managed ACID transactional ORC tables (`%jdbc(hive)`), implementing the **Spark Staging → Hive CTAS Production** pattern (`staging.customer` → `prod.customer`) using TPC-DS data.
