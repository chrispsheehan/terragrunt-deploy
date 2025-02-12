locals {
  global_vars    = read_terragrunt_config("global_vars.hcl")
  default_branch = local.global_vars.inputs.default_branch

  temp_branch = get_env("TEMP_DEPLOY_BRANCH", "")

  deploy_branches = concat(
    ["feature/temp-debug-branch", local.default_branch],
    length(local.temp_branch) > 0 ? [local.temp_branch] : []
  )
}

inputs = {
  deploy_branches = local.deploy_branches
}
