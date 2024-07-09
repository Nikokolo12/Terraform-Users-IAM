output "user_arn" {
    value = { for user in aws_iam_user.users : user.name  => user.arn }
    description = "aws user's arn"
}

output "group_arn" {
    value = [ aws_iam_group.dev_group.arn, aws_iam_group.devops_group.arn ]
    description = "aws group's arn"
}