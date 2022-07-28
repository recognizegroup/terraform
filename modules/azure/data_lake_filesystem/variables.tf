variable "storage_account_id" {
  type        = string
  description = "ID of the storage account."
}

variable "filesystem_name" {
  type        = string
  description = "Name of the ADLS gen2 filesystem."
}

variable "root_permissions" {
  type        = list
  description = "List of ADLS gen2 root permissions."
}

variable "filesystem_paths" {
  type        = list
  description = "List of ADLS gen2 filesystem paths with permissions."
}
