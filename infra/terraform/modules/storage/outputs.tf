output "name" {
  value       = azurerm_storage_account.this.name
  description = "Storage account name."
}

output "id" {
  value       = azurerm_storage_account.this.id
  description = "Storage account id."
}

output "primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "Primary access key."
  sensitive   = true
}

