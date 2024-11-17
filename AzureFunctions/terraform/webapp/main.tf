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

# Data source to reference the management state and get the storage connection string
data "terraform_remote_state" "management" {
  backend = "azurerm"
  config = {
    resource_group_name   = "tfstate"
    storage_account_name  = "terraformstateprojwot1"
    container_name        = "tfstate"
    key                   = "management.tfstate"  # Ensure the correct path to the management tfstate
  }
}

# Resource group definition
resource "azurerm_resource_group" "webapp_rg" {
  name     = "rg-webapp-wotlab01"
  location = "westeurope"
}

# Static Web App deployment
resource "azurerm_static_site" "frontend" {
  name                = "frontend-webapp"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  location            = azurerm_resource_group.webapp_rg.location
  sku_tier            = "Free"  # For cost-effective solution
}

# ARM Template deployment reference (terraform module workaround)
resource "azurerm_resource_group_template_deployment" "frontend_appsettings" {
  name                = "frontend-webapp-casestudy"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  deployment_mode     = "Incremental"

  # Reference the ARM template file
  template_content = file("${path.module}/staticwebapp-staticsite.json")

  parameters_content = jsonencode({
    staticSiteName          = { value = azurerm_static_site.frontend.name }
    storageConnectionString = { value = data.terraform_remote_state.management.outputs.storage_account_connection_string }  # Pull from management state file
    imageResolution         = { value = var.image_resolution }
    logLevel                = { value = var.log_level }
  })
}

# Function App Plan (Consumption Plan)
resource "azurerm_function_app_plan" "function_plan" {
  name                = "function-app-plan"
  location            = azurerm_resource_group.webapp_rg.location
  resource_group_name = azurerm_resource_group.webapp_rg.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"  # Consumption Plan
    size = "Y1"       # For cost-effective hosting
  }
}

# Linux Function App Resource
resource "azurerm_linux_function_app" "function_app" {
  name                      = "frontend-function-app"
  location                  = azurerm_resource_group.webapp_rg.location
  resource_group_name       = azurerm_resource_group.webapp_rg.name
  service_plan_id           = azurerm_function_app_plan.function_plan.id
  storage_account_name      = data.terraform_remote_state.management.outputs.storage_account_name
  storage_account_access_key = data.terraform_remote_state.management.outputs.storage_account_access_key
  

  site_config {
    application_stack {
      node_version = "14"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "node"
    "AzureWebJobsStorage"      = data.terraform_remote_state.management.outputs.storage_account_connection_string
    "GITHUB_TOKEN"             = data.azurerm_key_vault_secret.github_token.value
  }
}

# Data source for GitHub token from Key Vault
data "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  key_vault_id = data.terraform_remote_state.management.outputs.key_vault_id
}

# Link GitHub Repository to Function App
resource "azurerm_linux_function_app_source_control" "github" {
  function_app_id  = azurerm_linux_function_app.function_app.id
  repo_url         = "https://github.com/WiseOldTurtle/ImageSharingPlatform"
  branch           = "main"
  repo_token       = data.azurerm_key_vault_secret.github_token.value
}
