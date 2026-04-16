variable "principal_id" {
  type        = string
  description = "Principal id (object id) to assign the role to."
}

variable "scope" {
  type        = string
  description = "Scope for the role assignment."
}

variable "role_definition_name" {
  type        = string
  description = "Built-in role definition name."
}

variable "skip_aad_check" {
  type        = bool
  description = "Skip AAD check (useful for newly-created identities)."
  default     = true
}

