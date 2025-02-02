locals {
  parent_locals = read_terragrunt_config(find_in_parent_folders()).locals

  variables = {
    AWS_OIDC_ROLE_ARN = "arn:aws:iam::${local.parent_locals.aws_account_id}:role/${local.parent_locals.deploy_role_name}",
    AWS_REGION        = local.parent_locals.aws_region
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/github/environment"
}

inputs = {
  variables = local.variables
}
