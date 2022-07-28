variable "remote_file_name" {
  type        = string
  description = "The name of the storage blob. Must be unique within the storage container the blob is located."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "storage_container_name" {
  type        = string
  description = "The name of the storage container in which this blob should be created."
}

variable "storage_connection_string" {
  type = string
  description = "The connection string for the storage account to which this SAS applies. Typically directly from the primary_connection_string attribute of a terraform created azurerm_storage_account resource."
}

variable "type" {
  type        = string
  description = "The type of the storage blob to be created. Possible values are Append, Block or Page. Changing this forces a new resource to be created."
  default     = "Block"
}

variable "local_source" {
  type        = string
  description = "An absolute path to a file on the local system. This field cannot be specified for Append blobs and cannot be specified if source_content or source_uri is specified."
  default     = null
}

