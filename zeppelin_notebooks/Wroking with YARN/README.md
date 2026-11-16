## Lab Overview

The goal of this exercise is to understand how YARN manages cluster resources, allocates containers across worker nodes, and tracks application states. Instead of focusing on application logic, the lab uses a provided PySpark word-count script (`wordcount.py`) running over Loudacre's customer service Knowledge Base dataset to observe live and historical job metrics.

---

## Lab Workflow & Covered Operations

The notebook walks through four core stages:

| Section | Step | Task / Operation | Key Command / Interface |
| :--- | :--- | :--- | :--- |
| **Setup** | — | Create the root `/devsh_loudacre` directory in HDFS. | `hdfs dfs -mkdir /devsh_loudacre` |
| **Explore Cluster** | **1 - 4** | Inspect the cluster "at rest" in the YARN Resource Manager UI (Cluster Overview, Leaf Queues, Nodes tab) and check worker node memory in the Node Manager UI. | Resource Manager UI (`:8088`) & Node Manager UI (`:8042`) |
| **Submit App** | **5 - 6** | Upload the Knowledge Base dataset (`kb`) to HDFS and submit the PySpark `wordcount.py` job to the YARN cluster (suppressing `stderr` logs for clean output). | `hdfs dfs -put .../kb /devsh_loudacre/`<br>`spark-submit .../wordcount.py /devsh_loudacre/kb/* 2>/dev/null` |
| **Monitor (Web UI)** | **7 - 9** | Track the running application in the RM Applications tab and inspect allocated containers on the worker node via the Node Manager UI. | YARN RM & NM Web UIs |
| **Monitor (CLI)** | **10 - 11** | List all running and completed YARN applications and query detailed status reports using the Application ID. | `yarn application -list -appStates ALL`<br>`yarn application -status <app-id>` |

---

## Additional tools

* **Apache Hadoop YARN:** Cluster resource management and job scheduling framework.
* * **Web Interfaces:**
  * **Resource Manager (RM) UI:** `http://localhost:8088/`
  * **Node Manager (NM) UI:** `http://localhost.localdomain:8042/`

---

## Additional files

Verify that the exercise files exist locally at `/home/training/training_materials/dev/exercises/yarn/wordcount.py` and `/home/training/training_materials/dev/data/kb`
