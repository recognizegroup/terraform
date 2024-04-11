output "operation_ids" {
  value = { for k, op in azurerm_api_management_api_operation.operation : k => op.id }
}