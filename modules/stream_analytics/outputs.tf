output "stream_analytics_job_name" {
  value = azurerm_stream_analytics_job.job.name
}

output "stream_input_name" {
  value = azurerm_stream_analytics_stream_input_eventhub.stream_input.name
}

output "stream_output_name" {
  value = azurerm_stream_analytics_output_blob.stream_output.name
}

output "stream_job_id" {
  value = azurerm_stream_analytics_job.job.id
}
