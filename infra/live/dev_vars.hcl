locals {
  global_vars    = read_terragrunt_config("global_vars.hcl")
  default_branch = local.global_vars.inputs.default_branch

  temp_branch = get_env("TEMP_DEPLOY_BRANCH", "")

  environment_branches = concat(
    ["feature/temp-debug-branch", local.default_branch],
    length(local.temp_branch) > 0 ? [local.temp_branch] : []
  )

  s3_expiration_days = 3
}

inputs = {
  environment_branches = local.environment_branches
  s3_expiration_days   = local.s3_expiration_days
}
