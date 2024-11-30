#!/bin/bash

# Exit on error
set -e

# Check if the directories variable is set
if [ -z "$directories" ]; then
  echo "Error: directories variable is not set."
  exit 1
fi

# Define the root directory
WORKING_ROOT="$System.DefaultWorkingDirectory/AzureFunctions/terraform"

# Split the directories variable into an array
IFS=',' read -r -a SUBDIRS <<< "$directories"

# Loop through each subdirectory
for DIR in "${SUBDIRS[@]}"; do
  FULL_PATH="$WORKING_ROOT/$DIR"

  # Check if the directory exists
  if [ -d "$FULL_PATH" ]; then
    echo "Processing directory: $FULL_PATH"

    # Navigate to the directory
    cd "$FULL_PATH"

    # Initialize Terraform
    echo "Initializing Terraform in $FULL_PATH..."
    terraform init -backend=false

    # Validate Terraform configuration
    echo "Validating Terraform configuration in $FULL_PATH..."
    terraform validate

    echo "Validation completed for $FULL_PATH."
  else
    echo "Directory not found: $FULL_PATH"
  fi
done

echo "Terraform validation completed for all directories."
