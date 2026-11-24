# Welcome to Zeppelin Notebooks!

During my course of "Cloudera Spark Big Data Developer", I did labs related to **Apache Zeppelin**.

In this file you will find them all! :)

## Description

* For each lab, there will be a **JSON File** and a **README.md File** as well. These 2 files will be inside of **Folder** with the name of the lab.

* The **README.md File** will have a sum up of the lab.

## Tech Stack

* **Hadoop HDFS:** Distributed file system for storing large datasets across clusters.
* **Apache Zeppelin:** Interactive notebook environment executing shell commands via the `%sh` interpreter and documentation via `%md`.

## How to run all notebooks

To replicate this analysis in your own cluster or compatible Spark/Zeppelin environment:

1. Ensure you have a working environment with **Hadoop / HDFS** and **Spark 2.x** configured (such as HDP 2.6+ or HDCloud).
2. Import the `NAME_OF_NOTEBOOK` notebook into Apache Zeppelin.
3. Additionally, add the necessary files (if required) to the directories specified for each lab to ensure the JSON file functions optimally. (Note: the README for each lab will specify which files are needed and where they should be added.)
4. Run the paragraphs sequentially (`Shift + Enter`) to download the dataset into HDFS, execute the transformations, and clean up the temporary file afterward.
