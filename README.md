# LabVIEW Container Beta
Welcome to the beta release of our containerized LabVIEW environment! This README provides instructions for getting started, running the container, and reporting feedback.

---
## Table of Contents

- [Overview](#overview)  
- [Prerequisites](#prerequisites)  
- [Installation](#installation)  
  - [Private Registry](#private-registry)  
  - [Request Access](#request-access)  
  - [Authenticate & Pull](#authenticate--pull)  
  - [Run the Container (Interactive Shell)](#run-the-container-interactive-shell)  
  - [Run LabVIEWCLI Operations](#run-labviewcli-operations)  
- [Example Usage](#example-usage)  
  - [Pulling in the image](#pulling-in-the-image)  
  - [Running the image in interactive mode](#running-the-image-in-interactive-mode)  
  - [Executing MassCompile using LabVIEWCLI](#executing-masscompile-using-labviewcli)  
  - [Integration with CI/CD workflows](#example-use-case-for-automated-ci-workflow)  
      - [Repo Structure](#repo-structure)  
      - [Integrating LabVIEWCLI Tests into Your CI Pipeline (Example)](#integrating-labviewcli-tests-into-your-ci-pipeline-example)  
- [FAQs](#faqs)  
  - [1. How do I get access to the private container image?](#1-how-do-i-get-access-to-the-private-container-image)  
  - [2. Which LabVIEW versions are supported inside the container?](#2-which-labview-versions-are-supported-inside-the-container)  
  - [3. Can I add my own VIs to the CI workflow?](#3-can-i-add-my-own-vis-to-the-ci-workflow)  
  - [4. How do I customize the GitHub Actions workflow?](#4-how-do-i-customize-the-github-actions-workflow)  
  - [5. What system resources does the container require?](#5-what-system-resources-does-the-container-require)  
  - [6. Who should I contact for support or to report bugs?](#6-who-should-i-contact-for-support-or-to-report-bugs)  
- [Licensing Agreement](#licensing-agreement)  


## Overview
Pull and run the `labview_linux:2025q3_beta` image directly in your own environment. We will add you as a contributor on the private GitHub Package Registry so you can authenticate and download the image as needed.

## Prerequisites
- Docker Engine (version 20.10+)
- At least 8 GB RAM and 4 CPU cores available
- Internet connection for downloading the container image
- Git

## Installation
1. **Private Registry**  
   The LabVIEW Linux image is hosted privately on GitHub Container Registry (`ghcr.io`).

2. **Request Access**  
   Email your GitHub username to `shivang.sharma@emerson.com`. We’ll grant you “read” permissions for the `labview_linux` package.

3. **Authenticate & Pull**  
   ```bash
   # Log in to GHCR
   docker login ghcr.io -u <your-github-username>
   # Enter a Personal Access Token (with at least read:packages scope) when prompted

   # Pull the beta image
   docker pull ghcr.io/shivacode-2/labview_linux:2025q3_beta
   ```
4. **Run the Container (Interactive Shell)**  
   ```bash
   docker run --rm -it ghcr.io/shivacode-2/labview_linux:2025q3_beta
   ```
   This command launches the container and drops you straight into a Bash shell—no volume mounts or network settings required.
5. **Run LabVIEWCLI Operations**  
   Once inside the container shell, execute any `labviewcli` command.

## Example Usage
### Pulling in the image
```bash
   docker pull ghcr.io/shivacode-2/labview_linux:2025q3_beta
```
![image](https://github.com/user-attachments/assets/054826e4-fec9-424e-a209-69499db298d4)

### Running the image in interactive mode
```bash
   docker run -it ghcr.io/shivacode-2/labview_linux:2025q3_beta
```
![image](https://github.com/user-attachments/assets/8e413608-d59e-4522-adc5-0df64df08ccf)

### Executing MassCompile using LabVIEWCLI
```bash
   # Inside Container
   LabVIEWCLI -OperationName MassCompile -DirectoryToCompile /usr/local/natinst/LabVIEW-2025-64/examples/Arrays -LogToConsole TRUE -LabVIEWPath /usr/local/natinst/LabVIEW-2025-64/labviewprofull
```
![image](https://github.com/user-attachments/assets/09fc35e9-c33b-448d-ac37-2ef84c37a396)
   
### Integration with CI/CD workflows
You can use this repository as an example of how to integrate a LabVIEWCLI Docker image into your CI/CD workflows, such as GitHub Actions. Essentially, this repository serves as a practical demonstration of how to:
1. Run LabVIEWCLI commands within a Docker container: This shows you how to encapsulate your LabVIEWCLI operations in a consistent and isolated environment.
2. Leverage built-in GitHub Actions and helper scripts: The repository provides pre-configured workflows and scripts that illustrate how to automate tasks involving the LabVIEWCLI Docker image in a CI/CD pipeline.
By exploring this repository, you can gain insights into setting up and running LabVIEWCLI-based processes as part of your automated build, test, and deployment strategies.

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

Feel free to tailor the workflow to your needs—add or remove jobs, adjust environment variables, or modify volume mounts. You can also use the provided YAML definitions as a springboard for your own CI/CD pipelines. This repository is meant as a reference implementation to help you quickly integrate LabVIEWCLI commands into your automated workflows.

#### Integrating LabVIEWCLI Tests into Your CI Pipeline (Example)
This section demonstrates how you can leverage this repository to integrate LabVIEWCLI-driven tests into your Continuous Integration (CI) pipeline. It provides a practical example of setting up and running LabVIEWCLI tests automatically as part of your development workflow.

1. **Fork the repository**
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

7. **Review results & iterate**
      - Click the Actions tab or PR checks to see logs.
      - Update your scripts or VIs, push new commits, and watch the workflow run again.

8. **Customize for your needs**
      - Modify runlabview.sh to add/remove CLI commands.
      - Edit `.github/workflows/vi-analyzer-container.yml` to adjust jobs, environment variables, or matrix settings.
  
Feel free to tailor the workflow to your needs—add or remove jobs, adjust environment variables, or modify volume mounts. You can also use the provided YAML definitions as a springboard for your own CI/CD pipelines. This repository is meant as a reference implementation to help you quickly integrate LabVIEWCLI commands into your automated workflows.

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

## Licensing Agreement




