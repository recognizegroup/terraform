output "service_name" {
  value = kubernetes_deployment_v1.deployment.metadata.0.name
}

output "deployment_name" {
  value = kubernetes_deployment_v1.deployment.metadata.0.name
}
