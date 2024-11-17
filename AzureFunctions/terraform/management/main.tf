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


resource "azurerm_resource_group" "imagesRG" {
  name     = "rg-imageplatform-wotlab01"
  location = "West Europe"
}

resource "random_id" "unique_id" {
  byte_length = 8
}

resource "azurerm_storage_account" "image_storage" {
  name                     = "imagestorageaccount${random_id.unique_id.hex}"
  resource_group_name      = azurerm_resource_group.imagesRG.name
  location                 = azurerm_resource_group.imagesRG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.image_storage.name
  container_access_type = "blob"
}

# Create Key Vault # TODO
resource "azurerm_key_vault" "kv-wotlab01" {
  name                = "kv-wotlab01"
  location            = azurerm_resource_group.imagesRG.location
  resource_group_name = azurerm_resource_group.imagesRG.name

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
  value = azurerm_storage_account.image_storage.primary_connection_string
  sensitive = true
}
