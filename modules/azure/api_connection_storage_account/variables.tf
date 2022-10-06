variable "resource_group_name" {
  type        = string
  description = "Location For the Connection"
}

variable "connection_name" {
  type = string
  description = "connection name"
}

variable "storage_account_name" {
  type = string
  description = "storage account name"
}

variable "storage_account_access_key" {
  type = string
  description = "acess key"
}

variable "connection_api_name" {
  type = string
  description = "api name for the connection, Possible values: azuretables, azureblob"
}
