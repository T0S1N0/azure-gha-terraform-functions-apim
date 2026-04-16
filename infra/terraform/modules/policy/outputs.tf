output "assignment_id" {
  value       = try(azurerm_resource_group_policy_assignment.require_tags[0].id, null)
  description = "Policy assignment id (or null when disabled)."
}

