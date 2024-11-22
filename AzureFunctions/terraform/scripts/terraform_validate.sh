#!/bin/bash

# Validate all .tf files
find $(System.DefaultWorkingDirectory)/terraform -name "*.tf" | while read file; do
  echo "Validating $file..."
  terraform validate "$(dirname "$file")" >> trivy-reports/terraform_validate.log
done
