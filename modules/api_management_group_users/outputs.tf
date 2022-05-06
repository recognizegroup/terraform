output "group_names" {
    value = [
        for group in azurerm_api_management_group.group : group.name
    ]
}

output "user_ids" {
    value = [
        for user in azurerm_api_management_user.user : user.id
    ]
}

output "group_user_ids" {
    value = [
        for group_user in azurerm_api_management_group_user.group_user : group_user.id
    ]
}