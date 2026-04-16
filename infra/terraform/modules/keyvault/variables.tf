variable "name" {
  type        = string
  description = "Key Vault name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tenant_id" {
  type        = string
  description = "AAD tenant id."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled."
  default     = true
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection (recommended for production)."
  default     = false
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft delete retention in days."
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

