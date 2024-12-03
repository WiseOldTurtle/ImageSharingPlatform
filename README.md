# **Image Sharing Platform on Azure**

This project demonstrates a cost-effective, scalable, and secure azure-native image-sharing platform built using Azure services.

---

## **Table of Contents**

1. [Project Background](#project-background)
2. [Architecture Overview](#architecture-overview)
3. [Platform Features](#platform-features)
    - [Essential Features](#essential-features)
    - [Additional Learning Opportunities](#additional-learning-opportunities)
4. [Collaborative Notes](#collaborative-notes)
5. [File Structure](#file-structure)
6. [Challenges & Workarounds](#challenges--workarounds)
7. [Future Improvements](#future-improvements)

---

## **Project Background**

This project began as a concept for an image-sharing platform with a strong focus on simplicity, scalability, and cost-effectiveness. The goal is to create a platform where users can upload images, automatically process them into multiple resolutions, and share or download them with ease.

Key ideas behind the platform include:
- **User-Friendly Experience**: Allow users to upload images effortlessly and generate shareable links for different image sizes.
- **Cost Efficiency**: Keep costs low by leveraging Azure’s serverless solutions and consumption-based pricing models.
- **Scalability**: Handle traffic spikes during busy periods without requiring manual intervention or infrastructure reconfiguration.

This repository is designed as a learning resource and reference for developers. It demonstrates how to use Azure services and modern infrastructure practices like Terraform to build a real-world application. Whether you're exploring serverless architecture, enhancing your own projects, or learning how to set up pipelines and infrastructure, this project provides a strong foundation.

Feel free to fork the repository, adapt it to your needs, or use it as a reference to build something entirely your own. The platform is meant to inspire and guide others in their personal development and projects.

---

## **Architecture Overview**

### **Solution: Azure Functions + Static Web Apps**

The solution includes:
- **Frontend**: Azure Static Web Apps for a web interface.
- **Backend**: Azure Functions to handle image uploads, resizing, and processing.
- **Storage**: Azure Blob Storage for storing images in multiple resolutions.

---

## **Platform Features**

### **Essential Features**
1. **Image Upload and Resizing**: Users can upload images, which are resized into multiple resolutions (e.g., thumbnail, medium, large) and stored in Azure Blob Storage.
2. **Link Generation**: Shareable links are created for each resized image, making it easy to download or share.
3. **Cost Optimization**: Azure services, such as Consumption Plans and Blob Storage tiers, are used to minimize costs without sacrificing functionality.

### **Additional Learning Opportunities**
1. **Scaling for Traffic Surges**: The architecture is designed to automatically handle spikes in traffic using serverless Azure Functions, offering a real-world example of scaling cloud services.
2. **User Authentication**: Demonstrates how to incorporate user authentication (e.g., Azure AD B2C) for image management and personalization.
3. **URL Shortening**: Explores how to generate short URLs for shared images using services like Bitly or custom logic.

---

## **Collaborative Notes**

Refer to [TASKS.md](./TASKS.md) for current and future tasks.

---

## **File Structure**

### **Azure Functions Solution**  
```bash
CaseStudyBJSS/
├── README.md                         # Start here! Overview and guide to the project.
├── SECURITY.md                       # Security ideas and best practices.
├── TASKS.md                          # A list of tasks and notes for tracking progress.
├── IMPROVEMENTS.md                   # Suggestions for enhancements and future developments.
├── AzureFunctions/                   # Core functionality of the platform.
│   ├── api/                          # Backend logic for image uploads and resizing.
│   │   ├── uploadImage/              # Core Azure Function for image processing.
│   │   │   ├── function_app.py       # Main logic for image resizing and upload handling.
│   │   │   ├── requirements.txt      # Python dependencies.
│   │   │   └── function.json         # Config file for setting up Azure Functions. Check this out to understand how the backend is triggered.
│   ├── client/                       # Frontend files for the user interface.
│   │   ├── index.html                # Main web page for image uploads.
│   │   ├── script.js                 # Frontend interactivity.
│   │   └── style.css                 # Styling for the user interface.
│   ├── terraform/                    # Infrastructure as Code for managing Azure resources.
│   │   ├── management/               # Terraform files for shared resources like storage.
│   │   ├── networking/               # Network configuration for the platform (just a placeholder needs work).
│   └── └── webapp/                   # Deployment configurations for the web app and backend.
├── .github/                          # GitHub-specific files (e.g., workflows for CI/CD pipelines).
├── .vscode/                          # Editor configurations for VS Code.
└── arm-ttk/                          # Azure Resource Manager template toolkit for validation.
```

---

## **Challenges & Workarounds**

1. **Terraform Static Web App Bug**: Used ARM templates as a workaround.
2. **Connection String Security**: Ensured sensitive values are not exposed in clear text.
3. **Terraform State Remote Backend**: Utilized remote backend for improved observability.

---

## **Future Improvements**

See [IMPROVEMENTS.md](./IMPROVEMENTS.md) for planned enhancements.

