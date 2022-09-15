output "id" {
  value = azurerm_synapse_workspace.workspace.id
}

output "sql_admin_username" {
  value = var.sql_admin_login
}

output "sql_admin_password" {
  value     = random_password.sql_admin_password.result
  sensitive = true
}

output "primary_access_key" {
  value     = azurerm_storage_account.storage_account.primary_access_key
  sensitive = true
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id
}

output "principal_id" {
  value = azurerm_synapse_workspace.workspace.identity.0.principal_id
}
