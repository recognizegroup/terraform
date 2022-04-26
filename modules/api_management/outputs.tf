output "name" {
  value = azurerm_api_management.api_management.name
}

output "principal_id" {
  value = azurerm_api_management.api_management.identity[0].principal_id
}
