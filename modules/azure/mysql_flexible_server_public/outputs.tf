output "id" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.id
}

output "fqdn" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.fqdn
}

output "database_name" {
  value = azurerm_mysql_flexible_database.mysql_flexible_database.name
}

output "admin_username" {
  value     = "${azurerm_mysql_flexible_server.mysql_flexible_server.administrator_login}@${var.server_name}"
  sensitive = true
}

output "admin_password" {
  value     = azurerm_mysql_flexible_server.mysql_flexible_server.administrator_password
  sensitive = true
}
