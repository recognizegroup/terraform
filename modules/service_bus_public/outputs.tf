output "name" {
  value = azurerm_servicebus_namespace.service_bus.name
}

output "namespace_id" {
  value = azurerm_servicebus_namespace.service_bus.id
}

output "primary_access_key" {
  value     = azurerm_servicebus_namespace.service_bus.default_primary_key
  sensitive = true
}

output "primary_access_connection_string" {
  value     = azurerm_servicebus_namespace.service_bus.default_primary_connection_string
  sensitive = true
}