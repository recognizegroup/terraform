output "databricks_workspace_name" {
  value = azurerm_databricks_workspace.databricks.name
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.databricks.workspace_url
}
