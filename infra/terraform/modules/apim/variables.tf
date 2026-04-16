variable "name" {
  type        = string
  description = "API Management service name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "publisher_name" {
  type        = string
  description = "APIM publisher name."
}

variable "publisher_email" {
  type        = string
  description = "APIM publisher email."
}

variable "function_base_url" {
  type        = string
  description = "Backend base URL for the Function App (e.g. https://<host>/api)."
}

variable "openapi_spec" {
  type        = string
  description = "OpenAPI spec content (JSON or YAML)."
}

variable "openapi_format" {
  type        = string
  description = "OpenAPI import format."
  default     = "openapi+json"
}

variable "api_name" {
  type        = string
  description = "APIM API name."
  default     = "demo-api"
}

variable "api_path" {
  type        = string
  description = "APIM API path segment."
  default     = "demo"
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}

