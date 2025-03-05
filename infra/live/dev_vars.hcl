locals {
  global_vars    = read_terragrunt_config("global_vars.hcl")
  default_branch = local.global_vars.inputs.default_branch
  aws_account_id = get_aws_account_id()

  temp_branch = get_env("TEMP_DEPLOY_BRANCH", "")

  environment_branches = concat(
    ["feature/temp-debug-branch", local.default_branch],
    length(local.temp_branch) > 0 ? [local.temp_branch] : []
  )
  s3_expiration_days           = 1
  allowed_read_aws_account_ids = [local.aws_account_id]
}

inputs = {
  environment_branches         = local.environment_branches
  s3_expiration_days           = local.s3_expiration_days
  allowed_read_aws_account_ids = local.allowed_read_aws_account_ids
}
