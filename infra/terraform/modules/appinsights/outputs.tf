output "connection_string" {
  value       = azurerm_application_insights.this.connection_string
  description = "App Insights connection string."
  sensitive   = true
}

output "instrumentation_key" {
  value       = azurerm_application_insights.this.instrumentation_key
  description = "App Insights instrumentation key."
  sensitive   = true
}

