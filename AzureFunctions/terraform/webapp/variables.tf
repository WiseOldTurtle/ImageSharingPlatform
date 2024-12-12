
variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "suffix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "repository_url" {
  description = "The repository URL for the Azure Static Web App"
  type        = string
}

variable "branch" {
  description = "The branch to deploy from"
  type        = string
}

# this is for your webapp to create a github workflow (this value is pulled through ADO variable - see YAMl line 149 for reference)
variable "github_access_token" {
  description = "The GitHub personal access token for the repository"
  type        = string
  sensitive   = true
}

variable "app_location" {
  description = "The app location in the repository"
  type        = string
}

variable "api_location" {
  description = "The API location in the repository"
  type        = string
}

variable "sku" {
  description = "The SKU tier for the Static Web App"
  type        = string
  default     = "Free"
}

variable "sku_code" {
  description = "The SKU code for the Static Web App"
  type        = string
  default     = "Free"
}

variable "enable_distributed_backends" {
  description = "Whether to enable distributed backends for the Static Web App"
  type        = bool
  default     = false
}

variable "static_webapp_location" {
  description = "Location for the Azure Static Web App"
  type        = string
  default     = "West Europe"  # Replace with your desired location
}
