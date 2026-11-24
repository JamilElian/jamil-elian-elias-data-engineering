## Lab Overview

The objective of this lab is to become familiar with Spark SQL complex collection operations over the **DuoCar** datasets (`rides`, `drivers`, and `riders`) stored in HDFS. It demonstrates how to renormalize denormalized data into `ArrayType`, `MapType`, and `StructType` columns, retrieve nested elements via `.getItem()`, `map_values()`, or dot notation, flatten collections into rows with `explode`/`posexplode`, and serialize structs to JSON.

---

## Lesson & Lab Workflow

The notebook is structured into a data ingestion setup, three guided complex-type lessons, 3 hands-on lab exercises, and session cleanup:

| Section | Topic / Step | Operations Covered | Key Scala Methods & Functions |
| :--- | :--- | :--- | :--- |
| **Setup** | Data Ingestion | Read raw CSV files (`rides`, `drivers`, `riders`) from HDFS with header and schema options. | `spark.read.option(...).csv(...)` |
| **Lesson 1** | Arrays (`ArrayType`) | Combine `vehicle_make` and `vehicle_model` into an array, access elements by position, check length, sort elements, search values, and flatten rows with/without positions. | `array()`, `.getItem(0)`, `size()`, `sort_array()`, `array_contains()`, `explode()`, `posexplode()` |
| **Lesson 2** | Maps (`MapType`) | Build key-value maps (`make`, `model`) using literal keys, extract values by position, check map length, and explode key-value pairs. | `map()`, `lit()`, `map_values().getItem(0)`, `size()`, `explode()`, `posexplode()` |
| **Lesson 3** | Structs (`StructType`) | Construct named struct fields (`make`, `model`), inspect nested `Row` objects, access fields via dot notation (`"vehicle_struct.make"`), and serialize structs to JSON strings. | `struct()`, `.alias()`, `"vehicle_struct.make"`, `to_json()` |
| **Lab Exercises** | **Steps 1 - 3** | 1. Create `home_array` combining driver `home_lat` and `home_lon`<br>2. Create `name_map` mapping `"first"` and `"last"` keys to driver names<br>3. Create `name_struct` with named `first` and `last` fields and convert it to JSON | `array()`, `map()`, `lit()`, `struct()`, `to_json()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
