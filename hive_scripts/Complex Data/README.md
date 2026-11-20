## Lab Overview

The objective of this lab is to become familiar with **complex type column operations in Hive**. Using the `training_analyst` database populated with Dualcore customer loyalty data (`loyalty_data.txt`), the script walks through creating a pipe-delimited external table with custom collection (`,`) and map-key (`:`) terminators, querying `MAP` values (`phone['HOME']`), indexing zero-based `ARRAY` elements (`order_ids[2]`), accessing `STRUCT` attributes via dot notation (`order_value.total`), unnesting arrays with `EXPLODE` and `LATERAL VIEW`, and creating a Parquet copy (`loyalty_program_parquet`) for downstream Impala queries.

---

## Lab Workflow

The lab is structured into a cluster data-staging setup followed by three SQL stages:

| Stage | Steps | Operations Covered | Key Commands |
| :--- | :--- | :--- | :--- |
| **Environment Setup** | Prerequisites | Authenticate via Kerberos, inspect sample loyalty records, and upload `loyalty_data.txt` to HDFS `/tmp/training/raw/`. | `kinit`, `head`, `hdfs dfs -put`, `hdfs dfs -mkdir`, `hdfs dfs -chmod` |
| **SQL Setup** | Database Creation | Drop and recreate the `training_analyst` database and set it as the active schema. | `DROP DATABASE`, `CREATE DATABASE`, `USE` |
| **Part 1: Complex Types** | **Steps 1 - 6** | Create `loyalty_program` with custom delimiters (`|`, `,`, `:`), load `loyalty_data.txt`, query `phone['HOME']` (`408-555-4914`), fetch the 3rd order ID `order_ids[2]` (`5278505`), and retrieve `order_value.total` (`401874`) for customer `1200866`. | `CREATE EXTERNAL TABLE`, `MAP<K,V>`, `ARRAY<T>`, `STRUCT<...>`, `LOAD DATA INPATH` |
| **Part 2: Table-Generating Functions** | **Steps 7 - 8** | Unnest `order_ids` into individual rows for customer `1200866` using `EXPLODE`, and list `(cust_id, order_id)` pairs for customers with `order_value.avg > 90000` ($900) using `LATERAL VIEW EXPLODE`. | `EXPLODE()`, `LATERAL VIEW EXPLODE()` |
| **Part 3: Parquet Export** | **Optional** | Materialize `loyalty_program_parquet` stored as Parquet to enable querying complex types in Apache Impala. | `CREATE TABLE ... STORED AS PARQUET AS SELECT` |

---

## ⚙️ How to Run

### 1. Stage the Loyalty Dataset in HDFS (Cluster Terminal)
Before running the SQL script in Hue, inspect the raw file format and upload `loyalty_data.txt` to HDFS:

```bash
# Authenticate with Kerberos (if enabled in your cluster)
echo {password.global} | kinit {user.global}

# Inspect the structure and delimiters of the raw file
head /var/tmp/dev/data/da/loyalty_data.txt

# Prepare HDFS directories and upload loyalty_data.txt
hdfs dfs -mkdir -p /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/data/da/loyalty_data.txt /tmp/training/raw
hdfs dfs -chmod -R 777 /tmp/training/raw

hdfs dfs -mkdir -p /tmp/training/dualcore
hdfs dfs -chmod -R 777 /tmp/training/dualcore
```

### 2. Execute the Hive SQL Script in Cloudera Hue
1. Open **Cloudera Hue** and navigate to the **Hive** query editor.
2. Paste the contents of `DE_Labs_ComplexData.sql` and execute the blocks sequentially (`Ctrl + Enter`).
3. Verify the expected outputs for customer `1200866` across **Steps 4–6**: `408-555-4914` (`HOME` phone), `5278505` (third `order_ids` element), and `401874` (`order_value.total` in cents).
