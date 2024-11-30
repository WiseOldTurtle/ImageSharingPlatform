#!/bin/bash

# Exit on error
set -e

# Ensure the working directory exists
WORKING_DIR="$System.DefaultWorkingDirectory/AzureFunctions/terraform"

if [ ! -d "$WORKING_DIR" ]; then
  echo "Terraform directory not found: $WORKING_DIR"
  exit 1
fi

# Format all Terraform files
echo "Formatting Terraform files in $WORKING_DIR..."
find "$WORKING_DIR" -name "*.tf" -exec terraform fmt -recursive {} \;

echo "Terraform formatting completed successfully."
