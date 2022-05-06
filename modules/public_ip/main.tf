terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=3.4.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "public_ip"{
    name                = var.name
    resource_group_name = var.resource_group_name
    location            = var.location
    allocation_method   = var.allocation_method
    domain_name_label   = var.domain_name_label != "" ? var.domain_name_label : null
}