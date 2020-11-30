terraform {
  required_version = ">=0.13.4"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  address_space       = var.virtual_network_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "subnet" {
    for_each = [for s in var.virtual_network_subnets : {
      name   = s.name
      prefix = s.address_prefix
    }]

    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
    }
  }
}
