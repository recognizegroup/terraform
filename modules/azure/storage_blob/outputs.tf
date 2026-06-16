output "storage_blob_url" {
  value     = "https://${azurerm_storage_blob.storage_blob.storage_account_name}.blob.core.windows.net/${azurerm_storage_blob.storage_blob.storage_container_name}/${azurerm_storage_blob.storage_blob.name}${data.azurerm_storage_account_sas.sas_token.sas}"
  sensitive = true
}

# Plain blob URL without SAS. Use together with a managed identity that has
# (at least) Storage Blob Data Reader on the account, e.g. for identity-based
# WEBSITE_RUN_FROM_PACKAGE when shared key access is disabled on the account.
output "storage_blob_url_without_sas" {
  value = "https://${azurerm_storage_blob.storage_blob.storage_account_name}.blob.core.windows.net/${azurerm_storage_blob.storage_blob.storage_container_name}/${azurerm_storage_blob.storage_blob.name}"
}
