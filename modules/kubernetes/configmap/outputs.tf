output "name" {
  value = kubernetes_config_map_v1.config.metadata.0.name
}
