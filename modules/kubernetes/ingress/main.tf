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

resource "kubernetes_ingress_v1" "ingress" {
  count = var.enabled ? 1 : 0

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
          dynamic "path" {
            for_each = rule.value.paths

            content {
              backend {
                service {
                  name = path.value.service
                  port {
                    number = path.value.port
                  }
                }
              }

              path = path.value.path
            }
          }
        }
      }
    }

    tls {
      secret_name = "tls-secret-${var.name}"
      hosts       = flatten([for rule in var.rules : rule.host])
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}
