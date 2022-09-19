terraform {
  required_version = ">=1.0.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.6.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.22.0"
    }
  }

  backend "azurerm" {}

  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
}


resource "azurerm_template_deployment" "example" {
  name                = "acctesttemplate-01"
  resource_group_name = var.resource_group_name

  template_body =  file("./connection.json")
  parameters = {
     service_bus_namespace       = var.service_bus_namespace
     service_bus_connection_name = var.connection_name
  }
  deployment_mode = "Incremental"
}


# data "azurerm_managed_api" "example" {
#   name     = "servicebus"
#   location = "West Europe"
# }

# resource "azurerm_api_connection" "example" {
#   name                = "con-terraform-test"
#   resource_group_name = var.resource_group_name
#   managed_api_id      = data.azurerm_managed_api.example.id
#   display_name        = "TerraformServiceBusConnection"

#   parameter_value_set = {}

#   parameter_values = {
#     connectionString = "Endpoint=sb://sb-vwt-int-platform-dev.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=eTES68E6AJCGPkBuISHPxbhwXhOOLVXObP0KZKhE8t8="
#     # managedIdentityAuth = {
#     #   namespaceEndpoint = "sb://sb-vwt-int-platform-dev.servicebus.windows.net"
#     # }
#     # name = "managedIdentityAuth"
#     # values = {
#     #   namespaceEndpoint = "sb://sb-vwt-int-platform-dev.servicebus.windows.net"
#     # }
#   }

#   lifecycle {
#     # NOTE: since the connectionString is a secure value it's not returned from the API
#     ignore_changes = ["parameter_values"]
#   }
# }