terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"  # Upgraded to match webapp
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

# Resource Group Module
module "management_rg" {
  source   = "../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "unique" {
  byte_length = 5
}

# Storage Account for Images
resource "azurerm_storage_account" "image_storage" {
  name                     = "imagestore${random_id.unique.hex}"
  resource_group_name      = module.management_rg.name
  location                 = module.management_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Storage Container
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.image_storage.name
  container_access_type = "blob"
}

# Key Vault Module
module "key_vault" {
  source              = "../modules/key_vault"
  name                = "kv-wotlab01"
  resource_group_name = module.management_rg.name
  location            = module.management_rg.location
  github_token        = var.github_access_token  # referenced securely
}

# Outputs
output "key_vault_id" {
  value = module.key_vault.key_vault_id
}

output "storage_account_connection_string" {
  value     = azurerm_storage_account.image_storage.primary_connection_string
  sensitive = true
}
