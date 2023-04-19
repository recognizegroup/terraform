output "name" {
  value = kubernetes_secret_v1.secret.metadata.0.name
}
