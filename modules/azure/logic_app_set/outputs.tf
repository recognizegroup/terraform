output "principal_id" {
  value = {
    for key, workflow_instance in azurerm_logic_app_workflow.workflow :
    key => var.use_managed_identity ? workflow_instance.identity[0].principal_id : null
  }
}
