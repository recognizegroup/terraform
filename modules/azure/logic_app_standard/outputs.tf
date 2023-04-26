output "principal_id" {
  value = length(azurerm_logic_app_standard.app.identity) > 0 ? azurerm_logic_app_standard.app.identity[0].principal_id : null
}

output "name" {
  value = azurerm_logic_app_standard.app.name
}

output "default_hostname" {
  value = azurerm_logic_app_standard.app.default_hostname
}