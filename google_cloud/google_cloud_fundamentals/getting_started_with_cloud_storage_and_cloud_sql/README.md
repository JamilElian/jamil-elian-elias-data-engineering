# Google Cloud Fundamentals: Getting Started with Cloud Storage and Cloud SQL

## Overview

This lab demonstrates how to integrate three core Google Cloud infrastructure and data services—**Compute Engine**, **Cloud Storage**, and **Cloud SQL**—to host a dynamic PHP web application. A Debian virtual machine (`bloghost`) runs an **Apache + PHP** web front end that renders static media assets served directly from a multi-regional **Cloud Storage** bucket while authenticating and querying a managed **Cloud SQL for MySQL** database instance (`blog-db`) over an authorized public IP network.

---

## Lab Objectives

* Provision an `e2-standard-2` **Compute Engine** VM instance (`bloghost`) in `us-west1-c` with HTTP firewall access enabled and an automated startup script installing Apache and PHP.
* Create a multi-regional **Cloud Storage** bucket (`US`) named after the Google Cloud Project ID and configure public read ACLs (`allUsers:R`) on a static banner image (`my-excellent-blog.png`).
* Deploy a managed **Cloud SQL for MySQL 8.4** instance (`blog-db`) in `us-west1-c`, create an application user (`blogdbuser`), and authorize the VM's external IPv4 address (`/32`).
* Configure `/var/www/html/index.php` on `bloghost` to establish a PHP **PDO** connection to `blog-db` and render the public banner object from **Cloud Storage**.

---

## Cloud Architecture & Connectivity Matrix

```text
                        ┌──────────────────────────────────────────────┐
                        │           Google Cloud Storage (US)          │
                        │     gs://qwiklabs-gcp-00-dca3a7442e4c/       │
                        │           my-excellent-blog.png              │
                        └──────────────────────▲───────────────────────┘
                                               │ HTTPS (Public ACL: allUsers:R)
                                               │
[ Client Browser ] ──(HTTP :80)──▶ [ Compute Engine: bloghost ] ──(TCP :3306 / PDO)──▶ [ Cloud SQL: blog-db ]
                                    IP: 136.87.83.235 (us-west1-c)                      IP: 35.252.130.241 (us-west1-c)
                                    Apache2 + PHP 8.2 + php-mysql                       Authorized CIDR: 136.87.83.235/32
```

### Resource & Network Summary

| Component | Resource Name / ID | Region / Zone | Network & Security Configuration |
| :--- | :--- | :--- | :--- |
| **Web Server VM** | `bloghost` (`e2-standard-2`, Debian 12) | `us-west1-c` | Internal IP: `10.138.0.2` \| External IP: `136.87.83.235` \| Tag: `http-server` (TCP `:80` open) |
| **Object Storage** | `gs://qwiklabs-gcp-00-dca3a7442e4c` | Multi-region `US` | Standard class \| Object `my-excellent-blog.png` with `allUsers:R` ACL |
| **Managed Database** | `blog-db` (MySQL `8.4.13`, Enterprise Sandbox) | `us-west1-c` | Public IP: `35.252.130.241` \| Authorized Network: `web front end` (`136.87.83.235/32`) |
| **Database User** | `blogdbuser` (`cloudsqlsuperuser`) | Instance-wide (`%`) | Built-in MySQL authentication used by PHP PDO |

### Connectivity & Troubleshooting Impact Matrix

| Scenario / Configuration State | HTTP Access (`:80`) | MySQL PDO Connection (`:3306`) | Observed Application Behavior |
| :--- | :--- | :--- | :--- |
| **Initial lab startup script** (missing `apt-get update`) | ❌ Failed (Apache not installed) | N/A | Package index out of date on fresh Debian 12 image; resolved by prepending `sudo apt-get update &&` (Step 15) |
| **Placeholder `$dbserver = "CLOUDSQLIP"`** in `index.php` | ✅ Active | ❌ DNS Resolution Error | `SQLSTATE[HY000] [2002] php_network_getaddresses: getaddrinfo for CLOUDSQLIP failed` (Step 51) |
| **Actual Cloud SQL IP (`35.252.130.241`) + Authorized CIDR** | ✅ Active | ✅ Connected | Displays `"Connected successfully"` along with the Cloud Storage banner image (Step 62) |

---

## Directory Structure

