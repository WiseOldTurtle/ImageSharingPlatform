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
  location = "UK South"
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

  # Reference the ARM template file (staticwebapp-arm-staticsite-config.json)
  template_content = file("${path.module}/../webapp/staticwebapp-arm-staticsite-config.json")

  parameters_content = jsonencode({
    staticSiteName          = { value = azurerm_static_site.frontend.name }
    storageConnectionString = { value = data.terraform_remote_state.management.outputs.storage_account_connection_string }  # Pull from management state file
    imageResolution         = { value = var.image_resolution }
    # linkShortenerApiKey     = { value = var.link_shortener_api_key }
    # authSecret              = { value = var.auth_secret }
    logLevel                = { value = var.log_level }
  })
}
