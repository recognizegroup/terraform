output "api_name" {
  value = azurerm_api_management_api.api.name
}

output "api_management_api_diagnostic"{
  value = azurerm_api_management_api_diagnostic.api_diagnostic[0].id
}
