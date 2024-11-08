# Image Sharing Platform on Azure

This project demonstrates a cost-effective, scalable, and secure image-sharing platform on Azure. Users can upload images, which are resized and made available in multiple resolutions for sharing or downloading. This platform is built with security and scalability in mind.

##  Solution 1 - Architecture Overview (Non AKS & Docker)

### FrontEnd
- **Azure Static WebApps** for a simple static web app front end hosted by an application (possibly HTML/JavaScript or React/Angular App) for cost effectiveness
<!-- Azure Web App -->

### BackEnd
- **Azure Function** - Serverless Azure Function for handling image uploads and processing.
<!-- Logic Apps -->

### Storage and Other Components
- **Azure Blob Storage** for storing original and resized images.
- **Azure Key Vault** for managing secrets.
- **Terraform** for IaC to deploy all resources.

## File Structure
``` bash image-sharing-platform/
image-sharing-platform-case-study/
├── README.md                         # Overview of the project
├── azure-functions-solution/         # Folder for the Azure Functions + Static Web Apps solution
│   ├── client/                       # Frontend files (HTML/CSS/JS)
│   │   ├── index.html                # Main upload page for image uploads
│   │   ├── style.css                 # Optional styles
│   │   └── script.js                 # JavaScript for image upload handling
│   ├── api/                          # Folder for Azure Functions (backend)
│   │   ├── uploadImage/
│   │   │   ├── index.js              # Function for handling image upload and resizing logic
│   │   │   └── function.json         # Function configuration
│   ├── terraform/                    # Terraform files for deploying Static Web App and Functions
│   │   ├── main.tf                   # Main Terraform file
│   │   ├── variables.tf              # Terraform variables
│   │   └── outputs.tf                # Outputs from Terraform
│   └── azure-pipelines.yml           # Azure DevOps YAML pipeline for CI/CD
└── diagrams/                         # Diagrams for architecture and flow explanations
    └── azure-functions-architecture.png  # Diagram for Azure Functions solution
```

## Possible Security Enhancements and Recommendations

- **Application Gateway with WAF** for securing HTTP traffic.
- **Private Endpoints** for Blob Storage and Key Vault.
- **Managed Identity** for secure access to Key Vault secrets.
- **Custom Domain with SSL** for secure and trustworthy access.
- **Logic App** integration as oppose to Function App.
- **Azure WebApp** 


##  Solution 2 - Architecture Overview (AKS & Docker Implementation)

``` bash image-sharing-platform/
image-sharing-platform-case-study/
├── README.md   
├── aks-docker-solution/              # Folder for AKS + Docker solution
│   ├── app/                          # App folder for Dockerized app
│   │   ├── Dockerfile                # Dockerfile for app image
│   │   ├── app.py                    # Backend app (e.g., Python/Flask for handling uploads)
│   │   ├── static/                   # Static files folder for frontend (HTML/CSS/JS)
│   │   │   ├── index.html            # Main HTML file for upload form
│   │   │   ├── style.css             # Styles for the upload page
│   │   │   └── script.js             # JavaScript for handling upload requests
│   ├── k8s-manifests/                # Kubernetes manifests for AKS deployment
│   │   ├── deployment.yaml           # Deployment file for app pods
│   │   ├── service.yaml              # Service file to expose app
│   │   └── ingress.yaml              # Ingress for load balancing and routing
│   ├── terraform/                    # Terraform files for provisioning AKS resources
│   │   ├── main.tf                   # Main Terraform file
│   │   ├── variables.tf              # Terraform variables
│   │   └── outputs.tf                # Outputs from Terraform
│   └── azure-pipelines.yml           # Azure DevOps YAML pipeline for CI/CD
└── diagrams/                         # Diagrams for architecture and flow explanations
    └── aks-docker-architecture.png       # Diagram for AKS + Docker solution 
```
### FrontEnd
- **Azure Static WebApps** for a simple static web app front end hosted by an application (possibly HTML/JavaScript or React/Angular App) for cost effectiveness
<!-- Azure Web App -->

### BackEnd
- **Azure Function** - Serverless Azure Function for handling image uploads and processing.
<!-- Logic Apps -->

### Storage and Other Components
- **Azure Blob Storage** for storing original and resized images.
- **Azure Key Vault** for managing secrets.
- **Terraform** for IaC to deploy all resources.