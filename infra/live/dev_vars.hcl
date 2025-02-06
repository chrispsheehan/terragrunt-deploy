locals {
  global_vars    = read_terragrunt_config("global_vars.hcl")
  default_branch = local.global_vars.inputs.default_branch

  deploy_branches = [
    "feature/temp-debug-branch", # example additional branch to deploy from
    "cache-flow-improvements",
    local.default_branch
  ]
}

inputs = {
  deploy_branches = local.deploy_branches
}
