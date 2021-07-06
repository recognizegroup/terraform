output "elastic_cloud_endpoint" {
  value = ec_deployment.ec_cluster.elasticsearch[0].https_endpoint
}

output "elastic_cloud_username" {
  value     = ec_deployment.ec_cluster.elasticsearch_username
  sensitive = true
}

output "elastic_cloud_password" {
  value     = ec_deployment.ec_cluster.elasticsearch_password
  sensitive = true
}
