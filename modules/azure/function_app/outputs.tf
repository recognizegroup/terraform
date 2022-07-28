output "name" {
  value = azurerm_function_app.function_app.name
}

output "principal_id" {
  value = azurerm_function_app.function_app.identity.0.principal_id
}

output "host_key_master" {
  value     = data.azurerm_function_app_host_keys.host_keys.default_function_key
  sensitive = true
}
