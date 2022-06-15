output "principal_id" {
  value = azurerm_logic_app_workflow.workflow.identity[0].principal_id
}
