output "id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "name" {
  value = azurerm_log_analytics_workspace.workspace.name
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.workspace_id
}

output "primary_key" {
  value     = azurerm_log_analytics_workspace.workspace.primary_shared_key
  sensitive = true
}

