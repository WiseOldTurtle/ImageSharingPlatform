#!/bin/bash

# Ensure all required arguments are provided
if [ $# -ne 3 ]; then
  echo "Usage: $0 <resource_group_name> <storage_account_name> <container_name>"
  exit 1
fi

RESOURCE_GROUP_NAME=$1
STORAGE_ACCOUNT_NAME=$2
CONTAINER_NAME=$3

echo "Initializing Terraform backend..."
terraform init \
  -backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
  -backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}" \
  -backend-config="container_name=${CONTAINER_NAME}" || { echo "Terraform init failed!"; exit 1; }

echo "Terraform backend initialized successfully!"
