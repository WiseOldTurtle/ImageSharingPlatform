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

# Define Resource Group for Management Resources
resource "azurerm_resource_group" "management_rg" {
  name     = "rg-${var.resource_group_name}-${var.suffix}"
  location = var.location
}

# Define Key Vault for Secrets Management
resource "azurerm_key_vault" "management_kv" {
  name                = "${var.prefix}-kv-${var.suffix}"
  location            = azurerm_resource_group.management_rg.location
  resource_group_name = azurerm_resource_group.management_rg.name
  sku_name            = "standard"
  tenant_id = var.tenant_id
}

# Define Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "management_kv_policy" {
  key_vault_id = azurerm_key_vault.management_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge"
  ]
}

output "key_vault_name" {
  value = azurerm_key_vault.management_kv.name
}

output "key_vault_id" {
  value = azurerm_key_vault.management_kv.id
}
