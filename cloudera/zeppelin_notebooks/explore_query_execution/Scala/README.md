## Lab Overview

The objective of this lab is to understand how Apache Spark's Catalyst optimizer translates Scala DataFrame transformations into physical execution stages and how to correlate `explain(true)` output with the DAG visualizations in the **Spark UI**. Using the `devsh.accounts` Hive external table and the `/devsh_loudacre/accountdevice` CSV dataset, the notebook contrasts a single-stage scan/filter query against a multi-stage join query involving shuffle exchanges.

---

## Lab Workflow

The notebook is organized into a setup phase, two hands-on execution plan exercises, and a Livy session teardown:

| Stage | Steps | Operations Covered | Key Commands / Methods |
| :--- | :--- | :--- | :--- |
| **Setup** | Environment & Table Prep | Upload `accounts` and `accountdevice` files from `/home/training/...` to `/devsh_loudacre/` in HDFS and register the external `devsh.accounts` table. | `hdfs dfs -put -f`, `CREATE EXTERNAL TABLE devsh.accounts` |
| **Part 1: Single-Source Query** | **Steps 1 - 8** | Filter active accounts (`$"acct_close_dt".isNull`), inspect full logical/physical plans, trigger execution with `.show()`, and trace the single-stage `HiveTableScan` in the Spark UI (**SQL** and **Jobs** tabs). | `spark.read.table()`, `.select()`, `.where()`, `.explain(True)`, `.show()` |
| **Part 2: Multi-Source Join** | **Steps 9 - 11** | Read `/devsh_loudacre/accountdevice` CSV with schema inference, join with `activeAccountsDF` (`$"acct_num" === $"account_id"`), inspect the physical plan (`Exchange` / shuffle), and verify multi-stage execution in the Spark UI. | `spark.read.option(...).csv()`, `.join()`, `.explain(True)`, `.show()` |
| **Tear Down** | Cleanup | Terminate the active Apache Livy session via REST API. | `curl -s localhost:8998/sessions/$sessionId -X DELETE` |
