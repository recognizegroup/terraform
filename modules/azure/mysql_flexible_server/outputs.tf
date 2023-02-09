output "id" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.id
}

output "fqdn" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
}

output "database_name" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.name
}

output "mysql_admin_username" {
  value     = "${azurerm_mysql_flexible_server.mysql_flexible_server.administrator_login}@${var.mysql_server_name}"
  sensitive = true
}

output "mysql_admin_password" {
  value     = azurerm_mysql_flexible_server.mysql_flexible_server.administrator_password
  sensitive = true
}
