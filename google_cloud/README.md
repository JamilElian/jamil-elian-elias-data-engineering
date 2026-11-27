# Google Cloud Platform (GCP) Data Engineering Labs

Welcome! This directory contains hands-on labs, cloud architectures, and data engineering workflows built on **Google Cloud Platform (GCP)**.

## Tech Stack & Cloud Services

* **Compute & Infrastructure:** Compute Engine, Cloud Run, Google Cloud Marketplace, Infrastructure Manager, Cloud Shell (`gcloud` CLI)
* **Storage & Managed Databases:** Cloud Storage (`gcloud storage` / `gsutil`), Cloud SQL for MySQL 8.4
* **Containers & CI/CD:** Docker, Artifact Registry, Cloud Build, Node.js / Express
* **Networking & Security:** VPC Networks (Auto/Custom Modes), External IP Routing, VPC Firewall Rules, Cloud SQL Authorized Networks, Object ACLs
* **Application Stacks:** Linux (Ubuntu / Debian 12 bookworm), Apache HTTP Server, MySQL, PHP (PDO)[cite: 64]

## Repository Structure

```text
google_cloud/
├── get_started_with_virtual_private_cloud_networking_and_compute_engine/   # Custom VPC, multi-region VMs & firewall rules
├── google_cloud_fundamentals/
│   ├── getting_started_with_cloud_marketplace/                             # Deploying a LAMP stack on Compute Engine via Cloud Marketplace
│   └── getting_started_with_cloud_storage_and_cloud_sql/                   # Apache/PHP VM + Cloud Storage + Cloud SQL integration
├── hello_cloud_run/                                                        # Containerized Node.js app on Cloud Run
└── README.md                                                               # Google Cloud labs overview and index
```

## Labs Summary

### Google Cloud Fundamentals (`google_cloud_fundamentals/`)

* **Getting Started with Cloud Marketplace (`getting_started_with_cloud_marketplace/`):** Provisioned and deployed a turnkey **LAMP stack** (Linux, Apache, MySQL, PHP, phpMyAdmin) onto an `e2-medium` **Compute Engine** VM (`lamp-1-vm`) using **Google Cloud Marketplace** and **Infrastructure Manager**, verifying public HTTP connectivity via its external IPv4 address.
* **Getting Started with Cloud Storage and Cloud SQL (`getting_started_with_cloud_storage_and_cloud_sql/`):** Deployed a Debian 12 **Compute Engine** web server (`bloghost`) running **Apache + PHP** (fixing the initial startup script with `apt-get update` so Apache installed properly), hosted a publicly readable banner image in a multi-regional **Cloud Storage** bucket (`US`), provisioned a **Cloud SQL for MySQL 8.4** instance (`blog-db`) with an authorized CIDR network (`/32`), and integrated both services inside `index.php` via PHP PDO.

### Compute, Networking & Serverless (`google_cloud/`)

* **Get Started with Virtual Private Cloud Networking and Compute Engine (`get_started_with_virtual_private_cloud_networking_and_compute_engine/`):** Inspected and deleted the `default` VPC network to demonstrate Compute Engine network dependencies, built an auto-mode VPC (`mynetwork`), deployed VMs across `asia-east1` and `us-central1`, and validated internal/external ICMP and SSH traffic behavior by progressively removing firewall rules (`allow-icmp`, `allow-custom`, `allow-ssh`).
* **Hello Cloud Run (`hello_cloud_run/`):** Built a stateless **Node.js / Express** HTTP service, containerized it with **Cloud Build**, pushed the image to **Artifact Registry**, tested it locally in **Cloud Shell**, deployed it publicly to **Cloud Run**, and cleaned up all deployed artifacts.
