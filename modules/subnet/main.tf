terraform {
  required_version = ">=0.13.4"

  required_providers {
    azurerm = ">=2.51.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_subnet" "subnet" {
  name                                           = var.subnet_name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.virtual_network_name
  address_prefixes                               = var.subnet_address_prefixes
  enforce_private_link_endpoint_network_policies = var.subnet_enforce_private_link_endpoint_network_policies
  service_endpoints                              = var.subnet_service_endpoints

  dynamic "delegation" {
    for_each = var.subnet_service_delegation == "" ? [] : [1]
    content {
      name = "delegation"
      service_delegation {
        name = var.subnet_service_delegation
      }
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  count          = var.route_table_id == "" ? 0 : 1
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id
}
