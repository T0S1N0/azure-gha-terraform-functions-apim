variable "name" {
  type        = string
  description = "Application Insights name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "workspace_id" {
  type        = string
  description = "Log Analytics workspace id."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

