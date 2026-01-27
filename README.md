# Cloud-Native CI/CD Web App

Welcome to this project combining Java web app development and AWS CI/CD tools!

<br>

## Table of Contents
- [Introduction](#introduction)
- [Technologies](#technologies)
- [Setup](#setup)
- [Contact](#contact)
- [Conclusion](#conclusion)

<br>

## Introduction
This project serves as a practical implementation of creating and deploying a Java-based web application using AWS Developer Tools.

The deployment pipeline I'm building around this application is invisible to the end-user, but it makes a massive impact by fully automating the software release process—from code commit to production deployment.

<br>

## Technologies
Here’s the tech stack driving this project:

- **Amazon EC2**: I'm developing my web app on Amazon EC2 virtual servers, ensuring that software development and deployment happen entirely in the cloud.
- **VS Code**: My IDE of choice. It connects directly to my development EC2 instance via Remote-SSH, making it easy to edit code and manage files remotely.
- **GitHub**: The centralized repository where all web app code is versioned and stored.
- **[COMING SOON] AWS CodeArtifact**: Will manage artifacts and dependencies to improve high availability and speed up the build process.
- **[COMING SOON] AWS CodeBuild**: Will automate the build phase—compiling source code, running tests, and producing ready-to-deploy software packages.
- **[COMING SOON] AWS CodeDeploy**: Will handle the automated deployment of code changes to EC2 instances.
- **[COMING SOON] AWS CodePipeline**: The orchestrator that connects GitHub, CodeBuild, and CodeDeploy into a single, efficient continuous delivery workflow.

<br>

## Setup
To get this project up and running on your local machine (or cloud instance), follow these steps:

1. Clone the repository:
    ```bash
    git clone [https://github.com/your-github-username/Cloud-Native-CICD-Web-App.git](https://github.com/your-github-username/Cloud-Native-CICD-Web-App.git)
    ```
2. Navigate to the project directory:
    ```bash
    cd Cloud-Native-CICD-Web-App
    ```
3. Install dependencies:
    ```bash
    mvn install
    ```

<br>

## Contact
If you have any questions or comments about this project, please reach out:

**Rayyan Sameer** - [Link to your LinkedIn or Email](mailto:your.email@example.com)

<br>

## Conclusion
Thank you for exploring this project! I will continue to build out this pipeline and apply these DevOps practices to future deployments.

A big shoutout to **[NextWork](https://learn.nextwork.org/app)** for their project guide and support. [You can get started with this DevOps series project too by clicking here.](https://learn.nextwork.org/projects/aws-devops-vscode?track=high)
