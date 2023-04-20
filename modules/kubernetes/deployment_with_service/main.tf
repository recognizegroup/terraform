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

resource "kubernetes_deployment_v1" "deployment" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          "io.kompose.service" = var.name
          app                  = var.name
        }
      }

      spec {
        container {
          image             = var.docker_image
          image_pull_policy = "Always"
          name              = var.name

          resources {
            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
          }

          dynamic "env_from" {
            for_each = var.env_secret_refs

            content {
              secret_ref {
                name = env_from.value
              }
            }
          }

          dynamic "env_from" {
            for_each = var.env_configmap_refs

            content {
              config_map_ref {
                name = env_from.value
              }
            }
          }

          port {
            container_port = var.container_port
          }

          dynamic "volume_mount" {
            for_each = var.volume_mounts

            content {
              mount_path = volume_mount.value.mount_path
              name       = volume_mount.value.claim
              sub_path   = volume_mount.value.sub_path
            }
          }

          dynamic "readiness_probe" {
            for_each = var.readiness_probe != null ? [1] : []

            content {
              http_get {
                path   = var.readiness_probe.path
                port   = var.readiness_probe.port
                scheme = "HTTP"
              }

              initial_delay_seconds = 5
              period_seconds        = 25
              failure_threshold     = 3
              timeout_seconds       = 5
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe != null ? [1] : []

            content {
              http_get {
                path   = var.liveness_probe.path
                port   = var.liveness_probe.port
                scheme = "HTTP"
              }

              initial_delay_seconds = 5
              period_seconds        = 25
              failure_threshold     = 3
              timeout_seconds       = 5
            }
          }
        }

        dns_config {
          option {
            name = "single-request-reopen"
          }
        }

        dynamic "volume" {
          for_each = var.volume_mounts

          content {
            name = volume.value.claim

            persistent_volume_claim {
              claim_name = volume.value.claim
            }
          }
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.deployment.metadata[0].name
    }

    port {
      port        = var.target_port
      target_port = var.container_port
    }

    type = "ClusterIP"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_manifest" "http-scaler" {
  count = var.scaler != null && var.scaler.type == "http" ? 1 : 0

  manifest = {
    kind       = "HTTPScaledObject"
    apiVersion = "http.keda.sh/v1alpha1"
    metadata = {
      name = var.name
      namespace=  var.namespace
    }
    spec = {
      host = var.scaler.host
      scaleTargetRef = {
        deployment = var.name
        service    = var.name
        port       = var.container_port
      }
      replicas = {
        min = var.scaler.replicas.min
        max = var.scaler.replicas.max
      }
    }
  }
}
