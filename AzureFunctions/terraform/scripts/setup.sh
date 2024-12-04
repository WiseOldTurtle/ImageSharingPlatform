#!/bin/bash

# Exit on error
set -e

echo "Logging into Azure with Service Principal..."

# Login to Azure using Service Principal
az login --service-principal \
  --username "$TF_VAR_client_id" \
  --password "$TF_VAR_client_secret" \
  --tenant "$TF_VAR_tenant_id"

if [ $? -ne 0 ]; then
  echo "Azure login failed!"
  exit 1
fi

echo "Azure login successful!"

# Create Resource Group
echo "Creating Resource Group: $backendRGName in UK South..."
az group create --name "$backendRGName" --location "UK South"

# Create Storage Account
echo "Creating Storage Account: $backendStorageAccountName in UK South..."
az storage account create \
  --name "$backendStorageAccountName" \
  --resource-group "$backendRGName" \
  --location "UK South" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --access-tier Hot

# Retrieve Storage Account Key
echo "Retrieving Storage Account Key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group "$backendRGName" \
  --account-name "$backendStorageAccountName" --query '[0].value' -o tsv)

if [ -z "$ACCOUNT_KEY" ]; then
  echo "Failed to retrieve Storage Account Key!"
  exit 1
fi

# Export key for Terraform backend
export ARM_ACCESS_KEY=$ACCOUNT_KEY
echo "##vso[task.setvariable variable=ACCOUNT_KEY]$ACCOUNT_KEY"

# Create Storage Container
echo "Creating Storage Container: $backendContainerName..."
az storage container create \
  --name "$backendContainerName" \
  --account-name "$backendStorageAccountName" \
  --account-key "$ACCOUNT_KEY"

echo "Backend setup complete!"
