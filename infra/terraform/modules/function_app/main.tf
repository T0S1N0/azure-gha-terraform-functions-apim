resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.plan_sku_name
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id            = azurerm_service_plan.this.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  virtual_network_subnet_id  = var.subnet_id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    application_stack {
      node_version = "20"
    }
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION           = "~4"
    FUNCTIONS_WORKER_RUNTIME              = "node"
    WEBSITE_RUN_FROM_PACKAGE              = "1"
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string

    ServiceBus__FullyQualifiedNamespace = var.servicebus_fqdn
    ServiceBus__QueueName               = var.servicebus_queue_name
  }

  tags = var.tags
}

