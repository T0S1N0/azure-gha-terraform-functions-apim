variable "project" {
  type        = string
  description = "Short project code used for naming."
  default     = "cce"
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "westeurope"
}

variable "owner" {
  type        = string
  description = "Owner tag value."
  default     = "you"
}

variable "cost_center" {
  type        = string
  description = "Cost center tag value."
  default     = "personal"
}

variable "apim_publisher_name" {
  type        = string
  description = "APIM publisher name."
  default     = "Cloud Engineering"
}

variable "apim_publisher_email" {
  type        = string
  description = "APIM publisher email."
  default     = "you@example.com"
}

variable "enable_policy" {
  type        = bool
  description = "Enable tag-requirement Azure Policy assignment."
  default     = true
}

variable "enable_rbac_role_assignments" {
  type        = bool
  description = "Enable creation of Azure RBAC role assignments (requires Owner/User Access Administrator permissions)."
  default     = false
}

