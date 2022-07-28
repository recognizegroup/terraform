terraform {
  required_version = ">=1.1.2"

  backend "azurerm" {}
}

resource "random_password" "password" {
  length           = var.password_lenght
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
}