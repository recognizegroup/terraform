terraform {
  required_version = "~> 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      // version to 3.87 due to bug in 3.88. If 3.89 is released, we can upgrade to that
      // bug in terraform https://github.com/hashicorp/terraform-provider-azurerm/issues/24560#issuecomment-1900197715
      version = ">= 3.48.0, < 3.88.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

locals {
}

resource "azurerm_api_management_certificate" "apim_certificate" {
  name                = var.name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name

  key_vault_secret_id = var.keyvault_certificate_id
  data                = var.certificate_location != null ? filebase64(var.certificate_location) : null
  password            = var.certificate_password

  lifecycle {
    precondition {
      condition     = (var.certificate_location != null && var.keyvault_certificate_id == null) || (var.certificate_location == null && var.keyvault_certificate_id != null)
      error_message = "Please, specify a Certificate KeyVault ID or Certificate file location"
    }
  }
}