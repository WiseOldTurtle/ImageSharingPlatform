variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-management-wotlab01"
}

variable "location" {
  description = "The Azure location for the resources"
  type        = string
  default     = "UK South"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
  default     = "webappstorebackendcs"
}

# variable "github_access_token" { # TODO. Use for TFVAR refernce
#   description = "GitHub Personal Access Token"
#   type        = string
# }

