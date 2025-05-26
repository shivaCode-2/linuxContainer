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
### **Automated CI Workflow**
This repo contains all the necessary logic and files to run LabVIEWCLI on a docker container. Below is the repository structure explained.

#### Repo Structure
1. **Test-VIs**: Contains sample VIs on which we run the VI Analyzer tests.
2. **runlabview.sh**: Bash script containing the logic to run LabVIEWCLI operations on the Test-VIs. The script currently runs MassCompile and VIAnalyzer tests but feel free to add your own operations and logic that suit your use case.
3. **.github/workflows/vi-analyzer-container.yml**: This is the YAML configuration for our github action. This action   
   - Login into Github Container Registry
   - Pull in the image **labview_linux:2025q3_beta**
   - Mounts the repository in the container to access the Test-VIs and start the container with **runlabview.sh** as its entrypoint.
You can modify the action YAML configuration to add more jobs into your action.

#### How to use this repo to run CI operations
This repository already has access to the private container image. To use this repo and its actions you first need to make a fork out of this repo.
1. Go to the linuxContainer repository located at: https://github.com/shivaCode-2/linuxContainer
2. You need to fork this repository to create a new one. You can name it anything you prefer.
3. After forking the repository, clone the newly forked repo onto your local system.
4. Once cloned, make a new testing branch <branch_name> and make some dummy changes in the files and then use git push origin <branch_name>.
5. After completing the push, navigate to the original repository (not the forked one). You should see a message prompting you to create a pull request, similar to the following:
![image](https://github.com/user-attachments/assets/78bab1ef-e8a8-422c-9a82-8cb07ade463d)
6. Click on Compare & pull request and make a new pull request.
7. Once created, you should see the action Run VI Analyzer in the PR details.
8. The action will pull in the docker image, run the script **runlabview.sh** to MassCompile and run VI analyzer tests on repo:Test-VIs directory and display the results.
9. You can modify the bash script to have your own set of operations that you want to try out with LabVIEWCLI.


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






