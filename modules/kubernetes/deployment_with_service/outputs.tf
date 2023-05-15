output "deployment_name" {
  value = kubernetes_deployment_v1.deployment.metadata.0.name
}

output "service_port" {
  value = var.scaler.type == "http" ? kubernetes_service_v1.http-scaler-service-proxy.0.spec.0.port.0.port : kubernetes_service_v1.service.spec.0.port.0.port
}

output "service_name" {
  value = var.scaler.type == "http" ? kubernetes_service_v1.http-scaler-service-proxy.0.metadata.0.name : kubernetes_service_v1.service.metadata.0.name
}
