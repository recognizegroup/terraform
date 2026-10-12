output "ids" {
  value = { for name, rule in azurerm_monitor_scheduled_query_rules_alert_v2.log_search_alert : name => rule.id }
}

output "principal_ids" {
  value = { for name, rule in azurerm_monitor_scheduled_query_rules_alert_v2.log_search_alert : name => rule.identity[0].principal_id }
}
