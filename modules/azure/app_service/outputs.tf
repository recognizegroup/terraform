output "name" {
  value = azurerm_app_service.app_service.name
}

output "default_site_hostname" {
  value = azurerm_app_service.app_service.default_site_hostname
}

output "username" {
  value     = azurerm_app_service.app_service.site_credential[0].username
  sensitive = true
}

output "password" {
  value     = azurerm_app_service.app_service.site_credential[0].password
  sensitive = true
}

output "principal_id" {
  value = azurerm_app_service.app_service.identity[0].principal_id
}
