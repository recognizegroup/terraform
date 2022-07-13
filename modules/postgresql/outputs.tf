output "username" {
  value = var.postgresql_username
}

output "password" {
  value     = random_password.postgresql_admin.result
  sensitive = true
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.postgresql_database.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.postgresql_server.fqdn
}
