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

resource "kubernetes_secret_v1" "secret" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = var.data
}
