## Lab Overview

The objective of this lab is to understand how **Hive ACID transactions** work on ORC-backed tables using sample records from the **DC Comics** dataset. It contrasts **insert-only** transactional tables (`transactional_properties='insert_only'`) against **full ACID** transactional tables (`transactional='true'`), demonstrating multi-row inserts, row-level updates and deletes, transaction inspection (`SHOW TRANSACTIONS`), and minor delta compaction (`ALTER TABLE ... COMPACT 'minor'`).

---

## Lab Workflow

The SQL script is organized into three main stages following the lab guide:

| Stage | Steps | Operations Covered | Key Hive SQL Commands |
| :--- | :--- | :--- | :--- |
| **Setup** | Database Setup | Authenticate via Kerberos (if enabled) and create/select the `<USER>_dev` database. | `kinit`, `CREATE DATABASE`, `USE` |
| **Part 1: Insert-Only ACID** | **Steps 1 - 4** | Drop and create `dc_comics_acid_insert` with `insert_only` transactional properties, inspect schema, insert 3 records individually, and verify rows. | `CREATE TABLE ... STORED AS ORC TBLPROPERTIES`, `DESCRIBE`, `INSERT INTO ... VALUES` |
| **Part 2: Full ACID & DML** | **Steps 5 - 8** | Create `dc_comics_acid` with full ACID enabled, perform a multi-value insert, inspect transactions, execute row-level `DELETE` and `UPDATE`, and verify changes. | `INSERT INTO ... VALUES (...), (...)`, `SHOW TRANSACTIONS`, `DELETE FROM`, `UPDATE ... SET` |
| **Part 3: Compaction** | **Steps 9 - 10** | Trigger a manual minor compaction to merge delta directories and inspect the compaction queue status. | `ALTER TABLE ... COMPACT 'minor'`, `SHOW COMPACTIONS` |
