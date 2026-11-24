## Lab Overview

The objective of this lab is to understand the separation between the local filesystem and the distributed HDFS namespace while performing standard file operations—such as navigating directories, uploading datasets, inspecting XML file contents, downloading folders, and cleaning up resources.

---

## Lab Workflow & Covered Commands

The notebook guides you through the following 10 practical exercises:

| Step | Task | HDFS / Shell Command |
| :--- | :--- | :--- |
| **Setup** | Clean up any previous `/devsh_loudacre` directory in HDFS and reset the local `downloads` folder. | `hdfs dfs -rm -r -f /devsh_loudacre` |
| **1 - 3** | **Explore HDFS Directories:** List the HDFS root (`/`), inspect `/user`, and check the user home directory (`/user/zeppelin`). | `hdfs dfs -ls /`, `hdfs dfs -ls /user` |
| **4** | **Create Directory:** Create the top-level `/devsh_loudacre` directory in HDFS. | `hdfs dfs -mkdir /devsh_loudacre` |
| **5 - 6** | **Upload Data:** Copy the local `activations` directory into HDFS and verify the uploaded files. | `hdfs dfs -put .../activations /devsh_loudacre/` |
| **7** | **Inspect File Content:** Stream the first 20 lines of an XML activation file (`2014-03.xml`) without downloading it. | `hdfs dfs -cat .../2014-03.xml \| head -n 20` |
| **8 - 9** | **Download Data:** Retrieve the `activations` directory from HDFS back to the local `/tmp/devsh_activations` path and verify its contents. | `hdfs dfs -get /devsh_loudacre/activations/ /tmp/devsh_activations` |
| **10** | **Clean Up:** Recursively remove the uploaded `activations` directory from HDFS. | `hdfs dfs -rm -r /devsh_loudacre/activations/` |

---

## Additional files

Confirm that the Loudacre training dataset exists at `/home/training/training_materials/dev/data/activations`
