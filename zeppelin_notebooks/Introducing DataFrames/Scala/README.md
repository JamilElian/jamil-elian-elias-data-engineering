## Lab Overview

The objective of this lab is to become familiar with Spark SQL's distributed structured tables (`DataFrames`) in Scala, understanding lazy evaluation and the Catalyst optimizer while applying column and row transformations over the **DuoCar** CSV datasets (`rides`, `drivers`, and `riders`) stored in HDFS.

---

## Lesson & Lab Workflow

The notebook is structured into a guided lesson followed by 8 hands-on lab exercises:

| Section | Topic / Step | Operations Covered | Key Scala Methods |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion | Read raw CSV files (`rides`, `drivers`, `riders`) from HDFS with automatic header and schema inference. | `spark.read.option(...).csv(...)`, `.printSchema()` |
| **Lesson: Columns** | Column Manipulation | Select, drop, reference (`Column` objects via `'col`, `$"col"`, `col()`), add derived columns, rename columns, and cast data types. | `.select()`, `.drop()`, `col()`, `.withColumn()`, `.selectExpr()`, `.withColumnRenamed()`, `.cast()` |
| **Lesson: Rows** | Row Manipulation | Sort records, limit rows (`limit()` vs. `show()`), deduplicate rows, filter with boolean operators (`===`, `=!=`), take random/stratified samples, and handle missing values. | `.sort()`, `.orderBy()`, `.limit()`, `.distinct()`, `.dropDuplicates()`, `.filter()`, `.where()`, `.sample()`, `.stat.sampleBy()`, `.na.drop()`, `.na.fill()`, `.na.replace()` |
| **Lab Exercises** | **Steps 1 - 8** | 1. Fill missing `rides.service` values with `"Car"`<br>2. Rename `rides.cancelled` to `canceled`<br>3. Sort `rides` by `date_time` (asc) and `driver_id` (desc)<br>4. Create a 20% random sample of `rides`<br>5. Drop driver names (`first_name`, `last_name`)<br>6. Count total registered drivers<br>7. Count female drivers<br>8. Count non-white female drivers | `.na.fill()`, `.withColumnRenamed()`, `.orderBy(asc(), desc())`, `.sample()`, `.drop()`, `.filter()`, `.where()`, `.count` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
