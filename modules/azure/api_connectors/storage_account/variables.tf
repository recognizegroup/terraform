variable "resource_group_name" {
  type        = string
  description = "Location For the Connection"
}

variable "connection_name" {
  type        = string
  description = "Name of the connection"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the connected storage account"
}

variable "storage_account_access_key" {
  type        = string
  description = "Access Key for the storage account"
}

variable "connection_api_name" {
  type        = string
  description = "Name of the managed api, Possible values: azuretables, azureblob"
  validation {
    condition     = contains(["azuretables", "azureblob"], var.connection_api_name)
    error_message = "Argument \"connection_api_name\" must be either \"azuretables\" or \"azureblob\"."
  }
}
