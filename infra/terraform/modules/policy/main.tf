locals {
  tag_exists_conditions = [
    for t in var.required_tags : {
      field  = "tags[${t}]"
      exists = "true"
    }
  ]

  policy_rule = {
    if = {
      anyOf = [
        {
          allOf = concat(
            [{ field = "type", notEquals = "Microsoft.Resources/subscriptions/resourceGroups" }],
            [for c in local.tag_exists_conditions : { field = c.field, exists = "false" }]
          )
        }
      ]
    }
    then = {
      effect = "deny"
    }
  }
}

resource "azurerm_policy_definition" "require_tags" {
  count        = var.enabled ? 1 : 0
  name         = "${var.name}-require-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require tags on resources (${join(", ", var.required_tags)})"

  policy_rule = jsonencode(local.policy_rule)
}

resource "azurerm_resource_group_policy_assignment" "require_tags" {
  count                = var.enabled ? 1 : 0
  name                 = "${var.name}-require-tags"
  policy_definition_id = azurerm_policy_definition.require_tags[0].id
  resource_group_id    = var.scope_id
}