```text
getting_started_with_cloud_storage_and_cloud_sql/
├── screenshots/        # 63 step-by-step execution screenshots (.PNG)
├── src/
│   ├── index.html      # Apache/PHP front end integrating Cloud SQL (PDO) and Cloud Storage
│   └── startup.sh      # Corrected VM startup script installing Apache2, PHP, and php-mysql
└── README.md           # Lab documentation, architecture summary, and evidence
```

---

## Source Code (`src/`)

### `src/startup.sh`

```bash
#!/bin/bash
sudo apt-get update && apt-get install apache2 php php-mysql -y
service apache2 restart
```

### `src/index.html`

```html
<html>
<head><title>Welcome to my excellent blog</title></head>
<body>
<h1>Welcome to my excellent blog</h1>
<img src='[https://storage.googleapis.com/qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png](https://storage.googleapis.com/qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png)'>
<?php
 $dbserver = "35.252.130.241";
 $dbuser = "blogdbuser";
 $dbpassword = "Passw0rd1!";
// In a production blog, we would not store the MySQL
// password in the document root. Instead, we would store
//  it in a Secret Manger. For more information see
// [https://cloud.google.com/sql/docs/postgres/use-secret-manager](https://cloud.google.com/sql/docs/postgres/use-secret-manager)

 try {
  $conn = new PDO("mysql:host=$dbserver;dbname=mysql", $dbuser, $dbpassword);
  // set the PDO error mode to exception
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  echo "Connected successfully";
} catch(PDOException $e) {
  echo "Database connection failed:: " . $e->getMessage();
}

?>
</body></html>
```

---

## Step-by-Step Execution & Verification Evidence

### Setup & Console Initialization

1. **Lab Initialization:** Started **Google Cloud Fundamentals: Getting Started with Cloud Storage and Cloud SQL** and retrieved temporary credentials (`Project ID: qwiklabs-gcp-00-dca3a7442e4c`).
   ![Lab Setup and Credentials](screenshots/01_lab_setup_and_credentials.PNG)

2. **GCP Account Welcome:** Accepted the initial sandbox account notice (**I understand**).
   ![GCP Account Welcome](screenshots/02_gcp_account_welcome.PNG)

3. **Terms of Service Agreement:** Accepted the Google Cloud Platform Terms of Service (**Agree and continue**).
   ![GCP Terms of Service](screenshots/03_gcp_terms_of_service.PNG)

---

### Task 1 & Task 2: Deploy the Web Server VM Instance (`bloghost`)

4. **Navigating to Compute Engine:** Opened **Compute Engine > VM instances** from the navigation menu.
   ![GCP Navigation Compute Engine VM Instances](screenshots/04_gcp_navigation_compute_engine_vm_instances.PNG)

5. **Starting VM Creation:** Clicked **Create instance** on the VM instances page.
   ![VM Instances Create Instance Button](screenshots/05_vm_instances_create_instance_button.PNG)

6. **Configuring Instance Name & Location:** Set name to `bloghost`, region to `us-west1 (Oregon)`, and zone to `us-west1-c`.
   ![VM Config Name Region Zone](screenshots/06_vm_config_name_region_zone.PNG)

7. **Selecting Machine Type:** Selected series **E2** and preset machine type `e2-standard-2` (2 vCPU, 8 GB memory).
   ![VM Machine Type e2-standard-2](screenshots/07_vm_machine_type_e2_standard_2.PNG)

8. **Navigating to OS and Storage:** Confirmed the `e2-standard-2` selection and opened **OS and storage**.
   ![VM Navigate OS and Storage](screenshots/08_vm_navigate_os_and_storage.PNG)

9. **Verifying Boot Disk Image:** Confirmed **Debian GNU/Linux 12 (bookworm)** as the boot disk operating system.
   ![VM Verify OS Debian 12 Bookworm](screenshots/09_vm_verify_os_debian_12_bookworm.PNG)

10. **Navigating to Networking:** Switched to the **Networking** configuration tab.
    ![VM Navigate Networking](screenshots/10_vm_navigate_networking.PNG)

11. **Enabling HTTP Firewall Rule:** Checked **Allow HTTP traffic** (applying the `http-server` network tag).
    ![VM Networking Allow HTTP Traffic](screenshots/11_vm_networking_allow_http_traffic.PNG)

12. **Adding Initial Startup Script & Creating VM:** Entered the lab's default startup script under **Advanced > Automation** and clicked **Create**.
    ![VM Advanced Startup Script Create](screenshots/12_vm_advanced_startup_script_create.PNG)

