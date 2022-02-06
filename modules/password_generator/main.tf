terraform {
  required_version = ">=1.1.2"

  required_providers {
    azurerm = "=2.94.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "random_password" "password" {
  length           = var.password_lenght
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
}
