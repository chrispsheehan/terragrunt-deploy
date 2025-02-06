locals {
  git_token      = get_env("GITHUB_TOKEN", "")
  git_remote     = run_cmd("--terragrunt-quiet", "git", "remote", "get-url", "origin")
  git_repo       = regex("[/:]([-0-9_A-Za-z]*/[-0-9_A-Za-z]*)[^/]*$", local.git_remote)[0]
  aws_account_id = get_aws_account_id()

  path_parts  = split("/", get_terragrunt_dir())
  module      = local.path_parts[length(local.path_parts) - 1]
  provider    = local.path_parts[length(local.path_parts) - 2]
  environment = local.path_parts[length(local.path_parts) - 3]

  global_vars      = read_terragrunt_config(find_in_parent_folders("global_vars.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("${local.environment}_vars.hcl"))

  aws_region       = local.global_vars.inputs.aws_region
  project_name     = replace(local.git_repo, "/", "-")
  deploy_role_name = "${local.project_name}-${local.environment}-github-oidc-role"
  state_bucket     = "${local.aws_account_id}-${local.aws_region}-${local.project_name}-tfstate"
  state_key        = "${local.environment}/${local.provider}/${local.module}/terraform.tfstate"
  state_lock_table = "${local.project_name}-tf-lockid"
}

terraform {
  before_hook "print_locals" {
    commands = ["init", "plan", "apply"]
    execute = [
      "bash", "-c", "echo STATE:${local.state_bucket}/${local.state_key} TABLE:${local.state_lock_table}"
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.state_bucket
    key            = local.state_key
    region         = local.aws_region
    dynamodb_table = local.state_lock_table
    encrypt        = true
  }
}

inputs = merge(
  local.global_vars.inputs,
  local.environment_vars.inputs,
  {
    aws_account_id   = local.aws_account_id
    project_name     = local.project_name
    environment      = local.environment
    git_repo         = local.git_repo
    git_token        = local.git_token
    deploy_role_name = local.deploy_role_name
    state_bucket     = local.state_bucket
    state_lock_table = local.state_lock_table
  }
)
