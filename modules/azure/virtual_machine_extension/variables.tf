variable "location" {
  type        = string
  description = "A datacenter location in Azure."
}

variable "name"{
  type = string
  description = "extension name"
}

variable "virtual_machine_id" {
  type = string
  description = "virtual machine id"
}

variable "list_of_file_uris" {
  type = list(string)
  description = "uris for all the file that have to be downloaded"
  default = null
}

variable "storage_account_name" {
  type = string
  description = "storage account name containing files"
}
variable "storage_account_key" {
  type = string
  description = "the access key to the storage account containing required files"
}

variable "command_to_execute"{
  type = string
  description = "cli command to execute"
  default = null
}
