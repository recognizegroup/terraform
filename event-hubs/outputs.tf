output "eventhub" {
  value = azurerm_eventhub_namespace.namespace.name
}

output "eventhub_namespace" {
  value = azurerm_eventhub.eventhub.name
}

output "eventhub_authorization_rule" {
  value = azurerm_eventhub_authorization_rule.rule.name
}
