output "id" {
  value = azurerm_mysql_server.mysql_server.id
}

output "fqdn" {
  value = azurerm_mysql_server.mysql_server.fqdn
}

output "principal_id" {
  value = azurerm_mysql_server.mysql_server.identity[0].principal_id
}

output "database_name" {
  value = azurerm_mysql_database.mysql_database.name
}

output "mysql_admin_username" {
  value     = "${azurerm_mysql_server.mysql_server.administrator_login}@${var.mysql_server_name}"
  sensitive = true
}

output "mysql_admin_password" {
  value     = azurerm_mysql_server.mysql_server.administrator_login_password
  sensitive = true
}
