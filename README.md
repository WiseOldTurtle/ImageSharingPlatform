# **Image Sharing Platform on Azure**  

This project demonstrates a cost-effective, scalable, and secure image-sharing platform on Azure. Users can upload images, which are resized and made available in multiple resolutions for sharing or downloading. This platform is built with security and scalability in mind.  

---

## **Table of Contents**  

1. [Architecture Overview](#architecture-overview)  
    - [Solution 1: Azure Functions + Static Web Apps](#solution-1-azure-functions--static-web-apps)  
    - [Solution 2: AKS & Docker](#solution-2-aks--docker)  
2. [Core Features](#core-features)  
    - [Azure-Native Approach (some alternative points as well)](#azure-native-approach-some-alternative-points-as-well)  
    - [Advanced Features Solution](#advanced-features-solution)  
3. [File Structure](#file-structure)  
    - [Azure Functions Solution](#azure-functions-solution)  
    - [AKS & Docker Solution](#aks--docker-solution)  
4. [Challenges & Workarounds](#challenges--workarounds)  
5. [#TODO Notes](#todo-notes)  
6. [Future Improvements](#future-improvements)  
7. [Possible Security Enhancements](#possible-security-enhancements)   

---

## **Architecture Overview**  

### **Solution 1: Azure Functions + Static Web Apps**

This solution uses serverless Azure services for simplicity and cost-effectiveness. It includes:  
- **Frontend**: Azure Static Web Apps for a responsive web interface.  
- **Backend**: Azure Functions to handle image uploads and processing.  
- **Storage**: Azure Blob Storage for image storage in multiple resolutions.  

### **Solution 2: AKS & Docker**  

This solution leverages containerization with Docker and Kubernetes for scalability and flexibility. It includes:  
- **Frontend**: Static HTML/CSS/JS hosted in a containerized app.  
- **Backend**: A Dockerized Python/Flask app for handling uploads and processing.  
- **Orchestration**: AKS for Kubernetes-based deployment.  

---

## **Core Features**  

### **Azure-Native Approach (some alternative points as well)**  

#### **Image Resizing & Links to Resized Images**  

Handling large image uploads and generating accessible links is central to this project. Here's how it works:  

1. **Image Upload**: Users upload images via an HTTP request to the Azure Function.  
2. **Background Resizing**: Using Azure Functions, the image is resized into multiple resolutions (e.g., thumbnail, medium, large) to ensure efficient and user-friendly processing without delays.
3. **Blob Storage Upload**: Resized images are uploaded to Azure Blob Storage, organized by resolution for easy management.  
4. **Generate URLs**: Public URLs for each resolution are created and returned to the user, providing direct access to the resized images.  

This approach ensures scalability, cost-effectiveness, and a seamless user experience for sharing and downloading images.

#### **Cost-Effective Design**  
When designing this solution, cost optimization was a top priority (especially since I’m using a Pay-as-you-go subscription). Here’s how I kept costs in check:  
- **Azure Consumption Plan**: I opted for the Azure Consumption Plan for Azure Functions, meaning I only pay when the functions are executed—helping avoid unnecessary costs.  
- **Blob Storage Tiers**: I used the Hot and Cool tiers in Blob Storage to optimize costs. Frequently accessed images are stored in the Hot tier, while images that aren't accessed as often go into the Cool tier. This can be managed via the portal or, ideally, using the Azure SDK. I can also set up lifecycle management rules to automatically transition infrequently used blobs from Hot to Cool over time.

##### **Alternative Storage Options**  

- **Azure CDN with Blob Storage**: Speeds up image delivery by caching at edge locations, reducing Blob Storage load and improving user experience.  
- **Azure File Storage**: Ideal for shared access to images with an SMB interface, but Blob Storage is better for static content.  
- **Azure Event Grid**: Automates workflows, triggering actions like image resizing or moving files to cheaper storage upon upload.  
- **Azure Archive Storage**: Low-cost, long-term storage for images that aren’t accessed often, best for archival rather than active sharing.


### **Advanced Features Solution**  

#### **Scaling for Spikes**  
To ensure the platform handles unpredictable traffic spikes without issues, I relied on Azure’s serverless scaling capabilities:  
- **Azure Functions** automatically scale up or down depending on demand, which makes it ideal for situations where you might get sudden surges in uploads.  
- For better handling of large bursts of traffic, I could incorporate **Azure Event Grid or Queues**. These services would help by queuing uploads, ensuring the backend processes them in a manageable order, without overloading the system.  

Of course, if we were to use a more advanced orchestration approach with AKS, we could implement Horizontal Pod Autoscaling (HPA), which allows containers to automatically scale based on CPU usage or custom metrics. This would be particularly useful if we need more granular control over scaling and wish to maintain high availability during traffic surges. Additionally, we could implement Azure Redis Cache to handle high-throughput and reduce backend load, improving overall system performance during spikes in traffic. (Disclaimer. I know of Redis Cache and its uses, but never have used it before)

#### **User Authentication & Dashboard**  
If the platform were to evolve to support more advanced user management:  
- **Azure AD B2C**: I would integrate Azure AD B2C to manage both user logins and anonymous access in a secure, seamless way.  
- **Database**: A database, such as Cosmos DB or SQL, would be used to store metadata for each image, like the resolution, upload time, and the user who uploaded it, making it easy to track and retrieve images when needed.

#### **Link Shortener**  
For an extra feature, I’d add a link shortener functionality:  
- Users could request a short URL for their uploaded images, and an Azure Function would generate a unique shortened link for them.  
- These shortened links would be stored in a Cosmos DB instance for easy management and look-up.

---

The Azure Native approach not only solves the problem at hand but also prepares the platform for future growth. It’s scalable, cost-effective, and flexible enough to support a variety of features, from user authentication to more advanced image processing techniques.

---

## **File Structure**  

### **Azure Functions Solution**  
```bash
CaseStudyBJSS/
├── README.md                         # Readme file covering key points and design.
├── arm-ttk/                          # ARM TTK for validating arm templates
├── AzureFunctions/                   # Directory for Azure Functions + Static Web Apps solution
│   ├── api/                          
│   │   ├── uploadImage/              # Function for handling image upload and resizing logic
│   │   │   ├── function_app.py       # Main Azure Function logic (Note to self. Can be ___init___.py)
│   │   │   ├── function.json         # Function configuration (HTTP request)
│   │   │   ├── host.json             
│   │   │   ├── local.settings.json   
│   │   │   └── requirements.txt      # Dependencies for Python function (pip freeze > requirements.txt)
│   ├── client/                       # Frontend files (HTML/CSS/JS)
│   │   ├── index.html                # Main upload page for image uploads
│   │   ├── script.js                 
│   │   └── style.css                 
│   ├── terraform/                    # Terraform folder for IaC
│   │   ├── management/               # Management / Shared Services resources for storage and backend of the webapp 
│   │   │   ├── main.tf               # Main.tf for Management directory
│   │   │   └── variables.tf          
│   │   ├── webapp/                   # Terraform folder for Static Web App deployment
│   │   │   ├── main.tf               # Terraform configuration for Static Web App
│   │   │   ├── functionapp-arm-template.json  # ARM template for app configuration
│   │   │   ├── staticwebapp-staticsite.json   # ARM template for Static Web App settings
│   │   │   └── variables.tf          # Variables for Terraform configuration
│   │   └── azure-pipelines.yml       # YAML pipeline for deploying resources
└── diagrams/                         # Diagrams for architecture and flow explanations
    └── azure-functions-architecture.png  # Diagram for Azure Functions solution
```

## **Challenges & Workarounds**

### **Bugs and Issues Faced**

1. **Terraform Static Web App Bug**:  
   - Encountered a [known bug](https://github.com/hashicorp/terraform-provider-azurerm/issues/13451) when deploying Azure Static Web Apps. 
   - **Workaround**: Used ARM templates for specific configurations.  

2. **Connection String Security**:  
   - Ensured connection strings were not exposed in clear text.  
   - **Solution**: Utilized _sensitive_ outputs which were referenced in other main.tf files.

3. **Terraform State Remote Backend**:
   - I wanted to think outside the box and seperate the terraform main.tf's for more observability and management. Multiple Backend.tf's meant it was more difficult to pull information if it was being referenced in another state file.
   - **Solution**: Utilized the remote backend as a Data point and also pushed outputs to be picked up by other main.tfs

---

### **#TODO. Notes**

## Pipeline Optimisation
- GitHub PAT is in clear text, need to reference this through the use of ADO Variables and TFVars for improved pipeline security.
- Need to segment off the pipeline to ensure **Management** has its own stage, this will make deployments more efficient alongside increase observability.
- Setup Azure Function App to be deployed through IAC and not click ops. (Have some code already in place need to get it to work)
- Convert the initial azCLI tasks to a script and run through script path. Will be much cleaner and save space. 

---

## **Future Improvements**

### **Alternative Solution Design**  
- Add CI/CD for AKS solution to demonstrate container orchestration and scalability.

### **QOL changes** 
- Incorporate sentiment analysis for feedback on user experience with the platform.


### **Security Enhancements**  
1. **Application Gateway**:  
   - Incorporate WAF (Web Application Firewall) for secure HTTP traffic.  
2. **Private Endpoints**:  
   - Use private endpoints for Blob Storage and Key Vault for enhanced security.  
3. **Managed Identities**:  
   - Enable secure, role-based access to Azure resources using Managed Identities.
4. **Custom Domain**:
   - Custom Domain with SSL for secure and trustworthy access.
5. **Logic App Integration**:
   - TODO. Write more about this.
6. **Azure WebApp**:
   - Possible for alternative Hosting