13. **Recording VM IP Addresses:** Verified `bloghost` running in `us-west1-c` and noted its internal IP (`10.138.0.2`) and external IP (`136.87.83.235`).
    ![VM bloghost Running IPs Noted](screenshots/13_vm_bloghost_running_ips_noted.PNG)

14. **Task 2 Checkpoint Verified:** Validated **Deploy a web server VM instance** (*Assessment Completed!*).
    ![Task 2 Checkpoint Verified](screenshots/14_task2_checkpoint_verified.PNG)

15. **Manual Troubleshooting Adjustment (Not in Lab Guide):** Edited the `bloghost` instance configuration to prepend `sudo apt-get update &&` to the startup script (`#!/bin/bash sudo apt-get update && apt-get install apache2 php php-mysql -y`), ensuring local `apt` package lists were refreshed so **Apache2** and PHP installed properly.
    ![VM Edit Startup Script Fix Apache](screenshots/15_vm_edit_startup_script_fix_apache.PNG)

16. **Confirming Updated VM Configuration:** Saved the updated instance metadata/startup script and confirmed `bloghost` remained active in `us-west1-c`.
    ![VM bloghost Restarted Updated](screenshots/16_vm_bloghost_restarted_updated.PNG)

---

### Task 3: Create a Cloud Storage Bucket & Upload Public Asset

17. **Activating Cloud Shell:** Opened Cloud Shell and clicked **Continue** on the introductory dialog.
    ![Cloud Shell Continue Dialog](screenshots/17_cloud_shell_continue_dialog.PNG)

18. **Authorizing Cloud Shell:** Clicked **Authorize** to allow `gcloud` CLI operations.
    ![Authorize Cloud Shell](screenshots/18_authorize_cloud_shell.PNG)

19. **Exporting Bucket Location Variable:** Executed `export LOCATION=US` in Cloud Shell.
    ![Export LOCATION US Env Var](screenshots/19_export_location_us_env_var.PNG)

20. **Creating Cloud Storage Bucket:** Ran `gcloud storage buckets create -l US gs://qwiklabs-gcp-00-dca3a7442e4c`.
    ![Create Cloud Storage Bucket Command](screenshots/20_create_cloud_storage_bucket_cmd.PNG)

21. **Downloading Banner Image:** Copied `my-excellent-blog.png` from `gs://cloud-training/gcpfci/` into Cloud Shell.
    ![GCS Download Banner Image Command](screenshots/21_gcs_download_banner_image_cmd.PNG)

22. **Uploading Banner to Project Bucket:** Uploaded `my-excellent-blog.png` into `gs://qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png`.
    ![GCS Upload Banner to Project Bucket](screenshots/22_gcs_upload_banner_to_project_bucket.PNG)

23. **Setting Public Read ACL:** Executed `gsutil acl ch -u allUsers:R gs://qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png`.
    ![GCS Set Object Public ACL](screenshots/23_gcs_set_object_public_acl.PNG)

24. **Task 3 Checkpoint Verified:** Validated **Create a Cloud Storage bucket using the gcloud storage command line** (*Assessment Completed!*).
    ![Task 3 Checkpoint Verified](screenshots/24_task3_checkpoint_verified.PNG)

---

### Task 4: Create & Configure the Cloud SQL Instance (`blog-db`)

25. **Navigating to Cloud SQL:** Selected **Cloud SQL** from the Google Cloud Console navigation menu.
    ![GCP Navigation Cloud SQL](screenshots/25_gcp_navigation_cloud_sql.PNG)

26. **Starting Cloud SQL Creation:** Clicked **Create instance** on the Cloud SQL landing page.
    ![Cloud SQL Get Started Create Instance](screenshots/26_cloud_sql_get_started_create_instance.PNG)

27. **Choosing Database Engine:** Selected **Choose MySQL**.
    ![Cloud SQL Choose MySQL Engine](screenshots/27_cloud_sql_choose_mysql_engine.PNG)

28. **Selecting Edition & Preset:** Chose **Enterprise** edition with the **Sandbox** preset applied.
    ![Cloud SQL Edition Enterprise Sandbox](screenshots/28_cloud_sql_edition_enterprise_sandbox.PNG)

