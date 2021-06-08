terraform {
  required_version = ">=0.13.5"

  required_providers {
    azurerm = "=2.41.0"
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "null_resource" "local_execute_code" {
  provisioner "local-exec" {
    command = var.command
    working_dir = var.working_dir
    interpreter = var.interpreter
  }
  triggers = {
    always_run = timestamp()
  }
}

