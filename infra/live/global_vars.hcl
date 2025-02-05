locals {
  aws_region        = "eu-west-2"
  default_branch    = "main"
  oidc_role_actions = ["s3:*"]
  oidc_resources    = ["*"]
}

inputs = {
  aws_region        = local.aws_region
  default_branch    = local.default_branch
  oidc_role_actions = local.oidc_role_actions
  oidc_resources    = local.oidc_resources
}
