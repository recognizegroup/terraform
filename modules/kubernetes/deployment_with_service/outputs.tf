output "service_name" {
  value = kubernetes_deployment_v1.deployment.metadata.0.name
}

output "deployment_name" {
  value = kubernetes_deployment_v1.deployment.metadata.0.name
}

output "service_port" {
  value = kubernetes_service_v1.service.spec.0.ports.0.port
}
