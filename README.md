# **Image Sharing Platform on Azure**  

This project demonstrates a cost-effective, scalable, and secure image-sharing platform on Azure. Users can upload images, which are resized and made available in multiple resolutions for sharing or downloading. This platform is built with security and scalability in mind.  

---

## **Table of Contents**  

1. [Architecture Overview](#architecture-overview)  
    - [Solution: Azure Functions + Static Web Apps](#solution-1-azure-functions--static-web-apps)  
2. [Azure-Native Approach (some alternative points as well)](#azure-native-approach-some-alternative-points-as-well) 
    - [Core Features](#core-features)    
    - [Advanced Features Solution](#advanced-features-solution)  
3. [File Structure](#file-structure)  
    - [Azure Functions Solution](#azure-functions-solution)  
4. [Challenges & Workarounds](#challenges--workarounds)  
5. [#TODO Notes](#todo-notes)  
6. [Future Improvements](#future-improvements)  
7. [Possible Security Enhancements](#possible-security-enhancements)   

---

## **Architecture Overview**  

### **Solution: Azure Functions + Static Web Apps**

This solution uses serverless Azure services for simplicity and cost-effectiveness. It includes:  
- **Frontend**: Azure Static Web Apps for a web interface.  
- **Backend**: Azure Functions to handle image uploads, resizing and processing.  
- **Storage**: Azure Blob Storage for image storage in multiple resolutions.  

---

## **Core Feature Requirement**  

### **Azure-Native Approach (some alternative points as well)**  

#### **Image Resizing & Links to Resized Images**  

Handling large image uploads and generating urls for the end user to be able to share are core requirements for this case study. Here’s a breakdown of how the resizing and link generation works:

1. **Uploading the Image**: Users send their image through simply attaching their image and hitting upload. No fancy forms—just quick and easy.  
2. **Resizing on the Fly**: The image gets resized into different resolutions (like thumbnail, medium, and large) using Python’s PIL library.  
3. **Organized Storage**: Each resized version is uploaded to Azure Blob Storage, neatly sorted by resolution. 
4. **TODO. Direct Links**: The Function generates public links for each resized version and sends them back to the user. These links are ready to share, download, or use wherever needed.  

#### **Cost-Effective Design**  
When designing this solution, cost optimization was a top priority (especially since I’m using a Pay-as-you-go subscription). Here’s how I kept costs in check:  
- **Azure Consumption Plan**: I opted for the Azure Consumption Plan for Azure Functions, meaning I only pay when the functions are executed—helping avoid unnecessary costs.  
- **Blob Storage Tiers**: I used the Hot and Cool tiers in Blob Storage to optimize costs. Frequently accessed images are stored in the Hot tier, while images that aren't accessed as often go into the Cool tier. This can be achieved by setting up lifecycle management rules to automatically transition less frequently used blobs from Hot to Cool over time.

##### **Some Alternative Storage Options**  

- **Azure CDN with Blob Storage**: Speeds up image delivery by caching at edge locations, reducing Blob Storage load and improving user experience. (Ideally I would have enabled this if I was not bound by my PAYG sub)  
- **Azure File Storage** | **Azure Event Grid** | **Azure Archive Storage**


### **Advanced Feature Requirement**  

#### **Scaling for Spikes**  
To ensure the platform handles unpredictable traffic spikes without issues, I relied on Azure’s serverless scaling capabilities:

- **Azure Functions** automatically scale up or down depending on demand, which makes it ideal for situations where you might get sudden surges in uploads.  
- For better handling of large bursts of traffic, I could incorporate **Azure Event Grid or Queues or even Azure CDN**. These services would compliment the existing solution and enable us to enjoy a few more useful features such as queue management, image caching and an overall faster and more reliable service. 

Of course, there is the possibilty of using an orchestration approach with AKS, which has the Horizontal Pod Autoscaling (HPA) feature (containers scale based on CPU or metrics). This would be particularly useful if we need more granular control over scaling and wish to maintain high availability during traffic surges. Additionally, we could implement Azure Redis Cache to handle high-throughput and reduce backend load, improving overall system performance during spikes in traffic. (Disclaimer. I know of Redis Cache and its uses, but never have used it before this was just a little bit of googling at alternatives)

#### **TODO. User Accounts & Image Management**  
To give users more control and personalization, the platform could include a login feature:  
- **User Logins**: Users log in securely possibly through the use of AD B2C, StaticSite authentication (can do something like google) 
- **Uploaded Images to be listed and viewed**:  

#### **TODO. Link Shortener**  
One of the extra features was the requirement of a link shortner:  
- Users could request a URL for their uploaded images, and an Azure Function would generate a unique shortened link for them through the use of bitly and an API? (will need to update the Python) 

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
- Automate full solution using CI/CD pipeline.
- Look into an AKS solution to demonstrate container orchestration and scalability.

### **QOL changes** 
- Incorporate sentiment analysis for feedback on user experience with the platform.


### **Security Enhancements** 
1. **Application Gateway**:  
   - Incorporate WAF (Web Application Firewall) for secure HTTP traffic.  
2. **Azure Resource Security**:  
   - Remove any public access, hardcode IPs and utilize endpoints.  
3. **Custom Domain**:
   - Setup staticsite to use a Custom domain 
4. **Logic to Validate user input**:
   - Create some logic where file size and metadata can be validated. Metadata scanning will avoid malicious injected code. Defender to scan files when they have landed in storage.
5. **Secure Connection String**:
   - Introduce the use of Azure KeyVault to hold keys and secrets. (can be referenced through ADO variables in the YAML)
6. **RBAC Implementation**:
   - Possibly implement RBAC with custom roles such as **Uploader** or **Viewer** to restrict access. 

