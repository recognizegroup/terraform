terraform {
  required_version = ">=0.13.3"

  required_providers {
    azurerm = "=2.24.0"
  }

  backend "azurerm" {}
}
