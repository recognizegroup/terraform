output "azure_sql_server_name" {
  value = azurerm_sql_server.sql_server.name
}

output "azure_sql_server_fqdn" {
  value = azurerm_sql_server.sql_server.fully_qualified_domain_name
}
