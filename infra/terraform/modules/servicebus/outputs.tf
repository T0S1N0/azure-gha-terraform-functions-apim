output "namespace_id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "Namespace id."
}

output "namespace_name" {
  value       = azurerm_servicebus_namespace.this.name
  description = "Namespace name."
}

output "namespace_fqdn" {
  value       = "${azurerm_servicebus_namespace.this.name}.servicebus.windows.net"
  description = "Namespace fully qualified domain name."
}

output "queue_id" {
  value       = azurerm_servicebus_queue.this.id
  description = "Queue id."
}

output "queue_name" {
  value       = azurerm_servicebus_queue.this.name
  description = "Queue name."
}

