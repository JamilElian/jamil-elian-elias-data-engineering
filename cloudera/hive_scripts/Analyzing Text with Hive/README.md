## Lab Overview

The objective of this lab is to become familiar with **Hive text processing features**. Using the `training_analyst` database populated with Dualcore datasets (`access.log`, `ratings_2018.txt`, `ratings_2019.txt`, and `products.txt`), the script walks through loading unstructured Apache-style access logs via `RegexSerDe`, identifying top search keywords, analyzing product rating distributions, and applying bigram/trigram text analysis (`NGRAMS` + `SENTENCES`) to uncover a product pricing discrepancy (`16GB USB Flash Drive (Red)`).

---

## Lab Workflow

The lab is structured into a cluster data-staging setup followed by four SQL stages:

| Stage | Steps | Operations Covered | Key Commands |
| :--- | :--- | :--- | :--- |
| **Environment Setup** | Prerequisites | Authenticate via Kerberos and upload local Dualcore files (`/var/tmp/dev/data/da/*`) to HDFS `/tmp/training/raw/`. | `kinit`, `hdfs dfs -put`, `hdfs dfs -mkdir`, `hdfs dfs -chmod` |
| **SQL Setup** | Database & Base Tables | Drop/recreate `training_analyst` and create/load the external `ratings` (2018 & 2019) and `products` tables. | `CREATE DATABASE`, `CREATE EXTERNAL TABLE`, `LOAD DATA INPATH` |
| **Part 1: Web Logs & Regex** | **Steps 1 - 3** | Create `web_logs` using `RegexSerDe` to parse IP, timestamp, HTTP request, status, bytes, referer, user agent, and session cookie; load `access.log` and extract the top 3 searched terms (`tablet`, `ram`, `wifi`). | `ROW FORMAT SERDE '...RegexSerDe'`, `REGEXP_EXTRACT()`, `REGEXP` |
| **Part 2: Numeric Ratings** | **Steps 4 - 6** | Inspect `ratings` schema and identify the highest- and lowest-rated products (`prod_id = 1274673`, avg `1.10`) among items with at least 50 reviews. | `DESCRIBE`, `AVG()`, `FORMAT_NUMBER()`, `GROUP BY ... ORDER BY` |
| **Part 3: Text Mining (N-Grams)** | **Steps 7 - 12** | Extract top 5 bigrams and trigrams from customer comments for `prod_id = 1274673`, filter reviews mentioning `'ten times more'` and `'red'`, and compare pricing against similar products in `products`. | `EXPLODE()`, `NGRAMS()`, `SENTENCES()`, `LOWER()`, `LIKE` |

---

## ⚙️ How to Run

### 1. Stage the Dualcore Datasets in HDFS (Cluster Terminal)
Before running the SQL script in Hue, upload the local source files to HDFS:

```bash
# Authenticate with Kerberos (if enabled in your cluster)
echo {password.global} | kinit {user.global}

# Prepare HDFS directories and upload raw files
hdfs dfs -mkdir -p /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/data/da/access.log /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/data/da/ratings_* /tmp/training/raw
hdfs dfs -put -f /var/tmp/dev/data/da/products.txt /tmp/training/raw
hdfs dfs -chmod -R 777 /tmp/training/raw

hdfs dfs -mkdir -p /tmp/training/dualcore
hdfs dfs -chmod -R 777 /tmp/training/dualcore
```

### 2. Execute the Hive SQL Script in Cloudera Hue
1. Open **Cloudera Hue** and navigate to the **Hive** query editor.
2. Paste the contents of `Analyzing Text with Hive.sql` and execute the blocks sequentially (`Ctrl + Enter`).
3. Verify in **Step 3** that the top three searched terms extracted from `web_logs` are `tablet` (303), `ram` (153), and `wifi` (148), and in **Step 12** that the red 16GB USB Flash Drive is priced at `42999` cents ($429.99) compared to `4299` cents ($42.99) for the other colors.
