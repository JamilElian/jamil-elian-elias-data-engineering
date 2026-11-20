## Lab Overview

The objective of this lab is to become familiar with **Spark operations using Hive** and understand table ownership, storage properties, and access boundaries between both engines. Using synthetic TPC-DS `customer` data generated via `dsdgen`, the notebook demonstrates that Spark-created tables default to external tables (`'TRANSLATED_TO_EXTERNAL'='TRUE'`) readable by both Spark and Hive, whereas Hive-created managed tables are transactional ORC (`ACID`) tables that Spark 3 cannot directly read—establishing the recommended **Spark Staging → Hive CTAS Production** workflow.

---

## Lab Workflow

The notebook is structured into a TPC-DS data setup, two comparative lesson sections, a hands-on staging-to-production exercise, and a Livy session teardown:

| Stage | Steps | Operations Covered | Key Commands / Methods |
| :--- | :--- | :--- | :--- |
| **Setup** | TPC-DS Data Generation | Generate TPC-DS scale-1 data locally using `dsdgen` and upload `customer.dat` to HDFS `/spark-perf/tpcds/customer`. | `./dsdgen -SCALE 1`, `hdfs dfs -put -f` |
| **Lesson Part 1** | Spark-Created Tables | Create `sparkdb`, register `customer_spark_external` and `customer_spark_managed` (CTAS), query both, and inspect `SHOW CREATE TABLE` (`'TRANSLATED_TO_EXTERNAL'='TRUE'`). | `CREATE EXTERNAL TABLE`, `SHOW CREATE TABLE` |
| **Lesson Part 2** | Hive-Managed ACID Tables | Create `hivedb.customer_hive_managed` via `%jdbc(hive)`, verify transactional ORC properties, test Spark read limitations (`AnalysisException` on ACID tables), and confirm Hive can query Spark-created tables. | `%jdbc(hive)`, `CREATE DATABASE hivedb`, `SHOW CREATE TABLE` |
| **Lab Exercise** | **Steps 1 - 6** | Build an end-to-end pipeline: create `staging` DB and external `staging.customer` table in Spark, then create `prod` DB and materialize the managed `prod.customer` table in Hive via CTAS. | `CREATE DATABASE staging`, `CREATE EXTERNAL TABLE customer`, `CREATE TABLE prod.customer AS SELECT * FROM staging.customer` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
