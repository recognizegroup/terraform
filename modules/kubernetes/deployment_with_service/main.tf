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
        "io.kompose.service" = var.name
      }
    }

    template {
      metadata {
        labels = {
          "io.kompose.service" = var.name
        }
      }

      spec {
        container {
          image             = var.docker_image
          image_pull_policy = var.image_pull_policy
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

          dynamic "env" {
            for_each = var.env

            content {
              name  = env.key
              value = env.value
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

              initial_delay_seconds = lookup(var.readiness_probe, "initial_delay_seconds", 10)
              period_seconds        = lookup(var.readiness_probe, "period_seconds", 5)
              failure_threshold     = lookup(var.readiness_probe, "failure_threshold", 50)
              timeout_seconds       = lookup(var.readiness_probe, "timeout_seconds", 5)
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

              initial_delay_seconds = lookup(var.liveness_probe, "initial_delay_seconds", 5)
              period_seconds        = lookup(var.liveness_probe, "period_seconds", 25)
              failure_threshold     = lookup(var.liveness_probe, "failure_threshold", 3)
              timeout_seconds       = lookup(var.liveness_probe, "timeout_seconds", 5)
            }
          }
        }

        dns_config {
          option {
            name = "single-request-reopen"
          }
        }

        dynamic "volume" {
          for_each = toset(var.volume_mounts[*].claim)

          content {
            name = volume.value

            persistent_volume_claim {
              claim_name = volume.value
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
      "io.kompose.service" = kubernetes_deployment_v1.deployment.metadata[0].name
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
  count = var.scaler.type == "http" ? 1 : 0

  manifest = {
    kind       = "HTTPScaledObject"
    apiVersion = "http.keda.sh/v1alpha1"

    metadata = {
      name      = var.name
      namespace = var.namespace
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

#
resource "kubernetes_service_v1" "http-scaler-service-proxy" {
  count = var.scaler.type == "http" ? 1 : 0

  metadata {
    name      = "${var.name}-keda-bridge"
    namespace = var.namespace
  }

  spec {
    external_name = "keda-add-ons-http-interceptor-proxy.keda.svc.cluster.local"
    port {
      port = 8080
    }

    type = "ExternalName"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "resource-scaler" {
  count = var.scaler.type == "resource" ? 1 : 0

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.name
    }

    min_replicas = var.scaler.replicas.min
    max_replicas = var.scaler.replicas.max

    metric {
      type = "Resource"

      resource {
        name = "memory"

        target {
          type                = "Utilization"
          average_utilization = lookup(var.scaler.metrics, "memory", 80)
        }
      }
    }

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = lookup(var.scaler.metrics, "cpu", 70)
        }
      }
    }
  }
}
