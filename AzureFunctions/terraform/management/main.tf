terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
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

# Resource Group
resource "azurerm_resource_group" "management_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Random ID for Storage Account
resource "random_id" "unique" {
  byte_length = 5
}

# Storage Account for Images
resource "azurerm_storage_account" "image_storage" {
  name                     = "imagestore${random_id.unique.hex}"
  resource_group_name      = azurerm_resource_group.management_rg.name
  location                 = azurerm_resource_group.management_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.image_storage.name
  container_access_type = "blob"
}

# Key Vault
resource "azurerm_key_vault" "management_kv" {
  name                = "kv-wotlab01"
  resource_group_name = azurerm_resource_group.management_rg.name
  location            = azurerm_resource_group.management_rg.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id
    secret_permissions = ["Get", "Set"]
  }
}

# GitHub Token in Key Vault
resource "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  value        = var.github_access_token
  key_vault_id = azurerm_key_vault.management_kv.id

  lifecycle {
    prevent_destroy = true
  }
}

# Outputs
output "key_vault_id" {
  value = azurerm_key_vault.management_kv.id
}

output "storage_account_connection_string" {
  value     = azurerm_storage_account.image_storage.primary_connection_string
  sensitive = true
}
