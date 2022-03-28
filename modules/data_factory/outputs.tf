output "name" {
  value = azurerm_data_factory.data_factory.name
}

output "id" {
  value = azurerm_data_factory.data_factory.id
}

output "principal_id" {
  value = azurerm_data_factory.data_factory.identity[0].principal_id
}
