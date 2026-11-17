## Lab Overview

The objective of this lab is to master the `DataFrameReader` (`spark.read`) and `DataFrameWriter` (`df.write`) APIs in Scala. It covers schema inference vs. explicit schema definition (`StructType`), compression codecs, unstructured log parsing with regular expressions, Apache Hive integration, Amazon S3 object storage access, and JSON serialization.

---

## Lesson & Lab Workflow

The notebook is structured into a setup phase, five guided lessons, a 5-step JSON lab, and session cleanup:

| Section | Topic / Step | Operations Covered | Key Scala / CLI Methods |
| :--- | :--- | :--- | :--- |
| **Setup** | Environment & Storage Prep | Configure anonymous S3A credentials in Spark and recreate the `/user/livy/data` output directory in HDFS. | `spark.conf.set()`, `hdfs dfs -rm`, `hdfs dfs -mkdir` |
| **Lesson 1** | Delimited Text (CSV/TSV) | Read CSVs with `inferSchema` vs. manual `StructType(Array(...))`, write tab-separated files, and apply `bzip2` compression with `overwrite` mode. | `spark.read.option(...).csv()`, `StructType`, `df.write.option(...).csv()` |
| **Lesson 2** | Unstructured Text Logs | Read raw Apache web logs line-by-line, extract HTTP `GET` requests using regular expressions, and export results as plain text. | `spark.read.text()`, `regexp_extract($"value", ...)`, `df.write.text()` |
| **Lesson 3** | Apache Parquet | Write a DataFrame with an explicit schema to Parquet format and read it back verifying embedded schema preservation. | `df.write.parquet()`, `spark.read.parquet()`, `.printSchema()` |
| **Lesson 4** | Apache Hive Tables | Query Hive databases/tables via `spark.sql()` and `%sql`, load tables as DataFrames, persist new managed tables (`savedCustomers`), and drop temporary tables. | `spark.sql()`, `spark.read.table()`, `df.write.saveAsTable()` |
| **Lesson 5** | Object Stores (Amazon S3) | Configure Hadoop `s3a` anonymous credentials on `spark.sparkContext` and read CSV demographics data directly from `s3a://duocar/raw/demographics/`. | `spark.sparkContext.hadoopConfiguration.set()`, `spark.read.option(...).csv("s3a://...")` |
| **Lab Exercises** | **Steps 1 - 5 (JSON)** | 1. Write `riders` to HDFS as JSON (`data/riders_json/`)<br>2. List generated JSON part-files in HDFS<br>3. Inspect raw JSON records with `hdfs dfs -cat`<br>4. Read the JSON directory back into a Spark DataFrame<br>5. Inspect the schema (observing alphabetical column ordering) | `df.write.mode("overwrite").json()`, `hdfs dfs -ls`, `hdfs dfs -cat`, `spark.read.json()`, `.printSchema()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
