output "sql_database_name" {
  value = azurerm_sql_database.sql_database.name
}

output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}
