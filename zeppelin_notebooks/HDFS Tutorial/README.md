## Overview

Throughout this tutorial, you will learn how to navigate the HDFS directory hierarchy, upload and download files between the local filesystem and HDFS, inspect storage properties (block size and replication factor), and manage file deletions and Trash recovery[cite: 2].

---

## Covered Operations & Commands

The notebook walks through the following practical exercises:

| Category | Operations Covered | Key Commands Used |
| :--- | :--- | :--- |
| **Navigation & Listing** | Listing root (`/`), user directories (`/user`, `/user/training`, `/user/zeppelin`), default user paths, and recursive directory trees. | `hdfs dfs -ls`, `hdfs dfs -ls -R` |
| **Directory & File Creation** | Creating relative directories (`pruebas`) and uploading local files (`ratings_2018.txt`) into HDFS. | `hdfs dfs -mkdir`, `hdfs dfs -put` |
| **Cluster & File Properties** | Inspecting default block size (`dfs.blocksize` in bytes/MB), default replication factor (`dfs.replication`), and disk usage. | `hdfs getconf -confKey`, `hdfs dfs -du -h` |
| **Custom Storage Parameters** | Uploading a file (`ratings_2019.txt`) with custom replication factor (`2`) and custom block size (`64M`). | `hdfs dfs -D dfs.replication=2 -D dfs.blocksize=64M -put` |
| **Reading & Downloading** | Displaying file contents directly in the console and downloading files from HDFS to the local `/tmp/` directory. | `hdfs dfs -cat`, `hdfs dfs -get` |
| **Deletion & Trash Recovery** | Moving files/directories to HDFS `.Trash`, restoring files from `.Trash`, and bypassing Trash for permanent deletion. | `hdfs dfs -rm`, `hdfs dfs -mv`, `hdfs dfs -rm -skipTrash`, `hdfs dfs -rm -R` |
