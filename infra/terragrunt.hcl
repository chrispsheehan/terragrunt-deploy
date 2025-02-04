locals {
  terragrunt_dir    = get_terragrunt_dir()
  path_parts        = split("/", local.terragrunt_dir)
  environment_index = index(local.path_parts, (basename(dirname(local.terragrunt_dir))))
  module_path       = join("/", slice(local.path_parts, local.environment_index, length(local.path_parts)))
  environment       = local.path_parts[length(local.path_parts) - 3]
  base_name         = local.path_parts[length(local.path_parts) - 4]

  global_vars_file = "${dirname(find_in_parent_folders())}/${local.base_name}/terragrunt.tfvars.json"
  env_vars_file    = "${dirname(find_in_parent_folders())}/${local.base_name}/${local.environment}/terragrunt.tfvars.json"
  env_vars_global  = jsondecode(file(local.global_vars_file))

  aws_region     = lookup(local.env_vars_global, "aws_region", "eu-west-2")
  aws_account_id = get_env("AWS_ACCOUNT_ID", "")
  git_repo       = get_env("GIT_REPO", "")
  git_token      = get_env("GITHUB_TOKEN", "")

  repo_ref         = replace(local.git_repo, "/", "-")
  deploy_role_name = "${local.repo_ref}-github-oidc-role"



  state_bucket     = "${local.aws_account_id}-${local.aws_region}-${local.repo_ref}-tfstate"
  state_key        = "${local.environment}/${local.module_path}/terraform.tfstate"
  state_lock_table = "${local.repo_ref}-tf-lockid"


}

terraform {
  before_hook "print_locals" {
    commands = ["init", "plan", "apply"]
    execute = [
      "bash", "-c", "echo STATE:${local.state_bucket}/${local.state_key} TABLE:${local.state_lock_table} GLOBAL_VARS:${local.global_vars_file} ENV_VARS:${local.env_vars_file}"
    ]
  }

  extra_arguments "tfvars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = flatten([
      fileexists(local.global_vars_file) ? ["-var-file=${local.global_vars_file}"] : [],
      fileexists(local.env_vars_file) ? ["-var-file=${local.env_vars_file}"] : []
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
}
