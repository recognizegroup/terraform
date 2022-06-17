output "primary_key" {
  value     = data.azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
  sensitive = true
}

output "workspace_id" {
  value = data.azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
}

output "id" {
  value = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
}
