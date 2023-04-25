terraform {
  required_version = "~> 1.3"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }

  backend "azurerm" {}
}

provider "kubernetes" {
  config_path = var.config_path
}

resource "kubernetes_secret_v1" "secret" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = var.data

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
