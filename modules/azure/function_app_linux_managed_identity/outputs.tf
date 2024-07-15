output "name" {
  value = azurerm_linux_function_app.function_app.name
}

output "principal_id" {
  value = azurerm_linux_function_app.function_app.identity.0.principal_id
}

output "id" {
  value = azurerm_linux_function_app.function_app.id
}

output "aad_application_name" {
  value = var.managed_identity_provider.existing == null ? "api://${var.managed_identity_provider.create.application_name}" : null
}

output "api_audiences" {
  value = local.allowed_audiences
}
