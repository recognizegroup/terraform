terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.48"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group_template_deployment" "sftp_ssh" {
  name                = "${var.connection_name}_deployment"
  resource_group_name = var.resource_group_name

  template_content = file("./connection.json")
  parameters_content = jsonencode({
    "connection_name" = {
      value = var.connection_name
    }
    "password" = {
      value = var.sftp_password
    }
    "username" = {
      value = var.sftp_username
    }
    "hostname" = {
      value = var.sftp_hostname
    }
  })
  deployment_mode = "Incremental"
}
