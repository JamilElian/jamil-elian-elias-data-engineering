## Overview

The objective of this notebook is to practice loading JSON records from HDFS into RDDs, parsing raw JSON strings into key-value structures in both Python and Scala, applying filter and aggregation pipelines (`map`, `flatMap`, `filter`, `reduceByKey`), and demonstrating how `.cache()` affects data retrieval when the underlying HDFS file is modified.

---

## Notebook Workflow & Covered Operations

The notebook is organized into four main sections:

| Section | Operations Covered | Key Methods / Commands |
| :--- | :--- | :--- |
| **1. Data Ingestion (HDFS)** | Create `/pruebasRDDs` in HDFS, upload `devices.json`, and preview the first 10 lines. | `hdfs dfs -mkdir`, `hdfs dfs -put`, `hdfs dfs -cat` |
| **2. RDDs with PySpark** | Load `devices.json` as an RDD of strings, count records, parse JSON lines into Python dictionaries (`import json`), filter devices where `make == 'MeeToo'`, and count devices per manufacturer. | `sc.textFile()`, `.count()`, `json.loads()`, `.map()`, `.filter()`, `.reduceByKey()`, `.take()`, `.collect()` |
| **3. RDDs with Scala** | Replicate the JSON pipeline in strongly typed Scala: parse JSON strings into `Map[String, Any]`, filter out empty records, filter `'MeeToo'` devices safely with `Option` handling, and count devices per manufacturer. | `sc.textFile()`, `JSON.parseFull()`, `.map()`, `.filter()`, `.flatMap()`, `.reduceByKey(_ + _)` |
| **4. RDD Persistence & Cleanup** | Compare an uncached RDD against a cached RDD (`MEMORY_ONLY`), replace `devices.json` in HDFS with `devices_modificado.json` to observe cache retention vs. HDFS re-reads, and delete `/pruebasRDDs` afterward. | `.cache()`, `hdfs dfs -rm -skipTrash`, `hdfs dfs -rm -r -f -skipTrash` |

---

## Additional files

Verify that the sample files (`devices.json` and `devices_modificado.json`) exist locally at `/home/training/training_materials/dev/data/`.
