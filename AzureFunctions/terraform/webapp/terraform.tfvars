# Update Values

# Azure Resource Group and Location (Prefix and Suffix are used to apply a naming convention to keep your resource naming clean)
resource_group_name      = "webapp"
location                 = "UK South"
prefix                   = "wot"
suffix                   = "wotlab01"

# GitHub Repository Configuration
repository_url           = ""
branch                   = "main"

# Web App Configuration
app_location             = "AzureFunctions/client"
api_location             = "AzureFunctions/api/uploadImage"
static_webapp_location   = "West Europe"

# SKU Configuration for Static Web App
sku                      = "Free"
sku_code                 = "Free"

# Feature Enablement
enable_distributed_backends = false
