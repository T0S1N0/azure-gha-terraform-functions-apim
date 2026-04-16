variable "name" {
  type        = string
  description = "Storage account name (globally unique, 3-24 lowercase letters/numbers)."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

