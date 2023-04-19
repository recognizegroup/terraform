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

provider "kubernetes" {
  config_path = var.config_path
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
  }

  spec {
    dynamic "rule" {
      for_each = var.rules

      content {
        host = rule.value.host
        http {
          path {
            backend {
              service {
                name = rule.value.service
                port {
                  number = rule.value.port
                }
              }
            }

            path = rule.value.path
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret-${var.name}"
      hosts       = flatten([for rule in var.rules : rule.host])
    }
  }
}
