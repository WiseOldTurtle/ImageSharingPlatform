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

data "azurerm_client_config" "current" {}

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

# Create Key Vault # TODO
resource "azurerm_key_vault" "kv-wotlab01" {
  name                = "kv-wotlab01"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name

  sku_name = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

# Store GitHub token in Key Vault 
resource "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  value        = "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"  # TODO. reference through ADO Variable 
  key_vault_id = azurerm_key_vault.kv-wotlab01.id
}

# Output the secret URI # TODO
output "github_token_secret_id" {
  value = azurerm_key_vault_secret.github_token.id
}

# Output the Storage Account Connection String
output "storage_account_connection_string" {
  value = azurerm_storage_account.webappstore.primary_connection_string
  sensitive = true
}
