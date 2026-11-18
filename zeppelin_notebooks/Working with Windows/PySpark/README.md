## Lab Overview

The objective of this lab is to become familiar with **Window specifications** and analytic window functions over the enhanced **DuoCar** dataset (`/duocar/joined/`) stored in HDFS. It covers row-frame boundaries (`unboundedPreceding` to `currentRow`), partitioned and ordered windows (`partitionBy`, `orderBy`), running totals, lag-based time-interval analysis between consecutive events, and analytical refinements for sparse trip counts.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion setup, two guided window-function examples, 1 hands-on lab exercise, and session cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion | Read the joined DuoCar Parquet dataset from HDFS. | `spark.read.parquet("/duocar/joined/")` |
| **Example 1** | Cumulative Count & Sum | Generate a synthetic range DataFrame, define an unbounded preceding row frame, and compute running counts and sums. | `spark.range()`, `Window.rowsBetween()`, `Window.unboundedPreceding`, `Window.currentRow`, `.over()` |
| **Example 2** | Average Days Between Rider Trips | Partition rides by `rider_id` ordered by `date_time`, retrieve the previous ride timestamp with `lag`, compute `datediff`, and rank top/bottom riders by average interval. | `Window.partitionBy().orderBy()`, `lag()`, `datediff()`, `.groupBy().agg()`, `mean()` |
| **Lab Exercise** | **Step 1** | Compute the average number of days between consecutive rides for each `driver_id` and list the busiest and least busy drivers. | `Window.partitionBy("driver_id").orderBy("date_time")`, `lag()`, `datediff()`, `mean()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
