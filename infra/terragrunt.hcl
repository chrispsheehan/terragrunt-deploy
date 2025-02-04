locals {
  aws_region     = get_env("AWS_REGION", "")
  aws_account_id = get_env("AWS_ACCOUNT_ID", "")
  git_repo       = get_env("GIT_REPO", "")
  git_token      = get_env("GITHUB_TOKEN", "")

  repo_ref         = replace(local.git_repo, "/", "-")
  deploy_role_name = "${local.repo_ref}-github-oidc-role"

  terragrunt_dir    = get_terragrunt_dir()
  path_parts        = split("/", local.terragrunt_dir)
  environment_index = index(local.path_parts, (basename(dirname(local.terragrunt_dir))))
  module_path       = join("/", slice(local.path_parts, local.environment_index, length(local.path_parts)))
  environment       = local.path_parts[length(local.path_parts) - 3]

  state_bucket     = "${local.aws_account_id}-${local.aws_region}-${local.repo_ref}-tfstate"
  state_key        = "${local.environment}/${local.module_path}/terraform.tfstate"
  state_lock_table = "${local.repo_ref}-tf-lockid"

  oidc_role_actions = [
    "s3:*"
  ]
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

inputs = {
  aws_region       = local.aws_region
  aws_account_id   = local.aws_account_id
  project_name     = local.repo_ref
  environment      = local.environment
  git_repo         = local.git_repo
  git_token        = local.git_token
  deploy_role_name = local.deploy_role_name

  state_bucket     = local.state_bucket
  state_lock_table = local.state_lock_table

  oidc_role_actions = local.oidc_role_actions
}
