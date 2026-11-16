## Lab Overview

The objective of this lab is to become familiar with Spark's core data abstraction—RDDs—by understanding lazy evaluation, executing actions (`count`, `collect`), and applying transformations (`union`, `distinct`) over text datasets stored in HDFS.

---

## Lab Workflow & Covered Operations

The notebook guides you through the following 13 practical steps:

| Section | Step | Task / Operation | Key Command / PySpark Method |
| :--- | :--- | :--- | :--- |
| **Setup** | — | Clean up previous lab files in HDFS (`/devsh_loudacre/frostroad.txt` and `makes*.txt`) so the notebook is idempotent. | `hdfs dfs -rm -r -f /devsh_loudacre/...` |
| **Read & Inspect RDD** | **1 - 3** | Inspect `frostroad.txt` locally, upload it to `/devsh_loudacre` in HDFS, and define an RDD of strings (`RDD_pyspark`). | `hdfs dfs -put`, `sc.textFile()` |
| **RDD Actions** | **4 - 6** | Trigger lazy evaluation by counting total records (`23` lines), collecting elements to the driver as a Python list, and iterating over the results. | `.count()`, `.collect()` |
| **Upload Phone Makes** | **7** | Upload `makes1.txt` and `makes2.txt` into `/devsh_loudacre` in HDFS. | `hdfs dfs -put -f .../makes*.txt /devsh_loudacre` |
| **Transform RDDs** | **8 - 13** | Load `makes1RDD` and `makes2RDD`, merge them with `union()` (retaining duplicates), and deduplicate the combined dataset using `distinct()`. | `.union()`, `.distinct()` |
| **Tear Down** | — | Terminate the active Apache Livy session via REST API cleanup. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
