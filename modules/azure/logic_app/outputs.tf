output "principal_id" {
  value = var.use_managed_identity ? azurerm_logic_app_workflow.workflow.identity[0].principal_id : null
}

output "enpoint" {
  value = azurerm_logic_app_workflow.workflow.access_endpoint
}
output "id" {
  value = azurerm_logic_app_workflow.workflow.id
}
