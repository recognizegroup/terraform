output "database_name" {
  value = azurerm_mssql_database.mssql_database.name
}

output "database_id" {
  value = azurerm_mssql_database.mssql_database.id
}

output "server_name" {
  value = azurerm_mssql_server.mssql_server.name
}

output "server_fqdn" {
  value = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "admin_username" {
  value = azurerm_mssql_server.mssql_server.administrator_login
}

output "admin_password" {
  value     = azurerm_mssql_server.mssql_server.administrator_login_password
  sensitive = true
}

output "principal_id" {
  value = azurerm_mssql_server.mssql_server.identity[0].principal_id
}
