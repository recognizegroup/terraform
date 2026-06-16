variable "storage_account_id" {
  type        = string
  description = "Resource ID of the storage account that hosts the table (e.g. azurerm_storage_account.x.id)."
}

variable "storage_table_name" {
  type        = string
  description = "Name of the storage table."
}
