variable "location" {
  type        = string
  description = "Azure region for the terraform state resource group/storage account."
  default     = "westeurope"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name for the terraform state resources."
  default     = "rg-tfstate"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix for the storage account name (must be globally unique after suffix)."
  default     = "sttfstate"
}

variable "container_name" {
  type        = string
  description = "Blob container name for Terraform state."
  default     = "tfstate"
}

