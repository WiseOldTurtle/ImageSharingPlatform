#!/bin/bash

set -e

ACTION=$1
DIR=$2
WORKING_DIR=$3

echo "Running Terraform $ACTION for $DIR"

# Initialize Terraform
terraform -chdir="$WORKING_DIR/$DIR" init \
  -backend-config="resource_group_name=$backendRGName" \
  -backend-config="storage_account_name=$backendStorageAccountName" \
  -backend-config="container_name=$backendContainerName" \
  -backend-config="key=${DIR}.tfstate"

# Perform action-specific tasks
case "$ACTION" in
  Test)
    mkdir -p "$WORKING_DIR/validation-reports/$DIR"
    terraform -chdir="$WORKING_DIR/$DIR" validate > "$WORKING_DIR/validation-reports/$DIR/validate.log"
    terraform -chdir="$WORKING_DIR/$DIR" fmt -check > "$WORKING_DIR/validation-reports/$DIR/fmt.log"
    ;;
  Plan)
    mkdir -p "$WORKING_DIR/plan-reports/$DIR"
    terraform -chdir="$WORKING_DIR/$DIR" plan -out="$WORKING_DIR/plan-reports/$DIR/tfplan"
    ;;
  Apply)
    terraform -chdir="$WORKING_DIR/$DIR" apply -auto-approve "$WORKING_DIR/plan-reports/$DIR/tfplan"
    ;;
  Destroy)
    terraform -chdir="$WORKING_DIR/$DIR" destroy -auto-approve
    ;;
  *)
    echo "Invalid action: $ACTION"
    exit 1
    ;;
esac