29. **Configuring Instance ID & Root Password:** Set Instance ID to `blog-db` (**MySQL 8.4**) and configured the `root` password (`Passw0rd1!`).
    ![Cloud SQL Instance ID Password](screenshots/29_cloud_sql_instance_id_password.PNG)

30. **Setting Region & Single Zone Availability:** Selected region `us-west1 (Oregon)`, **Single zone**, primary zone `us-west1-c`, and expanded **Show configuration options**.
    ![Cloud SQL Region Zone us-west1-c](screenshots/30_cloud_sql_region_zone_us_west1_c.PNG)

31. **Configuring SSL Security Mode:** Under **Security**, selected *Allow unencrypted network traffic* for lab connectivity testing.
    ![Cloud SQL Security Allow Unencrypted Traffic](screenshots/31_cloud_sql_security_allow_unencrypted_traffic.PNG)

32. **Creating the Cloud SQL Instance:** Clicked **Create instance** to provision `blog-db`.
    ![Cloud SQL Create Instance Button](screenshots/32_cloud_sql_create_instance_button.PNG)

33. **Instance Provisioned & Running:** Verified `blog-db` (MySQL 8.4.13) active in `us-west1`.
    ![Cloud SQL blog-db Running](screenshots/33_cloud_sql_blog_db_running.PNG)

34. **Recording Cloud SQL Public IP:** Noted the instance's public IPv4 address (`35.252.130.241`).
    ![Cloud SQL Public IP Address Noted](screenshots/34_cloud_sql_public_ip_address_noted.PNG)

35. **Navigating to Users:** Selected **Users** in the `blog-db` left navigation menu.
    ![Cloud SQL Navigate to Users](screenshots/35_cloud_sql_navigate_to_users.PNG)

36. **Opening Add User Dialog:** Clicked **Add user account**.
    ![Cloud SQL Users Add User Account Button](screenshots/36_cloud_sql_users_add_user_account_btn.PNG)

37. **Defining Application Database User:** Entered username `blogdbuser`, password `Passw0rd1!`, and host name `Allow any host (%)`.
    ![Cloud SQL Create blogdbuser Credentials](screenshots/37_cloud_sql_create_blogdbuser_credentials.PNG)

38. **Confirming User Creation:** Verified `cloudsqlsuperuser` role assignment and clicked **Add**.
    ![Cloud SQL Confirm Add blogdbuser](screenshots/38_cloud_sql_confirm_add_blogdbuser.PNG)

39. **User Added & Navigating to Connections:** Confirmed `blogdbuser` listed and navigated to **Connections**.
    ![Cloud SQL blogdbuser Added Navigate Connections](screenshots/39_cloud_sql_blogdbuser_added_navigate_connections.PNG)

40. **Adding Authorized Network:** Under **Connections > Networking**, clicked **Add a network**.
    ![Cloud SQL Connections Add Network Button](screenshots/40_cloud_sql_connections_add_network_btn.PNG)

41. **Authorizing Web Front End IP:** Named the network `web front end`, entered `136.87.83.235/32` (`bloghost` external IP), and clicked **Done** and **Save**.
    ![Cloud SQL Add Authorized Network web front end](screenshots/41_cloud_sql_add_authorized_network_web_front_end.PNG)

42. **Authorized Network Saved:** Verified `web front end (136.87.83.235/32)` saved on `blog-db`.
    ![Cloud SQL Authorized Network Saved](screenshots/42_cloud_sql_authorized_network_saved.PNG)

43. **Task 4 Checkpoint Verified:** Validated **Create the Cloud SQL instance** (*Assessment Completed!*).
    ![Task 4 Checkpoint Verified](screenshots/43_task4_checkpoint_verified.PNG)

---

### Task 5: Connect Compute Engine Application to Cloud SQL & Cloud Storage

44. **Returning to Compute Engine:** Navigated back to **Compute Engine > VM instances**.
    ![GCP Navigation Compute Engine VM Instances Task 5](screenshots/44_gcp_navigation_compute_engine_vm_instances_task5.PNG)

45. **Connecting via SSH:** Clicked **SSH** next to `bloghost` to open an SSH-in-browser terminal.
    ![VM bloghost SSH Connect Button](screenshots/45_vm_bloghost_ssh_connect_button.PNG)

46. **Navigating to Web Document Root:** Executed `cd /var/www/html` inside the `bloghost` SSH session.
    ![SSH bloghost cd /var/www/html](screenshots/46_ssh_bloghost_cd_var_www_html.PNG)

