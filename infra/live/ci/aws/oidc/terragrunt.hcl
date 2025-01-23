locals {
  repo_refs = [
    "heads/main",
    "tags/*"
  ]

  actions = [
    "s3:*"
  ]

  resources = ["*"]

  role_name = "github-oidc-deploy-role"

  parent_locals    = read_terragrunt_config(find_in_parent_folders()).locals
  state_bucket     = local.parent_locals.state_bucket
  state_lock_table = local.parent_locals.state_lock_table
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/aws/oidc"
}

inputs = {
  repo_refs        = local.repo_refs
  actions          = local.actions
  resources        = local.resources
  role_name        = local.role_name
  state_bucket     = local.state_bucket
  state_lock_table = local.state_lock_table
}