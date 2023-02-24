locals {
  # Logging configuration
  log_analytics_retention_in_days = 30
  log_analytics_daily_quota_in_gb = 5

  # App Service configuration
  docker_image                    = "docker.io/swaggerapi/petstore"
  docker_image_tag                = "latest"
  service_plan_sku_name           = "P1v2"
  service_plan_enable_autoscaling = false
}
