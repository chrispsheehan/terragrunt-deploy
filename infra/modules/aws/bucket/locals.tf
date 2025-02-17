locals {
  read_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  write_actions = concat(local.read_actions, [
    "s3:PutObject"
  ])
  allowed_write_role_arns = concat(var.allowed_write_role_arns, [data.aws_iam_role.oidc_role.arn])
}
