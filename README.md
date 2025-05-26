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
