variable "storage_account_id" {
  type        = string
  description = "ID of the storage account."
}

variable "adls_filesystem_name" {
  type        = string
  description = "Name of the ADLS gen2 filesystem."
}

variable "adls_root_permissions" {
  type        = list
  description = "Llist of ADLS gen2 root permissions."
}

variable "adls_filesystem_paths" {
  type        = list
  description = "List of ADLS gen2 filesystem paths with permissions."
}
