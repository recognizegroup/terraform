output "created_on" {
  value = { for k, v in data.cloudflare_record.record : k => v.created_on }
}

output "modified_on" {
  value = { for k, v in data.cloudflare_record.record : k => v.modified_on }
}
