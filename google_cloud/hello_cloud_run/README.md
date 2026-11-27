# Hello Cloud Run

## Overview

**Cloud Run** is a fully managed serverless compute platform on Google Cloud that executes stateless containers invocable via HTTP/HTTPS requests. It abstracts away infrastructure provisioning, handles automatic horizontal scaling (including scale-to-zero when idle), and bills strictly for compute and networking resources consumed during request handling.

In this lab (`ID: CBL333`), a lightweight **Node.js / Express** HTTP application is created, packaged into a Docker container image using **Cloud Build**, stored in **Artifact Registry**, verified locally in **Cloud Shell**, deployed publicly to **Cloud Run**, and finally cleaned up to prevent residual storage charges.

---

## Lab Objectives

* Enable the **Cloud Run** (`run.googleapis.com`) and **Artifact Registry** (`artifactregistry.googleapis.com`) APIs.
* Develop a stateless **Node.js** web application (`express`) listening on the `PORT` environment variable (`8080`).
* Create a regional Docker repository (`my-repository`) in **Artifact Registry** and configure Docker authentication.
* Containerize the application with a `Dockerfile` (`node:22-slim`), build/push the image via **Cloud Build**, and verify it locally in **Cloud Shell**.
* Deploy the container image to **Cloud Run** with public unauthenticated access (`--allow-unauthenticated`).
* Delete the container image from Artifact Registry and remove the Cloud Run service to avoid extra charges.

---

## Serverless CI/CD & Deployment Architecture

```text
[ Cloud Shell Source Code ] ──(gcloud builds submit)──▶ [ Cloud Build ]
 (package.json, index.js,                                     │
  Dockerfile)                                            (docker push)
                                                              ▼
[ Public HTTPS Endpoint ] ◀──(gcloud run deploy)──── [ Artifact Registry ]
 (*.us-central1.run.app)                               (my-repository/helloworld)
```

### Key Configuration & Resources

| Component | Identifier / Value | Details |
| :--- | :--- | :--- |
| **Compute Region** | `us-central1` (Iowa) | Configured via `gcloud config set compute/region us-central1` |
| **Application Runtime** | Node.js 22 (`node:22-slim`) + Express `^4.17.1` | Stateless HTTP server (`src/index.js`, `src/package.json`) |
| **Artifact Registry Repo** | `my-repository` (`docker` format) | `us-central1-docker.pkg.dev/<PROJECT_ID>/my-repository/helloworld` |
| **Cloud Run Service** | `helloworld` (Revision `helloworld-00001-d21`) | Public ingress (`--allow-unauthenticated`), serving 100% of traffic |

---

## Directory Structure

```text
hello_cloud_run/
├── screenshots/        # 41 step-by-step execution screenshots (.PNG)
├── src/
│   ├── Dockerfile      # Multi-step Node.js 22 container definition
│   ├── index.js        # Express HTTP server entrypoint
│   └── package.json    # Node.js manifest and dependencies
└── README.md           # Lab documentation and verification evidence
```

---

## 💻 Source Code (`src/`)

### `src/package.json`

```json
{
  "name": "helloworld",
  "description": "Simple hello world sample in Node",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "author": "Google LLC",
  "license": "Apache-2.0",
  "dependencies": {
    "express": "^4.17.1"
  }
}
```

### `src/index.js`

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  const name = process.env.NAME || 'World';
  res.send(`Hello ${name}!`);
});

