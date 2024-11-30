variable "resource_group_name" {
  description = "Name of the management resource group"
  type        = string
  default     = "rg-management-wotlab01"  # Default value, adjust as needed
}

variable "location" {
  description = "Azure location for the resources"
  type        = string
  default     = "West Europe"  # Default Azure region
}

variable "github_access_token" {
  description = "GitHub Personal Access Token for deployments"
  type        = string
  sensitive   = true  # Marked sensitive for added security
}

variable "tenant_id" {
  description = "Azure tenant ID for the current subscription"
  type        = string
}

variable "object_id" {
  description = "Azure Object ID for the Service Principal or User to grant Key Vault permissions"
  type        = string
}
