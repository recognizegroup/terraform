output "group_names" {
    value = [
        for group in azurerm_api_management_group.management_group : group.name
    ]
}

output "group_user_ids" {
    value = [
        for group_user in azurerm_api_management_group_user.group_user : group_user.id
    ]
}