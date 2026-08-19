output "id" {
  value = azurerm_monitor_data_collection_endpoint.data_collection_endpoint.id
}

output "name" {
  value = azurerm_monitor_data_collection_endpoint.data_collection_endpoint.name
}

output "logs_ingestion_endpoint" {
  value = azurerm_monitor_data_collection_endpoint.data_collection_endpoint.logs_ingestion_endpoint
}

output "configuration_access_endpoint" {
  value = azurerm_monitor_data_collection_endpoint.data_collection_endpoint.configuration_access_endpoint
}
