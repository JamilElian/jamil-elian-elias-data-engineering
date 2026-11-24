## Lab Overview

The objective of this lab is to master the `DataFrameReader` (`spark.read`) and `DataFrameWriter` (`df.write`) APIs in PySpark. It covers schema inference vs. explicit schema definition (`StructType`), compression codecs, unstructured log parsing, Apache Hive integration, Amazon S3 object storage access, pandas interoperability, and JSON serialization.

---

## Lesson & Lab Workflow

The notebook is structured into a setup phase, six guided lessons, a 5-step JSON lab, and session cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark / CLI Methods |
| :--- | :--- | :--- | :--- |
| **Setup** | Environment & TPC-DS Prep | Configure anonymous S3A credentials, create `/user/livy/data` in HDFS, generate TPC-DS data (`SCALE 5`), and build a Parquet-backed `tpcds.customer` Hive table. | `spark.conf.set()`, `./dsdgen`, `CREATE EXTERNAL TABLE ... STORED AS PARQUET` |
| **Lesson 1** | Delimited Text (CSV/TSV) | Read CSVs with `inferSchema` vs. manual `StructType`, write tab-separated files, and apply `bzip2` compression with `overwrite` mode. | `spark.read.csv()`, `StructType`, `df.write.csv(..., sep="\t", mode="overwrite", compression="bzip2")` |
| **Lesson 2** | Unstructured Text Logs | Read raw Apache web logs line-by-line, extract HTTP `GET` requests using regular expressions, and export results as plain text. | `spark.read.text()`, `regexp_extract()`, `df.write.text()` |
| **Lesson 3** | Apache Parquet | Write a DataFrame with an explicit schema to Parquet format and read it back verifying embedded schema preservation. | `df.write.parquet()`, `spark.read.parquet()`, `.printSchema()` |
| **Lesson 4** | Apache Hive Tables | Query Hive databases/tables via `spark.sql()` and `%sql`, load tables as DataFrames, persist new managed tables with unique UUID names, and drop temporary tables. | `spark.sql()`, `spark.read.table()`, `df.write.saveAsTable()` |
| **Lesson 5** | Object Stores (Amazon S3) | Configure Hadoop `s3a` anonymous credentials on `SparkContext` and read tab-delimited demographics data directly from `s3a://duocar/raw/demographics/`. | `sc._jsc.hadoopConfiguration().set()`, `spark.read.csv("s3a://...")` |
| **Lesson 6** | pandas Interoperability | Load local TSV data into a `pandas.DataFrame`, convert it to a Spark DataFrame, and collect a Spark DataFrame back into pandas. | `pd.read_csv()`, `spark.createDataFrame()`, `df.toPandas()` |
| **Lab Exercises** | **Steps 1 - 5 (JSON)** | 1. Write `riders` to HDFS as JSON (`data/riders_json/`)<br>2. List generated JSON part-files in HDFS<br>3. Inspect raw JSON records with `hdfs dfs -cat`<br>4. Read the JSON directory back into a Spark DataFrame<br>5. Inspect the schema (observing alphabetical column ordering) | `df.write.json()`, `hdfs dfs -ls`, `hdfs dfs -cat`, `spark.read.json()`, `.printSchema()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |

---

## Additional files

Verify that the TPC-DS generator (`/home/training/training_materials/perf/tpcds-kit/tools/dsdgen`), local demographics file (`/home/training/training_materials/dev/data/demographics.txt`), and HDFS DuoCar datasets (`/duocar/raw/riders/`, `/duocar/earcloud/apache_logs/`) are available.
