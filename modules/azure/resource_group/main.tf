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

resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

resource "azurerm_management_lock" "resource-group-readonly" {
  count = var.readonly == false ? 0 : 1

  name       = "resource-group-readonly"
  scope      = azurerm_resource_group.resource_group.id
  lock_level = "ReadOnly"
  notes      = "The Resource Group and it's elements are read-only."
}

resource "azurerm_management_lock" "resource-group-cannotdelete" {
  count = var.cannotdelete == false ? 0 : 1

  name       = "resource-group-cannotdelete"
  scope      = azurerm_resource_group.resource_group.id
  lock_level = "CanNotDelete"
  notes      = "The Resource Group and it's elements cannot be deleted."
}
