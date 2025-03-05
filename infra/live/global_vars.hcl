locals {
  aws_region     = "eu-west-2"
  default_branch = "main"
  allowed_role_actions = [
    "s3:*",
    "iam:*",
    "lambda:*",
    "sqs:*",
    "logs:*",
    "ecr:*"
  ]
  allowed_role_resources = ["*"]
}

inputs = {
  aws_region             = local.aws_region
  default_branch         = local.default_branch
  allowed_role_actions   = local.allowed_role_actions
  allowed_role_resources = local.allowed_role_resources
}
