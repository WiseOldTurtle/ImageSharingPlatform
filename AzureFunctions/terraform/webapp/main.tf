terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"  # Updated provider version for Linux Function App support, other fApp is depreciated
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
    key                   = "management.tfstate"
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

  # Reference the ARM template file # TODO. replace hardcoded filepath with $path.module 
  template_content = file("${path.module}/staticwebapp-staticsite.json")


  parameters_content = jsonencode({
    staticSiteName          = { value = azurerm_static_site.frontend.name }
    storageConnectionString = { value = data.terraform_remote_state.management.outputs.storage_account_connection_string }  # Pull from management state file
    imageResolution         = { value = var.image_resolution }
    logLevel                = { value = var.log_level }
  })
}

resource "azurerm_resource_group_template_deployment" "function_app_deployment" {
  name                = "function-app-deployment"
  resource_group_name = azurerm_resource_group.webapp_rg.name
  deployment_mode     = "Incremental"

  # Reference the ARM template file # TODO. replace hardcoded filepath with $path.module 
  template_content = file("functionapp-arm-template.json")

  parameters_content = jsonencode({
    functionAppPlanName     = { value = "function-app-plan" }
    functionAppName         = { value = "frontend-function-app" }
    location                = { value = azurerm_resource_group.webapp_rg.location }
    storageConnectionString = { value = data.terraform_remote_state.management.outputs.storage_account_connection_string }
  })
}

# Data source for GitHub token from Key Vault
data "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  key_vault_id = data.terraform_remote_state.management.outputs.key_vault_id
}

output "management_outputs" {
  value = data.terraform_remote_state.management.outputs
}

