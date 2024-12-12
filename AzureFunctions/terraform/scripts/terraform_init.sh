#!/bin/bash

# Ensure all required arguments are provided
if [ $# -ne 4 ]; then
  echo "Usage: $0 <directory_path> <resource_group_name> <storage_account_name> <container_name>"
  exit 1
fi

DIRECTORY_PATH=$1
RESOURCE_GROUP_NAME=$2
STORAGE_ACCOUNT_NAME=$3
CONTAINER_NAME=$4

# Check if the directory exists
if [ ! -d "$DIRECTORY_PATH" ]; then
  echo "Error: Directory not found: $DIRECTORY_PATH"
  exit 1
fi

echo "Changing to directory: $DIRECTORY_PATH"
cd "$DIRECTORY_PATH"

echo "Initializing Terraform backend..."
terraform init \
  -backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
  -backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}" \
  -backend-config="container_name=${CONTAINER_NAME}" || { echo "Terraform init failed!"; exit 1; }

echo "Terraform backend initialized successfully for $DIRECTORY_PATH!"
