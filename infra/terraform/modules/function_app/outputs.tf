output "name" {
  value       = azurerm_linux_function_app.this.name
  description = "Function App name."
}

output "id" {
  value       = azurerm_linux_function_app.this.id
  description = "Function App id."
}

output "default_hostname" {
  value       = azurerm_linux_function_app.this.default_hostname
  description = "Function App default hostname."
}

output "principal_id" {
  value       = azurerm_linux_function_app.this.identity[0].principal_id
  description = "System-assigned managed identity principal id."
}

