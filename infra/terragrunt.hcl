locals {
  aws_region     = get_env("AWS_REGION", "")
  aws_account_id = get_env("AWS_ACCOUNT_ID", "")
  repo_ref       = get_env("REPO_REF", "")
  module         = replace(basename(get_original_terragrunt_dir()), "_", "-")
  environment    = basename(dirname(get_terragrunt_dir()))
}

terraform {
  before_hook "print_locals" {
    commands = ["init", "plan", "apply"]
    execute  = ["bash", "-c", "echo AWS_REGION:${local.aws_region} REPO_REF:${local.repo_ref} ENVIRONMENT:${local.environment} MODULE:${local.module}"]
  }
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "${local.aws_account_id}-${local.aws_region}-${local.repo_ref}-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.repo_ref}-tf-lockid"
    encrypt        = true
  }
}

inputs = {
  aws_region   = local.aws_region
  project_name = local.repo_ref
  environment  = local.environment
}
