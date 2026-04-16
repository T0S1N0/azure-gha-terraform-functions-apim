output "resource_group_name" {
  value       = module.rg.name
  description = "Resource group name."
}

output "function_app_name" {
  value       = module.func.name
  description = "Function app name."
}

output "apim_gateway_url" {
  value       = module.apim.gateway_url
  description = "APIM gateway URL."
}

output "servicebus_namespace_fqdn" {
  value       = module.sb.namespace_fqdn
  description = "Service Bus namespace FQDN."
}