app.listen(port, () => {
  console.log(`helloworld: listening on port ${port}`);
});
```

### `src/Dockerfile`

```dockerfile
# Use the official lightweight Node.js image.
# https://hub.docker.com/_/node
FROM node:22-slim

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
# If you add a package-lock.json, speed your build by switching to 'npm ci'.
# RUN npm ci --only=production
RUN npm install --only=production

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD [ "npm", "start" ]
```

---

## Step-by-Step Execution & Verification Evidence

### Setup & Cloud Shell Environment Verification

1. **Lab Initialization:** Started the **Hello Cloud Run** (`ID: CBL333`) lab environment and obtained temporary credentials (`Project ID: qwiklabs-gcp-02-7e17d89f1d31`).
   ![Lab Setup and Credentials](screenshots/01_lab_setup_and_credentials.PNG)

2. **GCP Account Welcome:** Accepted the initial Google Workspace/Cloud sandbox account notice.
   ![GCP Account Welcome](screenshots/02_gcp_account_welcome.PNG)

3. **Terms of Service Agreement:** Agreed to the Google Cloud Platform Terms of Service.
   ![GCP Terms of Service](screenshots/03_gcp_terms_of_service.PNG)

4. **Activating Cloud Shell:** Opened **Cloud Shell** from the top-right toolbar in Google Cloud Console.
   ![GCP Console Activate Cloud Shell](screenshots/04_gcp_console_activate_cloud_shell.PNG)

5. **Cloud Shell Provisioning Dialog:** Clicked **Continue** to initialize the Cloud Shell virtual environment.
   ![Cloud Shell Continue Dialog](screenshots/05_cloud_shell_continue_dialog.PNG)

6. **Authorizing Cloud Shell:** Granted Cloud Shell permissions to make authenticated Google Cloud API calls.
   ![Authorize Cloud Shell](screenshots/06_authorize_cloud_shell.PNG)

7. **Listing Active Credentials:** Executed `gcloud auth list` to inspect the active account.
   ![gcloud auth list Command](screenshots/07_gcloud_auth_list_command.PNG)

8. **Active Account Verified:** Confirmed `student-01-0d573b7800d1@qwiklabs.net` as the active credentialed account.
   ![gcloud auth list Output](screenshots/08_gcloud_auth_list_output.PNG)

9. **Checking Project Configuration:** Executed `gcloud config list project` in Cloud Shell.
   ![gcloud config list project Command](screenshots/09_gcloud_config_list_project_command.PNG)

10. **Project ID Verified:** Confirmed `project = qwiklabs-gcp-02-7e17d89f1d31`.
    ![gcloud config list project Output](screenshots/10_gcloud_config_list_project_output.PNG)

---

### Task 1 & Task 2: Enable APIs & Build the Sample Node.js Application

11. **Enabling Required APIs:** Ran `gcloud services enable run.googleapis.com artifactregistry.googleapis.com`.
    ![Enable Cloud Run and Artifact Registry APIs](screenshots/11_enable_cloud_run_artifact_registry_apis.PNG)

12. **Setting Default Compute Region:** Configured `us-central1` via `gcloud config set compute/region us-central1`.
    ![Set Compute Region us-central1](screenshots/12_set_compute_region_us_central1.PNG)

13. **Defining Location Variable:** Exported `LOCATION="us-central1"` for subsequent CLI commands.
    ![Export LOCATION Environment Variable](screenshots/13_export_location_env_variable.PNG)

14. **Creating Application Directory:** Executed `mkdir helloworld && cd helloworld`.
    ![mkdir and cd helloworld Command](screenshots/14_mkdir_cd_helloworld_command.PNG)

15. **Working Directory Verified:** Confirmed current path `~/helloworld` in Cloud Shell.
    ![Inside helloworld Directory](screenshots/15_inside_helloworld_directory.PNG)

16. **Creating `package.json`:** Opened `nano package.json` to define project metadata and dependencies.
    ![nano package.json Command](screenshots/16_nano_package_json_command.PNG)

17. **Editing `package.json`:** Added the `start` script (`node index.js`) and `express` (`^4.17.1`) dependency.
    ![package.json Content in nano](screenshots/17_package_json_content_nano.PNG)

18. **Creating `index.js`:** Opened `nano index.js` to write the HTTP server code.
    ![nano index.js Command](screenshots/18_nano_index_js_command.PNG)

19. **Editing `index.js`:** Implemented the Express GET handler returning `"Hello World!"` on port `8080`.
    ![index.js Content in nano](screenshots/19_index_js_content_nano.PNG)

---

### Task 3: Create an Artifact Registry Repository

20. **Creating Docker Repository:** Executed `gcloud artifacts repositories create my-repository --repository-format=docker --location=$LOCATION --description="Docker repository"`.
    ![Create Artifact Registry Repo Command](screenshots/20_create_artifact_registry_repo_command.PNG)

21. **Configuring Docker Authentication:** Confirmed repository creation and ran `gcloud auth configure-docker $LOCATION-docker.pkg.dev`.
    ![Configure Docker for Artifact Registry](screenshots/21_configure_docker_artifact_registry.PNG)

22. **Task 3 Checkpoint Verified:** Validated **Create an Artifact Registry repository** (*Assessment Completed!*).
    ![Task 3 Checkpoint Verified](screenshots/22_task3_checkpoint_verified.PNG)

---

### Task 4: Containerize the Application & Upload to Artifact Registry

23. **Creating `Dockerfile`:** Confirmed credential helper registration and opened `nano Dockerfile`.
    ![nano Dockerfile Command](screenshots/23_nano_dockerfile_command.PNG)

24. **Editing `Dockerfile`:** Defined the container build steps using `node:22-slim`, `npm install --only=production`, and `CMD [ "npm", "start" ]`.
    ![Dockerfile Content in nano](screenshots/24_dockerfile_content_nano.PNG)

25. **Building & Pushing Image with Cloud Build:** Executed `gcloud builds submit --tag $LOCATION-docker.pkg.dev/qwiklabs-gcp-02-7e17d89f1d31/my-repository/helloworld`.
    ![gcloud builds submit Command](screenshots/25_gcloud_builds_submit_command.PNG)

26. **Cloud Build Success & Local Container Command:** Verified `STATUS: SUCCESS` (digest `sha256:98544ad0...`) and prepared `docker run -d -p 8080:8080`.
    ![Cloud Build Success and docker run Command](screenshots/26_cloud_build_success_docker_run_cmd.PNG)

27. **Running Container Locally in Cloud Shell:** Pulled the newly built image from Artifact Registry and started the detached container on port `8080`.
    ![docker run Container Started](screenshots/27_docker_run_container_started.PNG)

28. **Opening Cloud Shell Web Preview:** Selected **Preview on port 8080** from the Web preview menu.
    ![Cloud Shell Web Preview 8080](screenshots/28_cloud_shell_web_preview_8080.PNG)

29. **Local Container Response Verified:** Confirmed `"Hello World!"` rendered in the browser preview window.
    ![Web Preview Hello World Output](screenshots/29_web_preview_hello_world_output.PNG)

30. **Task 4 Checkpoint Verified:** Validated **Containerize your app and upload it to Artifact Registry** (*Assessment Completed!*).
    ![Task 4 Checkpoint Verified](screenshots/30_task4_checkpoint_verified.PNG)

---

### Task 5: Deploy to Cloud Run

31. **Deploying Service to Cloud Run:** Executed `gcloud run deploy helloworld` with `--allow-unauthenticated` in `us-central1`.
    ![gcloud run deploy Command](screenshots/31_gcloud_run_deploy_command.PNG)

32. **Cloud Run Deployment Succeeded:** Revision `helloworld-00001-d21` deployed and serving 100% of traffic at `https://helloworld-966563617428.us-central1.run.app`.
    ![Cloud Run Deploy Success and Service URL](screenshots/32_cloud_run_deploy_success_url.PNG)

