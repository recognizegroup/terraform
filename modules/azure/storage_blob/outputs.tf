output "storage_blob_url" {
  value     = "https://${azurerm_storage_blob.storage_blob.storage_account_name}.blob.core.windows.net/${azurerm_storage_blob.storage_blob.storage_container_name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_sas.sas_token.sas}"
  sensitive = true
}
