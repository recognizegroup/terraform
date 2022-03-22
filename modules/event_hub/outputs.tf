output "eventhub_name" {
  value = azurerm_eventhub.eventhub.name
}

output "namespace_name" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "consumer_group_name" {
  value = azurerm_eventhub_consumer_group.consumer.name
}
