output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  value     = random_password.postgresql_admin.result
  sensitive = true
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.postgresql_database.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.postgresql_server.fqdn
}
