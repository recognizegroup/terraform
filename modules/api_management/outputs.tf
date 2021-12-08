output "api_management_name" {
  value = azurerm_api_management.api_management.name
}

output "api_management_principal_id" {
  value = azurerm_api_management.api_management.identity[0].principal_id
}

output "api_management_groups" {
  value = [for group in azurerm_api_management_group.group : group.name]
}
