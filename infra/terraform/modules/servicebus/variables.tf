variable "namespace_name" {
  type        = string
  description = "Service Bus namespace name."
}

variable "queue_name" {
  type        = string
  description = "Queue name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "sku" {
  type        = string
  description = "Namespace SKU."
  default     = "Standard"
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

