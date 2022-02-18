output "name" {
  value = azurerm_function_app.function_app.name
}

output "principal_id" {
  value = azurerm_function_app.function_app.identity.0.principal_id
}
