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

resource "kubernetes_cron_job_v1" "cron_job" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    concurrency_policy        = "Forbid"
    schedule                  = var.schedule
    timezone                  = var.timezone
    starting_deadline_seconds = var.starting_deadline_seconds

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

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

              dynamic "env_from" {
                for_each = var.env_configmap_refs

                content {
                  config_map_ref {
                    name = env_from.value
                  }
                }
              }

              command = var.command
              args    = var.args
            }

            restart_policy = var.restart_policy
          }
        }
      }
    }
  }
}
