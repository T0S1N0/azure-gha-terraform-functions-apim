output "gateway_url" {
  value       = azurerm_api_management.this.gateway_url
  description = "APIM gateway URL."
}

output "name" {
  value       = azurerm_api_management.this.name
  description = "APIM service name."
}

output "api_id" {
  value       = azurerm_api_management_api.this.id
  description = "APIM API id."
}

