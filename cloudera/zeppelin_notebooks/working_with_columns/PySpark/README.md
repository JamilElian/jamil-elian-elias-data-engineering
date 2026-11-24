## Lab Overview

The objective of this lab is to become familiar with Spark SQL's built-in column transformations and `pyspark.sql.functions` over the **DuoCar** datasets (`rides`, `drivers`, and `riders`) stored in HDFS. It demonstrates adding and replacing columns with `.withColumn()`, casting data types, parsing dates/timestamps, manipulating strings via regular expressions and Levenshtein distance, and combining Boolean filter expressions.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion setup, four guided column-type lessons (Examples 1–12), 7 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion | Read raw CSV files (`rides`, `drivers`, `riders`) from HDFS with automatic header and schema inference. | `spark.read.csv(..., header=True, inferSchema=True)` |
| **Lesson 1** | Numerical Columns (Ex. 1–3) | Convert ride distance from meters to miles, add vs. replace columns, format integer IDs as zero-padded strings, and convert integer flags to Booleans. | `col()`, `round()`, `.alias()`, `.withColumn()`, `format_string()`, `.cast("boolean")` |
| **Lesson 2** | String Columns (Ex. 4–6) | Normalize text by trimming whitespace and converting to uppercase, and extract Census Block Groups (12 digits) via slicing and regex. | `trim()`, `upper()`, `substring()`, `regexp_extract()` |
| **Lesson 3** | Date & Timestamp Columns (Ex. 7–9) | Cast timestamps to dates, parse formatted date strings into timestamps, and calculate rider age in years. | `.cast("date")`, `to_date()`, `.cast("timestamp")`, `to_timestamp()`, `current_date()`, `months_between()`, `floor()` |
| **Lesson 4** | Boolean Columns (Ex. 10–12) | Predefine reusable Boolean `Column` expressions, combine conditions with logical AND (`&`) and OR (`\|`), and handle three-valued (`null`) logic safely in filters. | `col("student") == 1`, `&`, `\|`, `.filter()`, `.distinct()` |
| **Lab Exercises** | **Steps 1 - 7** | 1. Extract `hour_of_day` and `day_of_week` from `rides.date_time`<br>2. Convert `rides.duration` from seconds to minutes<br>3. Cast `rides.cancelled` to a Boolean column<br>4. Create `five_star_rating` (`1.0`/`0.0`) using conditional logic<br>5. Concatenate `drivers` first and last names into `full_name`<br>6. Compute average driver `star_rating` (`stars / rides`)<br>7. Rank distinct rider first names by similarity to `"Brian"` | `hour()`, `dayofweek()`, `round()`, `.cast()`, `when().otherwise()`, `concat_ws()`, `lit()`, `levenshtein()`, `.sort()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
