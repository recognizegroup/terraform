output "sql_database_name" {
  value = azurerm_mssql_database.sql_database.name
}

output "sql_database_id" {
  value = azurerm_mssql_database.sql_database.id
}

output "sql_database_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.sql_server.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.sql_database.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sql_server.administrator_login};Password=${azurerm_mssql_server.sql_server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  sensitive = true
}

output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
