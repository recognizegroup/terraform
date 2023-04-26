terraform {
  required_version = "~> 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }

  backend "azurerm" {}
}

provider "kubernetes" {
  config_path = var.config_path
}

resource "kubernetes_persistent_volume_claim_v1" "volume" {
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

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
