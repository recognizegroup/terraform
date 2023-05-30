output "name" {
  value = kubernetes_persistent_volume_claim_v1.volume.metadata.0.name
}
