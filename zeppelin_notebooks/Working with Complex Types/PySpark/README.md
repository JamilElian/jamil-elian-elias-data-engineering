## Lab Overview

The objective of this lab is to become familiar with Spark SQL complex collection operations over the **DuoCar** datasets (`rides`, `drivers`, and `riders`) stored in HDFS. It demonstrates how to renormalize denormalized data into `ArrayType`, `MapType`, and `StructType` columns, access nested elements via index or dot notation, explode collections into rows, and serialize structs to JSON.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion setup, three guided complex-type lessons, 3 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key PySpark Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion | Read raw CSV files (`rides`, `drivers`, `riders`) from HDFS with automatic header and schema inference. | `spark.read.csv(..., header=True, inferSchema=True)` |
| **Lesson 1** | Arrays (`ArrayType`) | Combine `vehicle_make` and `vehicle_model` into an array, access elements by index, check size, sort elements, search values, and flatten rows with/without positions. | `array()`, `col()[0]`, `size()`, `sort_array()`, `array_contains()`, `explode()`, `posexplode()`, `.alias()` |
| **Lesson 2** | Maps (`MapType`) | Build key-value maps (`make`, `model`) using literal keys, retrieve values via dot notation, check map length, and explode key-value pairs. | `create_map()`, `lit()`, `col("vehicle_map").make`, `size()`, `explode()`, `posexplode()` |
| **Lesson 3** | Structs (`StructType`) | Construct named struct fields (`make`, `model`), inspect nested `Row` objects, access fields via dot notation, and serialize structs to JSON strings. | `struct()`, `.alias()`, `col("vehicle_struct").make`, `to_json()` |
| **Lab Exercises** | **Steps 1 - 3** | 1. Create `home_array` combining driver `home_lat` and `home_lon`<br>2. Create `name_map` mapping `"first"` and `"last"` keys to driver names<br>3. Create `name_struct` with named `first` and `last` fields and convert it to JSON | `array()`, `create_map()`, `lit()`, `struct()`, `to_json()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
