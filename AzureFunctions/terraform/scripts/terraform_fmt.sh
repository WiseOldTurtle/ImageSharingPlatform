#!/bin/bash

# Exit on error
set -e

# Check if directories and WORKING_DIR are set
if [ -z "$directories" ]; then
  echo "Error: directories variable is not set."
  exit 1
fi

if [ -z "$WORKING_DIR" ]; then
  echo "Error: WORKING_DIR variable is not set."
  exit 1
fi

# Split the directories variable into an array
IFS=',' read -r -a SUBDIRS <<< "$directories"

# Loop through each subdirectory
for DIR in "${SUBDIRS[@]}"; do
  FULL_PATH="$WORKING_DIR/AzureFunctions/terraform/$DIR"

  # Check if the directory exists
  if [ -d "$FULL_PATH" ]; then
    echo "Processing directory: $FULL_PATH"

    # Navigate to the directory
    cd "$FULL_PATH"

    # Format Terraform files
    echo "Formatting Terraform configuration in $FULL_PATH..."
    terraform fmt -recursive

    echo "Formatting completed for $FULL_PATH."
  else
    echo "Directory not found: $FULL_PATH"
  fi
done

echo "Terraform formatting completed for all directories."
