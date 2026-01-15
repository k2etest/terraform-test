locals {
    user_data = jsondecode(file("${path.module}/users.json"))
}

resource "github_membership" "org_members" {
    for_each = local .user_data.users

    username = each.key

    role = lower(each.value.role)
}

output "user_real_name_map" {
    description = "A mapping of Github usernames to their real names"
    value = {
        for username, details in local.user_data.users: username => details.real_name
    }
}