output "resource_group_name" {
  value       = azurerm_resource_group.tfstate.name
  description = "Resource group containing the Terraform backend storage."
}

output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "Storage account name for Terraform backend."
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "Blob container name for Terraform state."
}

