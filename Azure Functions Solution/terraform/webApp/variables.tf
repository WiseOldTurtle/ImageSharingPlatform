variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     ="rg-webApp-wotlab01"
}

variable "location" {
  description = "Resource location"
  type        = string
  default     ="UK South"
}

variable "swa_name" {
  description = "Name of the Static Web App"
  type        = string
  default     ="PLACEHOLDER"
}

variable "swa_sku_tier" {
  description = "SKU tier for Static Web App"
  type        = string
  default     ="PLACEHOLDER"
}

variable "app_setting1" {
  description = "Custom app setting 1"
  type        = string
  default     ="PLACEHOLDER"
}

variable "app_setting2" {
  description = "Custom app setting 2"
  type        = string
  default     ="PLACEHOLDER"
}