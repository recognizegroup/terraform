output "app_service_name" {
  value = azurerm_app_service.app_service.name
}

output "app_service_username" {
  value = azurerm_app_service.app_service.site_credential[0].username
}

output "app_service_password" {
  value = azurerm_app_service.app_service.site_credential[0].password
}
