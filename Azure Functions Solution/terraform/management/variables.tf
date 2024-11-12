variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location for the resources"
  type        = string
  default     = "UK South"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
