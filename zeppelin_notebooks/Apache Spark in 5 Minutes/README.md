# Apache Spark in 5 minutes

## Dataset Overview (`svepisodes.json`)

The JSON file stores detailed metadata for each episode fetched from the TVmaze API. The primary columns available are:

| Column | Data Type | Description |
| :--- | :--- | :--- |
| **Airdate** | String | Date when an episode was aired |
| **Airstamp** | String | Timestamp when an episode was aired |
| **Airtime** | String | Length of actual episode airtime (excluding commercials) |
| **Id** | String / Int | Unique show episode ID |
| **Name** | String | Title or name of an episode |
| **Number** | String / Int | Episode number within the season |
| **Runtime** | String / Int | Total length of an episode (including commercials) |
| **Season** | String / Int | Show season |
| **Summary** | String | Brief summary or synopsis of an episode |
| **Url** | String | URL where more information is available online about an episode[cite: 1] |

---

## Project Workflow

The analysis inside the notebook follows these core steps:

1. **Data Ingestion:** Fetches the JSON payload directly from the TVmaze API and writes it to HDFS using Hadoop's `FileSystem` API.
2. **Loading into a Spark DataFrame:** Reads the JSON file from HDFS into a DataFrame while automatically inferring its schema and data types.
3. **Schema & Data Inspection:** Displays the hierarchical tree structure using `printSchema()` and previews tabular records with `show()`.
4. **Temporary Views & Spark SQL:** Registers the DataFrame as an in-memory temporary view (`svepisodes`) to run SQL queries (such as total episode counts and episode distribution per season).
5. **Basic Text Processing (Word Count):**
   * Extracts individual words from the `summary` column.
   * Normalizes text to lowercase and filters out common stop words and punctuation marks.
   * Aggregates and sorts word occurrences to highlight the most frequent characters and terms (e.g., *Richard*, *Pied Piper*, *Dinesh*, *Erlich*, *Gavin*, and *Jared*).
