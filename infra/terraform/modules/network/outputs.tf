output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "VNet id."
}

output "subnet_ids" {
  value       = { for k, s in azurerm_subnet.this : k => s.id }
  description = "Subnet ids by name."
}

