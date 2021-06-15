variable "storage_container_name" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_container_access_type" {
  type        = string
  description = "Name of the storage account"
  default     = "Private"
}
