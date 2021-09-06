output "function_app_name" {
  value = azurerm_function_app.function_app.name
}

output "function_app_principal_id" {
  value = azurerm_function_app.function_app.identity.0.principal_id
}
