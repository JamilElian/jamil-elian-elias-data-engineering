## Lab Overview

The objective of this lab is to become familiar with grouping, summarizing, and pivoting transformations over the enhanced **DuoCar** dataset (`/duocar/joined/`) stored in HDFS. It covers descriptive and bivariate statistics, distinct vs. approximate counts, collection aggregations, multidimensional rollups and cubes, cross-tabulations, and memory persistence management.

---

## Lesson & Lab Workflow

The notebook is structured into a memory persistence setup, three guided aggregation/grouping/pivoting lessons, 5 hands-on lab exercises, and resource cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion & Caching | Read the joined DuoCar Parquet dataset from HDFS and cache it in memory for repeated queries. | `spark.read.parquet()`, `.persist()` |
| **Lesson 1** | Aggregate Functions | Compute summary statistics, exact/approximate counts, unique sums, distribution moments, extremes, order-dependent values, correlations/covariances, and array collections. | `.describe()`, `.agg()`, `count()`, `countDistinct()`, `approx_count_distinct()`, `sum()`, `sumDistinct()`, `mean()`, `stddev()`, `variance()`, `skewness()`, `kurtosis()`, `min()`, `max()`, `first()`, `last()`, `corr()`, `covar_samp()`, `covar_pop()`, `collect_list()`, `collect_set()` |
| **Lesson 2** | Grouping Data | Aggregate metrics across single and multiple dimensions, and generate hierarchical or multidimensional subtotals with grouping identifiers. | `.groupBy()`, `.rollup()`, `.cube()`, `grouping()`, `grouping_id()` |
| **Lesson 3** | Pivoting Data | Build contingency tables and wide-format summaries across service tiers with single or multiple aggregate metrics. | `.crosstab()`, `.groupBy().pivot()`, `.agg()` |
| **Lab Exercises** | **Steps 1 - 5** | 1. Find DuoCar's top 10 riders by completed (non-cancelled) ride count<br>2. Find DuoCar's top 10 drivers by total distance driven<br>3. Compute the distribution of cancelled rides<br>4. Analyze `star_rating` distribution and verify missing ratings correlate with cancellations<br>5. Compute average `star_rating` per car `service` level | `.filter()`, `.groupBy()`, `.agg()`, `.orderBy()`, `.crosstab()`, `.mean()` |
| **Tear Down** | Cleanup | Unpersist the cached DataFrame from memory and terminate the active Apache Livy session via REST API. | `rides.unpersist()`, `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
