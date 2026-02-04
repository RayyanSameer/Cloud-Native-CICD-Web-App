# Cloud-Native CI/CD Web App

Welcome to this project combining Java web app development and AWS CI/CD tools!

<br>

## Table of Contents
- [Introduction](#introduction)
- [Technologies](#technologies)
- [Project Outcomes](#project-outcomes)
- [Setup](#setup)
- [Contact](#contact)
- [Conclusion](#conclusion)

<br>

## Introduction
This project serves as a practical implementation of creating and deploying a Java-based web application using AWS Developer Tools.

The deployment pipeline I built around this application is invisible to the end-user, but it makes a massive impact by fully automating the software release process—from code commit to production deployment.

<br>

## Technologies
Here's the tech stack driving this project:

- **Amazon EC2**: I developed my web app on Amazon EC2 virtual servers, ensuring that software development and deployment happened entirely in the cloud.
- **VS Code**: My IDE of choice. It connects directly to my development EC2 instance via Remote-SSH, making it easy to edit code and manage files remotely.
- **GitHub**: The centralized repository where all web app code is versioned and stored.
- **AWS CodeArtifact**: Manages artifacts and dependencies to improve high availability and speed up the build process.
- **AWS CodeBuild**: Automates the build phase—compiling source code, running tests, and producing ready-to-deploy software packages.
- **AWS CodeDeploy**: Handles the automated deployment of code changes to EC2 instances.
- **AWS CodePipeline**: The orchestrator that connects GitHub, CodeBuild, and CodeDeploy into a single, efficient continuous delivery workflow.

<br>

## Project Outcomes
Implementing this CI/CD pipeline delivered significant measurable improvements:

- ** Faster Deployment Cycles**: Updates and builds that previously took hours now deploy in half the time, dramatically accelerating my development velocity. What used to take an hour, manually,  is now done in 20 min
- **3 Days Saved on Infrastructure

 Provisioning**: AWS CodeBuild eliminated manual infrastructure setup, saving 3 days of work that would have been spent configuring build environments.

- **Real-Time Deployment**: Changes pushed to the GitHub repository trigger automatic builds and deployments, providing instant feedback and enabling continuous integration.
- **Zero Downtime Updates**: The automated pipeline ensures smooth rollouts without manual intervention or service interruptions.

<br>

## Setup
To get this project up and running on your local machine (or cloud instance), follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/rayyansameer/Cloud-Native-CICD-Web-App.git
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

**Rayyan Sameer** - rayyansameer2005@gmail.com

<br>

## Conclusion
Thank you for exploring this project! Building this automated CI/CD pipeline transformed my development workflow, proving that investing in DevOps infrastructure pays immediate dividends in speed and efficiency.

