# **Image Sharing Platform on Azure**

This is a comprehensive guide to setup the repo and your environment. I tried to include as much as I can, if you have any suggestions feel free to contact me on wiseoldturtlelabs@gmail.com

---

## **Prerequisites**

Before starting, ensure you have the following:
- **Terraform**: Install [Terraform](https://www.terraform.io/downloads.html).
- **Azure CLI**: Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
- **GitHub**: A GitHub account for repository management.
- **Azure DevOps (Optional)**: If deploying using Azure DevOps pipelines.

For GitHub Actions:
- Generate a [Personal Access Token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) with repo and workflow scopes.

For Azure DevOps:
- Create an Azure DevOps project and service connection to your Azure subscription.

---

## **Getting Started**

### **Step 1: Clone the Repository**
Clone this repository to your local machine or fork it for your own use.

---

### **Step 2: Setting Up Variables and Secrets**

#### **GitHub Actions**:
1. Navigate to your GitHub repository.
2. Go to **Settings > Secrets and variables > Actions**.
3. Add the following secrets:
   - `AZURE_CLIENT_ID`: Azure Service Principal app ID.
   - `AZURE_CLIENT_SECRET`: Azure Service Principal secret.
   - `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID.
   - `AZURE_TENANT_ID`: Your Azure tenant ID.
   - `GITHUB_TOKEN`: Your GitHub PAT for pushing changes.

#### **Azure DevOps**:
1. Navigate to **Pipelines > Library** in your Azure DevOps project.
2. Create a new variable group (e.g., `TerraformVariables`).
3. Add the following variables:
   - `ARM_CLIENT_ID`: Azure Service Principal app ID.
   - `ARM_CLIENT_SECRET`: Azure Service Principal secret.
   - `ARM_SUBSCRIPTION_ID`: Azure subscription ID.
   - `ARM_TENANT_ID`: Azure tenant ID.

---

## **Customizing for Your Deployment**

1. **Update `terraform.tfvars`:**
   Modify values to suit your environment.

   Example:
   ```hcl
   resource_group_name = "my-resource-group"
   app_name            = "my-app-name"
   location            = "location"
   ```

2. **Configure CORs Settings:**
   After deployment, add the frontend's URL to the backend's CORs configuration to allow proper communication.

3. **Adjust Environment-Specific Settings:**
   - Update the `function_app.py` file for API-specific changes.
   - Modify frontend files (`index.html`, `script.js`) to point to the correct backend API URL.

---

## **Deployment Instructions**

### Using Terraform Locally:
1. Navigate to the relevant Terraform directory (e.g., `terraform/webapp`).
2. Run the following commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### Post-Deployment Steps:
1. Test the application by uploading images and verifying they are processed and stored correctly.
2. Check logs in Azure Functions for any errors.

---

## **Best Practices**

1. **Naming Conventions:**
   - Use consistent prefixes and suffixes for resource names (e.g., `myproj-<resource-type>`).
   - Include environment identifiers (e.g., `-dev`, `-prod`) for clarity.

2. **Secure Sensitive Data:**
   - Store secrets in GitHub or Azure DevOps securely.
   - Rotate keys and secrets periodically.

3. **Resource Management:**
   - Use tags for resource organization (e.g., `project:ImagePlatform`, `env:prod`).

4. **Infrastructure as Code:**
   - Avoid manual changes to Azure resources; use Terraform to track all updates.

---

## **Common Pitfalls**

1. **Authentication Failures:**
   - Ensure your Service Principal details are correct.
   - Verify that the SP has the necessary permissions.

2. **CORs Configuration:**
   - Ensure the frontend URL is added to the backend's CORs settings for the function app.

3. **Terraform State Management:**
   - Use a remote backend for state files to prevent conflicts in collaborative environments.

---

This guide should help you set up and customize the platform effectively. If you encounter any issues, feel free to refer to the Azure or Terraform documentation for additional support.
