output "id" {
  value = azurerm_storage_share.storage_share.id
}

output "name" {
  value = var.name
}

output "resource_manager_id" {
  value = azurerm_storage_share.storage_share.resource_manager_id
}

output "url" {
  value = azurerm_storage_share.storage_share.url
}
