output "connection_id" {
  value = local.v1 ? azurerm_api_connection.connection_v1[0].id : jsondecode(azurerm_resource_group_template_deployment.connection_v2[0].output_content)["connection_id"]["value"]
}

output "connection_name" {
  value = var.connection_name
}

output "api_id" {
  value = var.managed_api_id
}

output "connection_runtime_url" {
  value = local.v1 ? null : jsondecode(azurerm_resource_group_template_deployment.connection_v2[0].output_content)["connection_runtime_url"]["value"]
}
