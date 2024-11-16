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

# Create Key Vault
resource "azurerm_key_vault" "kvCaseStudy" {
  name                = "kv-wotlab01"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name

  sku_name = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["get", "set", "list"]
  }
}

# Store GitHub token in Key Vault
resource "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  value        = var.github_token  # externally reference for security
  key_vault_id = azurerm_key_vault.kvCaseStudy.id
}

# Output the secret URI
output "github_token_secret_id" {
  value = azurerm_key_vault_secret.github_token.id
}



# Output the Storage Account Connection String
output "storage_account_connection_string" {
  value = azurerm_storage_account.webappstore.primary_connection_string
  sensitive = true
}
