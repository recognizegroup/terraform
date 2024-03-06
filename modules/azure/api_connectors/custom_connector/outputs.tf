output "name" {
  value = var.connection_name
}

output "connector_id"{
  value = "${data.azurerm_subscription.current.id}/resourceGroups/${var.connector_resource_group_name}/providers/Microsoft.Web/customApis/${var.connector_name}"
}