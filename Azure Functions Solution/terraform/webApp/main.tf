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
      key                  = "webApp.tfstate"
  }
}

resource "azurerm_resource_group" "imageUpload" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_static_site" "frontend" {
  name                = var.swa_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku_tier            = var.swa_sku_tier
}

resource "azurerm_resource_group_template_deployment" "frontend_appsettings" {
  deployment_mode     = "Incremental"
  name                = "frontend-appsettings"
  resource_group_name = data.azurerm_resource_group.rg.name

  template_content = file("staticwebapp-arm-staticsite-config.json")
  
  parameters_content = jsonencode({
    staticSiteName = {
      value = azurerm_static_site.frontend.name
    },
    appSetting1 = {
      value = var.app_setting1
    },
    appSetting2 = {
      value = var.app_setting2
    }
  })
}
