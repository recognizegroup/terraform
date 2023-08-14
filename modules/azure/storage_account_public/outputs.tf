output "name" {
  value = azurerm_storage_account.storage_account.name
}

output "id" {
  value = azurerm_storage_account.storage_account.id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "primary_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

output "primary_connection_string" {
  value     = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}

# Deprecated in favor of primary_connection_string
# TODO: Remove deprecated output in next major version
output "primary_access_connection_string" {
  description = "Deprecated in favor of primary_connection_string"
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
}
