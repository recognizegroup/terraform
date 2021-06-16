output "mysql_database_id" {
  value = azurerm_mysql_server.mysql_server.id
}

output "mysql_database_fqdn" {
  value = azurerm_mysql_server.mysql_server.fqdn
}
