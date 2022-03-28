variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "queue_names" {
  type        = set(string)
  description = "Add predefined queue names in this storage."
  default     = []
}