terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_subnet" "subnet" {
  name                                      = var.name
  resource_group_name                       = var.resource_group_name
  virtual_network_name                      = var.virtual_network_name
  address_prefixes                          = var.address_prefixes
  private_endpoint_network_policies_enabled = var.private_endpoint_network_policies_enabled
  service_endpoints                         = var.service_endpoints

  dynamic "delegation" {
    for_each = var.service_delegation == null ? [] : [1]
    content {
      name = "delegation"
      service_delegation {
        name = var.service_delegation
      }
    }
  }
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  count          = var.route_table_id == null ? 0 : 1
  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.route_table_id
}
