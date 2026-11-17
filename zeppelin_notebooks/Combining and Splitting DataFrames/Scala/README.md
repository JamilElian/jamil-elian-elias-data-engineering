## Lab Overview

The objective of this lab is to master combining and splitting DataFrames across the **DuoCar** datasets (`data_scientists`, `offices`, `rides`, `drivers`, `riders`, and `ride_reviews`) stored in HDFS. It covers all standard Spark SQL join types, multi-table denormalization pipelines, set theory operations (`union`, `intersect`, `except`), and reproducible dataset splitting (`randomSplit`) using Scala pattern matching.

---

## Lesson & Lab Workflow

The notebook is structured into three guided lessons (joins, set operations, and splitting), 2 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key Scala Methods |
| :--- | :--- | :--- | :--- |
| **Lesson 1** | DataFrame Joins | Execute Cartesian products (`crossJoin`), `inner`, `left_semi`, `left_anti`, `left_outer`, `right_outer`, and `full_outer` joins on `scientists` and `offices`, followed by a multi-table `left_outer` join across DuoCar Parquet datasets. | `.crossJoin()`, `.join(..., how=...)`, `spark.read.parquet()` |
| **Lesson 2** | Set Operations | Combine driver and rider first names, deduplicate combined rows, find overlapping names, and identify names exclusive to drivers (`except`). | `.union()`, `.distinct()`, `.intersect()`, `.except()`, `.orderBy()` |
| **Lesson 3** | Splitting DataFrames | Partition the `riders` DataFrame into `Array(train, validate, test)` subsets (60/20/20) using random weights and a fixed `seed` for reproducibility. | `.randomSplit(weights=Array(...), seed=12345)` |
| **Lab Exercises** | **Steps 1 - 2** | 1. Join `rides` with `reviews` keeping only reviewed rides (`right_outer` join)<br>2. Identify drivers who have never provided a ride using both `left_anti` join and `.except()` | `.join(..., "right_outer")`, `.join(..., "left_anti")`, `.except()`, `.withColumnRenamed()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
