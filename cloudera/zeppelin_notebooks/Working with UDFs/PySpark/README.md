## Lab Overview

The objective of this lab is to learn how to extend Spark SQL with custom Python logic over the raw **DuoCar** rides dataset (`/duocar/raw/rides/`) stored in HDFS. It demonstrates how to wrap standard Python functions with explicit Spark SQL return types, analyze JVM-to-Python serialization overhead, contrast standard row-by-row UDFs with vectorized `pandas_udf` (Apache Arrow) and native Spark built-in functions, and implement geospatial/temporal transformations.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion and casting setup, two guided UDF examples, 3 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion & Casting | Read the raw rides CSV file from HDFS and cast the `date_time` column to a Spark `TimestampType`. | `spark.read.csv(..., header=True, inferSchema=True)`, `.cast("timestamp")` |
| **Example 1** | Hour of Day Extraction | Define a Python `datetime` helper (`hour_of_day`), register it with `IntegerType()`, apply it to `date_time`, and aggregate ride counts by hour. | `udf(..., returnType=IntegerType())`, `.select()`, `.groupBy().count()`, `.orderBy()` |
| **Example 2** | Great-Circle Distance | Implement the Haversine formula in Python (`math` module), register it with `DoubleType()`, calculate straight-line distances between origin and destination coordinates, and compare them against recorded ride `distance`. | `udf(..., returnType=DoubleType())`, `.withColumn()`, `.filter()` |
| **Lab Exercises** | **Steps 1 - 3** | 1. Define and register `day_of_week_udf` using Python's `datetime.weekday()`<br>2. Compute the number of rides by day of week using the custom UDF<br>3. Recompute the same distribution using Spark's native built-in `dayofweek` function | `udf(..., IntegerType())`, `.groupBy().count()`, `dayofweek()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
