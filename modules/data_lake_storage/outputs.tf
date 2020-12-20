output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "storage_container_name" {
  value = azurerm_storage_data_lake_gen2_filesystem.filesystem.name
}

output "folders_and_permissions" {
  value = azurerm_storage_data_lake_gen2_path.path
}