33. **Public HTTPS Endpoint Verified:** Opened the live Cloud Run URL in a browser tab and confirmed the `"Hello World!"` response.
    ![Cloud Run Service URL Browser Output](screenshots/33_cloud_run_service_url_browser_output.PNG)

34. **Navigating to Cloud Run in Console:** Opened **Cloud Run** from the Google Cloud Console navigation menu.
    ![GCP Navigation Menu Cloud Run](screenshots/34_gcp_navigation_menu_cloud_run.PNG)

35. **Inspecting Cloud Run Overview:** Confirmed the active `helloworld` service listed under `us-central1`.
    ![Cloud Run Overview helloworld Listed](screenshots/35_cloud_run_overview_helloworld_listed.PNG)

36. **Task 5 Checkpoint Verified:** Validated **Deploy a containerized application on Cloud Run** (*Assessment Completed!*).
    ![Task 5 Checkpoint Verified](screenshots/36_task5_checkpoint_verified.PNG)

---

### Task 6: Clean Up Resources

37. **Deleting Artifact Registry Image:** Ran `gcloud artifacts docker images delete $LOCATION-docker.pkg.dev/qwiklabs-gcp-02-7e17d89f1d31/my-repository/helloworld`.
    ![Delete Artifact Registry Image Command](screenshots/37_delete_artifact_registry_image_cmd.PNG)

38. **Confirming Image Deletion:** Entered `Y` to delete all tags and image layers from Artifact Registry.
    ![Confirm Delete Artifact Registry Image](screenshots/38_confirm_delete_artifact_registry_image.PNG)

39. **Deleting Cloud Run Service:** Verified image removal and ran `gcloud run services delete helloworld --region=us-central1`.
    ![Delete Cloud Run Service Command](screenshots/39_delete_cloud_run_service_cmd.PNG)

40. **Confirming Service Deletion:** Entered `Y` to permanently delete the `helloworld` Cloud Run service.
    ![Confirm Delete Cloud Run Service](screenshots/40_confirm_delete_cloud_run_service.PNG)

41. **Lab Completion:** Completed all objectives with a final score of **100 / 100**.
    ![Lab Completed Score 100/100](screenshots/41_lab_completed_score_100_100.PNG)
