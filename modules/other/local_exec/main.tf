terraform {
  required_version = "~> 1.3"

  backend "azurerm" {}
}

resource "null_resource" "local_execute_code" {
  provisioner "local-exec" {
    command     = var.command
    working_dir = var.working_dir
  }
  triggers = {
    always_run = timestamp()
  }
}

