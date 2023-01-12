variable "name" {
  type        = string
  description = "The name of the share."
}

variable "storage_account_name" {
  type        = string
  description = "Specifies the storage account in which to create the share."
}

variable "quota" {
  type        = string
  description = "The maximum size of the share, in gigabytes."
  default     = 5120 // FIXME: or should we make this a required by removing the default if we are going to make this a major change?
}

variable "enabled_protocol" {
  type        = string
  description = "The protocol used for the share. Possible values are SMB and NFS."
  default     = "SMB"
}

variable "directories_to_create" {
  type        = list(string)
  description = "List Of Folders To Create within the file share"
  default     = null
}


