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
      key                  = "webapp.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data Point referencing state file from management to call outputs and kv properties
data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "terraformstateprojwot1"
    container_name       = "tfstate"
    key                  = "management.tfstate"
  }
}

# Data point referencing running user (Service Principal) 
data "azurerm_client_config" "current" {}

# Define Resource Group
resource "azurerm_resource_group" "webapp_rg" {
  name     = "rg-${var.resource_group_name}-${var.suffix}"
  location = var.location
}

# Random string generation to keep stroage account name unique (1 byte is 2 characters)
resource "random_id" "storage_suffix" {
  byte_length = 4
}

# Define Storage Account for Function App (lower keeps the text lowercase) - max characters length for name is 23 characters
resource "azurerm_storage_account" "webapp_storage" {
  name                     = lower("${var.prefix}storage${random_id.storage_suffix.hex}")
  resource_group_name      = azurerm_resource_group.webapp_rg.name
  location                 = azurerm_resource_group.webapp_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.webapp_storage.name
  container_access_type = "private"
}

# If using a managed identity you can un-comment the KV secret and Access policy resources 
# resource "azurerm_key_vault_secret" "storage_connection_string" {
#   name         = "storage-connection-string"
#   value        = azurerm_storage_account.webapp_storage.primary_connection_string
#   key_vault_id = data.terraform_remote_state.management.outputs.key_vault_id
# }

# resource "azurerm_key_vault_access_policy" "function_app_policy" {
#   key_vault_id = data.terraform_remote_state.management.outputs.key_vault_id

#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = azurerm_linux_function_app.webapp_function.identity[0].principal_id


#   secret_permissions = ["Get", "List", "Set"]
# }

# Managed Identity role assignment for access to Storage Account to upload blobs
resource "azurerm_role_assignment" "function_blob_access" {
  scope                = azurerm_storage_account.webapp_storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = azurerm_linux_function_app.webapp_function.identity[0].principal_id
}


# Define App Service Plan
resource "azurerm_app_service_plan" "webapp_plan" {
  name                = "${var.prefix}-plan"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# Define Linux Function App
resource "azurerm_linux_function_app" "webapp_function" {
  name                       = "${var.prefix}-linux-function"
  location                   = azurerm_resource_group.webapp_rg.location
  resource_group_name        = azurerm_resource_group.webapp_rg.name
  service_plan_id            = azurerm_app_service_plan.webapp_plan.id
  storage_account_name       = azurerm_storage_account.webapp_storage.name
  storage_account_access_key = azurerm_storage_account.webapp_storage.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }

  # If you are going to not use a managed identity be sure to include the relevant python parameter in here referencing the KV secret (connection string)
  # I have added a placeholder for how you reference the kv in app settings
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = "python"
    "AZURE_STORAGE_ACCOUNT_NAME"     = azurerm_storage_account.webapp_storage.name
    # "STORAGE_CONNECTION_STRING"      = "@Microsoft.KeyVault(VaultName=${data.terraform_remote_state.management.outputs.key_vault_name};SecretName=storage-connection-string)"
    
  }

  identity {
    type = "SystemAssigned"
  }
}

# Define Static Web App
resource "azurerm_resource_group_template_deployment" "static_web_app" {
  name                = "${var.prefix}-static-web-app-deployment"
  resource_group_name = azurerm_resource_group.webapp_rg.name

  template_content = file("${path.module}/static_web_app_template.json")

  parameters_content = jsonencode({
    "name" = {
      value = "${var.prefix}-static-web-app"
    },
    "location" = {
      value = var.static_webapp_location
    },
    "sku" = {
      value = var.sku
    },
    "skucode" = {
      value = var.sku_code
    },
    "repositoryUrl" = {
      value = var.repository_url
    },
    "branch" = {
      value = var.branch
    },
    "repositoryToken" = {
      value = var.github_access_token
    },
    "appLocation" = {
      value = var.app_location
    },
    "apiLocation" = {
      value = var.api_location
    },
    "areStaticSitesDistributedBackendsEnabled" = {
      value = var.enable_distributed_backends
    }
  })

  deployment_mode = "Incremental"
}
