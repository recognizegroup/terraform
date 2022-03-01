output "container_registry_name" {
  value = var.create_container == 1 ? azurerm_container_registry.acr[0].name : null
}