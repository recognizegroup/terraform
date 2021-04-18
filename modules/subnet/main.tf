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
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id
}
