terraform {
  required_version = "~> 1.3"

  backend "azurerm" {}
}

resource "random_password" "password" {
  length           = var.password_length
  special          = true
  override_special = "_%@"
  keepers          = var.password_keeper
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}
