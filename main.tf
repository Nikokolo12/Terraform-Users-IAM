provider "aws" {
    region = "us-east-2"
}

resource "aws_iam_user" "users" {
  for_each = toset(var.username)
  name = each.value
}

resource "aws_iam_group" "devops_group" {
  name = "devops_group"
}

resource "aws_iam_group" "dev_group" {
  name = "dev_group"
}

resource "aws_iam_user_group_membership" "devops_membership" {
  for_each = { for name in var.devops_users : name => name }
  user = aws_iam_user.users[each.key].name
  groups = [ aws_iam_group.devops_group.name ]
}

resource "aws_iam_user_group_membership" "dev_membership" {
  for_each = { for name in var.dev_users : name => name }
  user = aws_iam_user.users[each.key].name
  groups = [ aws_iam_group.dev_group.name ]
}

data "aws_iam_policy_document" "ec2_actions" {
  statement {
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
    ]

    resources = [
      "arn:aws:ec2:*:*:instance/*",
    ]
  }
}

resource "aws_iam_policy" "ec2_actions" {
  name = "ec2_actions"
  policy = data.aws_iam_policy_document.ec2_actions.json
} 

resource "aws_iam_group_policy_attachment" "dev_policy" {
  group = "dev_group"
  policy_arn = aws_iam_policy.ec2_actions.arn
}

resource "aws_iam_group_policy_attachment" "devops_policy" {
  group = "devops_group"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

