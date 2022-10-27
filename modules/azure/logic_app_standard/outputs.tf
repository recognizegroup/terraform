output "principal_id" {
  value = var.use_managed_identity ? azurerm_logic_app_standard.app.identity[0].principal_id : null
}

output "name" {
  value = azurerm_logic_app_standard.app.name
}