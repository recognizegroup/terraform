output "name" {
  value = azurerm_api_management.api_management.name
}

output "id" {
  value = azurerm_api_management.api_management.id
}

output "principal_id" {
  value = azurerm_api_management.api_management.identity[0].principal_id
}

output "logger_id" {
  value = var.api_management_logger_settings != null ? azurerm_api_management_logger.apim_logger[0].id : null
}

output "developer_portal_url" {
  value = azurerm_api_management.api_management.developer_portal_url
}

output "public_ip_addresses" {
  value = azurerm_api_management.api_management.public_ip_addresses
}

output "app_registration_secret" {
  value     = azuread_application_password.password.value
  sensitive = true
}