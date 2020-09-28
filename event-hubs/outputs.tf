output "eventhub_name" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "eventhub_namespace_name" {
  value = azurerm_eventhub.eventhub.name
}

output "eventhub_consumer_group_name" {
  value = azurerm_eventhub_consumer_group.consumer.name
}
