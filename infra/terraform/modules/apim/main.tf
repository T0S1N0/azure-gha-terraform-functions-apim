resource "azurerm_api_management" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name = "Developer_1"
  tags     = var.tags
}

resource "azurerm_api_management_api" "this" {
  name                = var.api_name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.this.name

  revision     = "1"
  display_name = var.api_name
  path         = var.api_path
  protocols    = ["https"]

  service_url = var.function_base_url

  import {
    content_format = var.openapi_format
    content_value  = var.openapi_spec
  }
}

