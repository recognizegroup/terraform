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

<<<<<<< Updated upstream
resource "azurerm_public_ip" "public_ip"{
    name                = var.name
    resource_group_name = var.resource_group_name
    location            = var.location
    allocation_method   = var.sku == "Standard" ? "Static" : var.allocation_method
    sku                 = var.sku
    domain_name_label   = var.domain_name_label
}
=======
resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  domain_name_label   = var.domain_name_label
  sku                 = var.sku
}
>>>>>>> Stashed changes
