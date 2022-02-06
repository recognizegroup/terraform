output "id" {
  value = azurerm_application_insights.application_insights.id
}

output "app_id" {
  value = azurerm_application_insights.application_insights.app_id
}

output "instrumentation_key" {
  value     = azurerm_application_insights.application_insights.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value     = azurerm_application_insights.application_insights.connection_string
  sensitive = true
}
