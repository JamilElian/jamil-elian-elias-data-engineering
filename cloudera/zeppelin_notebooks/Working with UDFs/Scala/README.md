## Lab Overview

The objective of this lab is to learn how to extend Spark SQL with custom Scala logic over the raw **DuoCar** rides dataset (`/duocar/raw/rides/`) stored in HDFS. It demonstrates how to wrap native Scala functions with typed lambda expressions in `udf()`, contrast custom UDFs against built-in Spark SQL functions for optimal performance, and implement temporal (`java.sql.Timestamp`) and geospatial (Haversine formula) transformations.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion and casting setup, two guided UDF examples, 3 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key Scala Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion & Casting | Read the raw rides CSV file from HDFS and cast the `date_time` column to a Spark `TimestampType`. | `spark.read.option(...).csv()`, `.cast("timestamp")` |
| **Example 1** | Hour of Day Extraction | Define a Scala function using `java.sql.Timestamp` (`time.getHours`), register it via typed lambda in `udf()`, apply it to `date_time`, and aggregate ride counts by hour. | `udf((dt: Timestamp) => ...)`, `.select()`, `.groupBy().count()`, `.orderBy()` |
| **Example 2** | Great-Circle Distance | Implement the Haversine formula in Scala (`Math` library), register it as a multi-argument `udf()`, calculate straight-line distances between origin and destination coordinates, and compare them against recorded ride `distance`. | `udf((lat1: Double, ...) => ...)`, `.withColumn()`, `.filter()` |
| **Lab Exercises** | **Steps 1 - 3** | 1. Define and register `day_of_week_udf` using `java.sql.Timestamp.getDay`<br>2. Compute the number of rides by day of week using the custom UDF<br>3. Recompute the same distribution using Spark's native built-in `dayofweek` function | `udf((t: Timestamp) => ...)`, `.groupBy().count()`, `dayofweek()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
