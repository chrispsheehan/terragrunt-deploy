locals {
  aws_account_id = get_env("AWS_ACCOUNT_ID", "")
  git_repo       = get_env("GIT_REPO", "")
  git_token      = get_env("GITHUB_TOKEN", "")

  path_parts  = split("/", get_terragrunt_dir())
  module      = local.path_parts[length(local.path_parts) - 1]
  provider    = local.path_parts[length(local.path_parts) - 2]
  environment = local.path_parts[length(local.path_parts) - 3]
  base_name   = local.path_parts[length(local.path_parts) - 4]

  global_vars_file   = "${dirname(find_in_parent_folders())}/${local.base_name}/terragrunt.tfvars.json"
  env_vars_file      = "${dirname(find_in_parent_folders())}/${local.base_name}/${local.environment}/terragrunt.tfvars.json"
  provider_vars_file = "${dirname(find_in_parent_folders())}/${local.base_name}/${local.environment}/${local.provider}/terragrunt.tfvars.json"
  global_vars        = jsondecode(file(local.global_vars_file))

  aws_region = lookup(local.global_vars, "aws_region", "eu-west-2")

  repo_ref         = replace(local.git_repo, "/", "-")
  deploy_role_name = "${local.repo_ref}-${local.environment}-github-oidc-role"
  state_bucket     = "${local.aws_account_id}-${local.aws_region}-${local.repo_ref}-tfstate"
  state_key        = "${local.environment}/${local.provider}/${local.module}/terraform.tfstate"
  state_lock_table = "${local.repo_ref}-tf-lockid"

  default_branch = "main"

  oidc_role_actions = ["s3:*"]
  oidc_resources    = ["*"]
}

terraform {
  before_hook "print_locals" {
    commands = ["init", "plan", "apply"]
    execute = [
      "bash", "-c", "echo STATE:${local.state_bucket}/${local.state_key} TABLE:${local.state_lock_table} ${local.provider_vars_file}"
    ]
  }

  extra_arguments "tfvars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = flatten([
      fileexists(local.global_vars_file) ? ["-var-file=${local.global_vars_file}"] : [],
      fileexists(local.env_vars_file) ? ["-var-file=${local.env_vars_file}"] : [],
      fileexists(local.provider_vars_file) ? ["-var-file=${local.provider_vars_file}"] : []
    ])
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

inputs = {
  aws_account_id   = local.aws_account_id
  project_name     = local.repo_ref
  environment      = local.environment
  git_repo         = local.git_repo
  git_token        = local.git_token
  deploy_role_name = local.deploy_role_name

  state_bucket     = local.state_bucket
  state_lock_table = local.state_lock_table

  default_branch = local.default_branch

  oidc_role_actions = local.oidc_role_actions
  oidc_resources    = local.oidc_resources
}
