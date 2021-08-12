output "logic_app_id" {
  value = azurerm_logic_app_workflow.logic_app.id
}

output "app_id" {
  value = jsondecode(azurerm_resource_group_template_deployment.logic_app_workflow_deployment.output_content).app_id.value
}