47. **Verifying Apache Service & Opening `index.php`:** Confirmed `apache2.service` was `active (running)` and opened `sudo nano index.php`.
    ![SSH Verify Apache Status Edit index.php](screenshots/47_ssh_verify_apache_status_edit_index_php.PNG)

48. **Writing Initial PHP PDO Script:** Added the HTML/PHP template with placeholder `CLOUDSQLIP` and `DBPASSWORD` values.
    ![nano index.php Database Connection Code](screenshots/48_nano_index_php_database_connection_code.PNG)

49. **Restarting Apache Web Server:** Executed `sudo service apache2 restart`.
    ![SSH Restart Apache2 After DB Config](screenshots/49_ssh_restart_apache2_after_db_config.PNG)

50. **Testing Initial Endpoint in Browser:** Opened `136.87.83.235/index.php` in an incognito browser tab.
    ![Browser Navigate bloghost index.php](screenshots/50_browser_navigate_bloghost_index_php.PNG)

51. **Verifying Expected Placeholder Error:** Confirmed the expected DNS error (`getaddrinfo for CLOUDSQLIP failed`) prior to inserting real credentials.
    ![Browser DB Connection Error Placeholder IP](screenshots/51_browser_db_connection_error_placeholder_ip.PNG)

52. **Reopening `index.php` via SSH:** Returned to SSH and ran `sudo nano index.php`.
    ![SSH Reopen index.php for Credentials](screenshots/52_ssh_reopen_index_php_for_credentials.PNG)

53. **Updating Database IP & Password:** Replaced placeholders with `$dbserver = "35.252.130.241"` and `$dbpassword = "Passw0rd1!"`.
    ![nano index.php Actual DB IP and Password](screenshots/53_nano_index_php_actual_db_ip_and_password.PNG)

54. **Restarting Apache Service:** Ran `sudo service apache2 restart` to apply the database credentials.
    ![SSH Restart Apache2 After Credentials](screenshots/54_ssh_restart_apache2_after_credentials.PNG)

55. **Database Connection Verified:** Refreshed `136.87.83.235/index.php` and confirmed `"Connected successfully"`.
    ![Browser Blog Connected Successfully](screenshots/55_browser_blog_connected_successfully.PNG)

56. **Navigating to Cloud Storage Buckets:** Opened **Cloud Storage > Buckets** in Google Cloud Console.
    ![GCP Navigation Cloud Storage Buckets](screenshots/56_gcp_navigation_cloud_storage_buckets.PNG)

57. **Selecting Project Bucket:** Clicked on bucket `qwiklabs-gcp-00-dca3a7442e4c`.
    ![Cloud Storage Buckets List Select Bucket](screenshots/57_cloud_storage_buckets_list_select_bucket.PNG)

58. **Copying Object Public URL:** Clicked **Copy URL** next to `my-excellent-blog.png` (`https://storage.googleapis.com/qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png`).
    ![GCS Bucket Details Copy Public URL](screenshots/58_gcs_bucket_details_copy_public_url.PNG)

59. **Reopening `index.php` to Embed Banner:** Executed `sudo nano index.php` in `/var/www/html`.
    ![SSH Reopen index.php Add Banner](screenshots/59_ssh_reopen_index_php_add_banner.PNG)

60. **Inserting Cloud Storage `<img>` Tag:** Added `<img src='https://storage.googleapis.com/qwiklabs-gcp-00-dca3a7442e4c/my-excellent-blog.png'>` below the main heading.
    ![nano index.php Insert GCS img Tag](screenshots/60_nano_index_php_insert_gcs_img_tag.PNG)

61. **Final Apache Restart:** Executed `sudo service apache2 restart`.
    ![SSH Restart Apache2 After Banner](screenshots/61_ssh_restart_apache2_after_banner.PNG)

62. **End-to-End Integration Verified:** Reloaded the web page and confirmed the Cloud Storage banner (*"My Excellent Blog"*) rendered alongside the active Cloud SQL connection (*"Connected successfully"*).
    ![Browser Blog Banner and DB Connected](screenshots/62_browser_blog_banner_and_db_connected.PNG)

63. **Lab Completion:** Completed all assessment checkpoints with a final score of **100 / 100**.
    ![Lab Completed Score 100 End](screenshots/63_lab_completed_score_100_end.PNG)
