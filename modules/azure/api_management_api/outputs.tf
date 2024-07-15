output "api_name" {
  value = azurerm_api_management_api.api.name
}

output "api_management_api_diagnostic" {
  value = (var.api_diagnostic_settings != null && var.api_management_logger_id != null) ? azurerm_api_management_api_diagnostic.api_diagnostic[0].id : null
}

output "application_id" {
  value = azuread_application.application.object_id
}

output "default_role" {
  value = azuread_application.application.app_role_ids["Default.Access"]
}

output "api_audiences" {
  value = azuread_application.application.identifier_uris
}

output "api_audience" {
  value = "api://${local.app_api_endpoint}"
}
