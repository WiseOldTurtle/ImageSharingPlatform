variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Resource location"
  default     = "East US"
}

variable "swa_name" {
  description = "Name of the Static Web App"
}

variable "swa_sku_tier" {
  description = "SKU tier for Static Web App"
  default     = "Free"
}

variable "app_setting1" {
  description = "Custom app setting 1"
}

variable "app_setting2" {
  description = "Custom app setting 2"
}