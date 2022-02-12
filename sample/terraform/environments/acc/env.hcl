locals {
  # Logging configuration
  log_analytics_retention_in_days = 30
  log_analytics_daily_quota_in_gb = 5

  # App Service configuration
  app_service_docker_container        = "docker.io/swaggerapi/petstore"
  app_service_plan_tier               = "PremiumV2"
  app_service_plan_size               = "P1v2"
  app_service_plan_enable_autoscaling = false
}
