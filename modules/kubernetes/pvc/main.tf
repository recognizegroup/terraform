terraform {
  required_version = "~> 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
  }

  backend "azurerm" {}
}

provider "kubernetes" {}

resource "kubernetes_persistent_volume_claim" "volume" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    access_modes = [var.access_mode]

    resources {
      requests = {
        storage = var.size
      }
    }

    storage_class_name = var.storage_class
  }
}
