output "name" {
  value = azurerm_linux_web_app.web_app.name
}

output "default_hostname" {
  value = azurerm_linux_web_app.web_app.default_hostname
}

output "username" {
  value     = azurerm_linux_web_app.web_app.site_credential[0].name
  sensitive = true
}

output "password" {
  value     = azurerm_linux_web_app.web_app.site_credential[0].password
  sensitive = true
}

output "principal_id" {
  value = azurerm_linux_web_app.web_app.identity[0].principal_id
}
