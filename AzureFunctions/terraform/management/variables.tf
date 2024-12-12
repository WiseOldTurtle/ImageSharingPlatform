
variable "resource_group_name" {
  description = "Name of the Resource Group for Management Resources"
  type        = string
}

variable "location" {
  description = "Azure Region for Management Resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "suffix" {
  description = "Suffix for resource naming"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "administrator_object_id" {
  description = "Object ID of the administrator for Key Vault access"
  type        = string
}

variable "backend_storage_account_name" {
  description = "Storage account for Terraform backend"
  type        = string
}

variable "backend_container_name" {
  description = "Container name for Terraform backend"
  type        = string
}

# variable "key_vault_name" {
#   description = "Name of the Azure Key Vault"
#   type        = string
# }
