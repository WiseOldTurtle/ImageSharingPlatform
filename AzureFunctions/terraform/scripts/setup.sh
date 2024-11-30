#!/bin/bash

# Log into Azure using a Service Principal
echo "Logging into Azure with service principal..."

az login --service-principal \
    --username "$AZURE_CLIENT_ID" \
    --password "$AZURE_CLIENT_SECRET" \
    --tenant "$AZURE_TENANT_ID"

if [ $? -ne 0 ]; then
    echo "Azure login failed!"
    exit 1
fi

# Create Resource Group
echo "Creating resource group: $backendRGName in UK South..."
az group create --name $backendRGName --location "UK South"

# Check if the resource group creation was successful
if [ $? -ne 0 ]; then
  echo "Failed to create resource group. Exiting."
  exit 1
fi

# Create Storage Account
echo "Creating storage account: $backendStorageAccountName..."
az storage account create \
  --name $backendStorageAccountName \
  --resource-group $backendRGName \
  --location "UK South" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --access-tier Hot

# Check if the storage account was successfully created
if [ $? -ne 0 ]; then
  echo "Failed to create storage account. Exiting."
  exit 1
fi

# Retrieve Storage Account Key
echo "Retrieving storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group $backendRGName \
--account-name $backendStorageAccountName --query '[0].value' -o tsv)

# Validate key retrieval
if [ -z "$ACCOUNT_KEY" ]; then
  echo "Failed to retrieve storage account key. Exiting."
  exit 1
fi

export ACCOUNT_KEY
export ARM_ACCESS_KEY=$ACCOUNT_KEY

# Create Storage Container
echo "Creating storage container: $backendContainerName..."
az storage container create \
  --name $backendContainerName \
  --account-name $backendStorageAccountName \
  --account-key $ACCOUNT_KEY

# Validate container creation
if [ $? -ne 0 ]; then
  echo "Failed to create storage container. Exiting."
  exit 1
fi

echo "Setup complete. Backend storage configuration is ready for Terraform!"
