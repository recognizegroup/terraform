terraform {
  required_version = ">= 0.12"

  required_providers {
    azurerm = ">=2.24.0"
  }

  backend "azurerm" {}
}
