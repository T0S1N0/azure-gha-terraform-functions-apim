variable "name" {
  type        = string
  description = "Policy definition/assignment name prefix."
}

variable "scope_id" {
  type        = string
  description = "Scope to assign the policy to (resource group or subscription id)."
}

variable "required_tags" {
  type        = list(string)
  description = "Tag keys that must exist on resources."
  default     = ["env", "owner"]
}

variable "enabled" {
  type        = bool
  description = "Whether policy is enabled."
  default     = true
}

