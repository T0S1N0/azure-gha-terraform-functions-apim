data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = {
    project    = var.project
    env        = var.environment
    owner      = var.owner
    costCenter = var.cost_center
  }

  storage_name = substr(replace("st${var.project}${var.environment}${random_string.suffix.result}", "-", ""), 0, 24)
  sb_name      = substr(replace("sb${var.project}${var.environment}${random_string.suffix.result}", "-", ""), 0, 50)
  kv_name      = substr(replace("kv-${var.project}-${var.environment}-${random_string.suffix.result}", "_", "-"), 0, 24)
  apim_name    = substr(replace("apim-${var.project}-${var.environment}-${random_string.suffix.result}", "_", "-"), 0, 50)
  func_name    = substr(replace("func-${var.project}-${var.environment}-${random_string.suffix.result}", "_", "-"), 0, 60)
}

module "rg" {
  source   = "../../modules/rg"
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "law" {
  source              = "../../modules/log-analytics"
  name                = "log-${local.name_prefix}"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = local.tags
}

module "ai" {
  source              = "../../modules/appinsights"
  name                = "appi-${local.name_prefix}"
  resource_group_name = module.rg.name
  location            = module.rg.location
  workspace_id        = module.law.id
  tags                = local.tags
}

module "network" {
  source              = "../../modules/network"
  name                = "vnet-${local.name_prefix}"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = local.tags

  subnets = {
    "snet-functions" = {
      address_prefixes = ["10.10.1.0/24"]
      delegation = {
        name = "function-delegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
    "snet-private-endpoints" = {
      address_prefixes = ["10.10.2.0/24"]
    }
  }
}

module "storage" {
  source              = "../../modules/storage"
  name                = local.storage_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = local.tags
}

module "sb" {
  source              = "../../modules/servicebus"
  namespace_name      = local.sb_name
  queue_name          = "demo"
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = local.tags
}

module "kv" {
  source              = "../../modules/keyvault"
  name                = local.kv_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

module "func" {
  source                         = "../../modules/function_app"
  name                           = local.func_name
  resource_group_name            = module.rg.name
  location                       = module.rg.location
  storage_account_name           = module.storage.name
  storage_account_access_key     = module.storage.primary_access_key
  app_insights_connection_string = module.ai.connection_string
  subnet_id                      = module.network.subnet_ids["snet-functions"]
  servicebus_fqdn                = module.sb.namespace_fqdn
  servicebus_queue_name          = module.sb.queue_name
  tags                           = local.tags
}

module "sb_sender_rbac" {
  source               = "../../modules/rbac"
  principal_id         = module.func.principal_id
  scope                = module.sb.namespace_id
  role_definition_name = "Azure Service Bus Data Sender"
}

module "apim" {
  source              = "../../modules/apim"
  name                = local.apim_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  function_base_url   = "https://${module.func.default_hostname}/api"
  openapi_spec        = file("${path.module}/../../../../app/contracts/openapi.json")
  openapi_format      = "openapi+json"
  tags                = local.tags
}

module "policy" {
  source        = "../../modules/policy"
  name          = local.name_prefix
  scope_id      = module.rg.id
  enabled       = var.enable_policy
  required_tags = ["env", "owner", "project", "costCenter"]
}

