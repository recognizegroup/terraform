variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "storage_table_name" {
  type        = string
  description = "Name of the storage table"
}

variable "partition_key" {
  type        = string
  description = "The key for the partition where the entity will be inserted"
}

variable "row_key" {
  type        = string
  description = "The key for the row where the entity will be inserted"
}

variable "entity" {
  type        = any
  description = "A map of key/value pairs that describe the entity to be inserted into a table"
}
