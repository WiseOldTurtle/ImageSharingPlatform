# Scripts for Azure Native Image Sharing Platform

This directory contains a set of utility scripts created to streamline tasks for building and managing an Azure-native image-sharing platform. These scripts are a great starting point for integrating into your own workflows or pipelines. Feel free to use and adapt them as needed—they might require minor adjustments to suit your specific environment.

## Script Descriptions

- **`setup.sh`**:  
  Initializes your Azure environment by:
  - Logging in with a service principal
  - Creating a resource group, storage account, and container for Terraform backend storage.  
  **Required Changes:** Update Azure-related variables (`TF_VAR_client_id`, `TF_VAR_client_secret`, `TF_VAR_tenant_id`, etc.) to match your setup.

- **`terraform_actions.sh`**:  
  Executes various Terraform actions (`init`, `plan`, `apply`, `destroy`) for specific directories.  
  **Required Changes:** Customize the backend configuration and working directory paths to align with your environment.

- **`terraform_fmt.sh`**:  
  Formats Terraform configurations recursively in specified directories.  
  **Required Changes:** Ensure the `directories` and `WORKING_DIR` variables are set appropriately.

- **`terraform_init.sh`**:  
  Initializes the Terraform backend for a given directory.  
  **Required Changes:** Supply the directory path, resource group name, storage account name, and container name as arguments.

- **`terraform_validate.sh`**:  
  Validates Terraform configurations across specified directories.  
  **Required Changes:** Similar to `terraform_fmt.sh`, ensure the `directories` and `WORKING_DIR` variables are configured correctly.

## Notes

- These scripts are provided as-is for educational purposes and may require adjustments to suit your specific Azure setup and Terraform structure.
- Always test scripts in a safe environment before deploying to production.
- You will need to use chmod commands to allow execution 

## Sample Code

```
 ${{ each dir in split(variables.directories, ',') }}:
              - script: |
                  echo "Processing directory: ${{ dir }}"
                  chmod +x $(System.DefaultWorkingDirectory)/AzureFunctions/terraform/scripts/terraform_fmt.sh
                  chmod +x $(System.DefaultWorkingDirectory)/AzureFunctions/terraform/scripts/terraform_validate.sh

                  # Trivy Scan
                  mkdir -p $(Build.ArtifactStagingDirectory)/trivy-reports
                  trivy config --severity LOW,MEDIUM,HIGH,CRITICAL --format json \
                    --output $(Build.ArtifactStagingDirectory)/trivy-reports/${{ dir }}_scan.json \
                    $(System.DefaultWorkingDirectory)/AzureFunctions/terraform/${{ dir }}

                  # Terraform Fmt
                  $(System.DefaultWorkingDirectory)/AzureFunctions/terraform/scripts/terraform_fmt.sh

                  # Terraform Validate
                  # $(System.DefaultWorkingDirectory)/AzureFunctions/terraform/scripts/terraform_validate.sh
                displayName: 'Run Trivy, Fmt, and Validate for ${{ dir }}'
                env:
                  directories: $(directories)
                  WORKING_DIR: $(System.DefaultWorkingDirectory)
```
---

Happy coding!
