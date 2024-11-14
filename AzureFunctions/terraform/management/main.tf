terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "terraformstateprojwot1"
      container_name       = "tfstate"
      key                  = "management.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "webapp_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Storage Account for webapp backend
resource "azurerm_storage_account" "webappstore" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.webapp_rg.name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}

# Output the Storage Account Connection String
output "storage_account_connection_string" {
  value = azurerm_storage_account.webappstore.primary_connection_string
  sensitive = true
}
