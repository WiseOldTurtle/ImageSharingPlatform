#!/bin/bash

# Format all .tf files
find $(System.DefaultWorkingDirectory)/AzureFunctions/terraform -name "*.tf" | while read file; do
  echo "Formatting $file..."
  terraform fmt -check -diff "$(dirname "$file")" >> trivy-reports/terraform_fmt.log
done
