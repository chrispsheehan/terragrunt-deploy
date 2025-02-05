locals {
  global_vars    = read_terragrunt_config("global_vars.hcl")
  default_branch = local.global_vars.inputs.default_branch

  deploy_branches = [local.default_branch]
  deploy_tags     = ["*"]
}

inputs = {
  deploy_branches = local.deploy_branches
  deploy_tags     = local.deploy_tags
}
