variable "storage_account_name" {
  type        = string
  description = "Name of the storage account"
}

variable "storage_table_name" {
  type        = string
  description = "Name of the storage table"
}

variable "rows" {
  type = set(object({
    partition_key = string
    row_key       = string
    entity        = any
  }))
  description = "Rows to insert into the table. Every entry should contain a partition key, a row key and a set of properties."
}
