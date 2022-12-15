output "name" {
  value = azurerm_linux_function_app.function_app.name
}

output "principal_id" {
  value = azurerm_linux_function_app.function_app.identity.0.principal_id
}

output "id" {
  value = azurerm_linux_function_app.function_app.id
}

output "aad_application_id" {
  value ="${var.managed_identity_provider.existing == null ? azuread_application.application[0].application_id : var.managed_identity_provider.existing.client_id}"
}