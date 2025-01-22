locals {
  aws_region     = get_env("AWS_REGION", "")
  aws_account_id = get_env("AWS_ACCOUNT_ID", "")
  git_repo       = get_env("GIT_REPO", "")

  aws_region_valid     = length(local.aws_region) > 0 ? true : error("AWS_REGION must be set as an environment variable.")
  aws_account_id_valid = length(local.aws_account_id) > 0 ? true : error("AWS_ACCOUNT_ID must be set as an environment variable.")
  git_repo_valid       = length(local.git_repo) > 0 ? true : error("GIT_REPO must be set as an environment variable.")

  terragrunt_dir    = get_terragrunt_dir()
  repo_ref          = replace(local.git_repo, "/", "-")
  path_parts        = split("/", local.terragrunt_dir)
  environment       = basename(dirname(local.terragrunt_dir))
  environment_index = index(local.path_parts, local.environment)
  module_path       = join("/", slice(local.path_parts, local.environment_index, length(local.path_parts)))

  state_bucket   = "${local.aws_account_id}-${local.aws_region}-${local.repo_ref}-tfstate"
  state_key      = "${local.module_path}/terraform.tfstate"
  dynamodb_table = "${local.repo_ref}-tf-lockid"
}

terraform {
  before_hook "print_locals" {
    commands = ["init", "plan", "apply"]
    execute = [
      "bash", "-c", "echo STATE:${local.state_bucket}/${local.state_key} TABLE:${local.dynamodb_table}"
    ]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.state_bucket
    key            = local.state_key
    region         = local.aws_region
    dynamodb_table = local.dynamodb_table
    encrypt        = true
  }
}

inputs = {
  aws_region   = local.aws_region
  project_name = local.repo_ref
  environment  = local.environment
  git_repo     = local.git_repo
}
