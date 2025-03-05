locals {
  repo_name = "${var.base_ecr_name}/${var.project_name}"
  ecr_pull_actions = [
    "ecr:BatchCheckLayerAvailability",
    "ecr:BatchGetImage",
    "ecr:GetDownloadUrlForLayer",
  ]
  allowed_account_principals = [
    for account_id in var.allowed_read_aws_account_ids : "arn:aws:iam::${account_id}:root"
  ]
}