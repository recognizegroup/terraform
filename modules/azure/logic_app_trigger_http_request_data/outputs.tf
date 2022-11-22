output "trigger_endpoint" {
  value = jsondecode(data.azapi_resource_action.logicapp_callbackurl.output).value
}

output "trigger_name" {
  value = var.trigger_name
}

output "trigger_signature" {
  value = element(split("&sig=", jsondecode(data.azapi_resource_action.logicapp_callbackurl.output).value), 1)
}
