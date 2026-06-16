variable "storage_container_name" {
  type        = string
  description = "Name of the storage container."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account."
}

variable "storage_container_access_type" {
  type        = string
  description = "Access type of the storage account."
  default     = "private"
}

variable "storage_use_azuread" {
  type        = bool
  description = "Authenticate Storage data-plane operations (container create/read) with Entra ID (Azure AD) instead of the account access key. Set to true when shared key access is disabled on the account."
  default     = false
}
