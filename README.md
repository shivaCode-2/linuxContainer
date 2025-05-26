# LabVIEW Container Beta
Welcome to the beta release of our containerized LabVIEW environment! This README provides instructions for getting started, running the container, and reporting feedback.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Running the Container](#running-the-container)
5. [Usage Examples](#usage-examples)
6. [Reporting Feedback](#reporting-feedback)
7. [Contributing](#contributing)
8. [Support](#support)

---
## Overview

This beta release offers two delivery modes for trying out our LabVIEW container:

1. **Automated CI Workflow**  
   Fork and explore the companion repo at https://github.com/shivaCode-2/linuxContainer. It includes a GitHub Actions pipeline that when a Pull Request is raised,  pulls the `labview_linux:2025q3_beta` image, runs LabVIEW CLI operations on sample VIs in the repo, and validates the results.

2. **Direct Image Access**  
   Pull and run the `labview_linux:2025q3_beta` image directly in your own environment. We will add you as a contributor on the private GitHub Package Registry so you can authenticate and download the image as needed.

Both options let you adapt the container to your workflows—either by extending the provided CI setup or integrating the image into your own processes.

## Prerequisites

- Docker Engine (version 20.10+)
- At least 8 GB RAM and 4 CPU cores available
- Internet connection for downloading the container image
- Git

## Installation
### Automated CI Workflow
Leverage this repository’s built-in GitHub Actions and helper scripts to run LabVIEWCLI commands inside a Docker container. The main components include:

#### Repo Structure

- **Test-VIs/**  
  A collection of sample VIs used by the CI pipeline for MassCompile and VI Analyzer tests. You can add, remove, or reorganize VIs here to include your own test cases.

- **runlabview.sh**  
  The entry-point script that invokes `labviewcli` inside the container. By default it runs:
  1. **MassCompile** on all VIs under `Test-VIs/`  
  2. **VIAnalyzer** against a predefined project  
  Feel free to extend or replace these commands to suit your workflows.

- **.github/workflows/vi-analyzer-container.yml**  
  Defines the GitHub Actions pipeline:
  1. **Authenticate** with GitHub Container Registry  
  2. **Pull** the `labview_linux:2025q3_beta` image  
  3. **Mount** the repository into the container  
  4. **Run** `runlabview.sh` and capture test results  
  5. **Report** pass/fail status back to the PR checks  

You can customize this workflow by adding jobs, adjusting environment variables, or changing the mounted volumes to match your use case.

#### How to Use This Repo for CI-Driven LabVIEWCLI Tests
1.  **Fork the repository**  
   - Visit: `https://github.com/shivaCode-2/linuxContainer`  
   - Click **Fork** to create your own copy.

2. **Clone your fork locally**  
   ```bash
   git clone https://github.com/<your-username>/linuxContainer.git
   cd linuxContainer
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b my-ci-test
   ```
   Make any changes you like—add or update VIs under Test-VIs/, tweak runlabview.sh, etc.

4. **Push your branch**
   ```bash
   git push origin my-ci-test
   ```

5. **Open a Pull Request**
   - In your fork on GitHub, click Compare & pull request.
   - Target branch: `shivaCode-2/linuxContainer:main`

6. **Watch the CI pipeline**

   The “Run VI Analyzer” workflow will automatically:
   - Authenticate to GHCR
   - Pull labview_linux:2025q3_beta
   - Mount your repo and execute runlabview.sh
   - Report pass/fail in the PR checks-

8. **Review results & iterate**
   - Click the Actions tab or PR checks to see logs.
   - Update your scripts or VIs, push new commits, and watch the workflow run again.

9. **Customize for your needs**
   - Modify runlabview.sh to add/remove CLI commands.
   - Edit `.github/workflows/vi-analyzer-container.yml` to adjust jobs, environment variables, or matrix settings.


### Direct Image Access
1. The image is currently privately hosted on GitHub container registry (ghcr.io)
2. To access the image, you need to be added as a contributor for the package. If you want to access this beta version, please mail your GitHub Username to shivang.sharma@emerson.com
3. Once you are added as a contributor, you can access and download the image.

#### How to get the image locally
1. Log into GitHub Container registry using the following command: docker login ghcr.io -u **your_username**
2. You will be prompted to enter the password. The password should be your Personal Access Token which atleast have the read priviledges.
3. Once login succeeds, you can download the image using this command: docker pull ghcr.io/shivacode-2/labview_linux:2025q3_beta
4. Once pulled, you can use the docker run command to start using the image. If you do not want to mount any directories or modify any network configuration, simply use the command docker run -it ghcr.io/shivacode-2/labview_linux:2025q3_beta and you would be dropped into the container's shell.
5. Once you are on the shell terminal, you can use LabVIEWCLI for operations like MassCompile, ExecuteBuildSpec etc.

## Example Usage

## FAQs
### 1. How do I get access to the private container image?  
You need to be added as a contributor on the GitHub Packages feed. Simply email your GitHub username to `shivang.sharma@emerson.com` and we’ll grant you “read” rights. Once added, log in and pull with:  
```bash
docker login ghcr.io -u <your-username>
docker pull ghcr.io/shivacode-2/labview_linux:2025q3_beta
```

### 2. Which LabVIEW versions are supported inside the container?
The beta image bundles LabVIEW 2025 Q3. CLI commands (labviewcli) will only work on VIs built for LabVIEW 2025 or earlier.

### 3. Can I add my own VIs to the CI workflow?
Yes. In your fork of linuxContainer, drop VIs into Test-VIs/ (or create subfolders), then update runlabview.sh with the new paths or operations. When you open a PR, the GitHub Action will run your tests automatically.

### 4. How do I customize the GitHub Actions workflow
Edit `.github/workflows/vi-analyzer-container.yml`:
1. Add or remove jobs under jobs
2. Change CLI commands in the runlabview.sh
3. Adjust mount points, environment variables, or matrix configurations as needed

### 5. What system resources does the container require?
We recommend at least 8 GB RAM and 4 CPU cores for smooth MassCompile or VI Analyzer runs. You can adjust Docker’s resource allocation in your Docker Desktop (or engine) settings.

### 6. Who should I contact for support or to report bugs?
1. Issues & feature requests: https://github.com/shivaCode-2/linuxContainer/issues
2. Direct support: email shivang.sharma@emerson.com


