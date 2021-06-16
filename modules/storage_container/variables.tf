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
  default     = "Private"
}
