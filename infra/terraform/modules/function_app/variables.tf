variable "name" {
  type        = string
  description = "Function App name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name for the Function App."
}

variable "storage_account_access_key" {
  type        = string
  description = "Storage account access key for the Function App."
  sensitive   = true
}

variable "app_insights_connection_string" {
  type        = string
  description = "App Insights connection string."
  sensitive   = true
}

variable "subnet_id" {
  type        = string
  description = "Optional subnet id for VNet integration."
  default     = null
}

variable "servicebus_fqdn" {
  type        = string
  description = "Service Bus fully qualified namespace."
}

variable "servicebus_queue_name" {
  type        = string
  description = "Service Bus queue name."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

