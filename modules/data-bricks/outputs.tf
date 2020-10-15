output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.databricks_workspace.name
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.databricks_workspace.workspace_url
}
