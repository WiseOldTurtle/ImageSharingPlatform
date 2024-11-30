variable "resource_group_name" {
  description = "Name of the management resource group"
  type        = string
  default     = "rg-management-wotlab01"
}

variable "location" {
  description = "Azure location for the resources"
  type        = string
  default     = "West Europe"
}

variable "github_access_token" {
  description = "GitHub Personal Access Token"
  type        = string
}