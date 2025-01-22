locals {
  aws_region = get_env("AWS_REGION", "")
  repo_ref   = get_env("REPO_REF", "")
  module     = replace(basename(get_original_terragrunt_dir()), "_", "-")
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "${local.repo_ref}-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.repo_ref}-tf-lockid"
    encrypt        = true
  }
}

inputs = {
  aws_region = local.aws_region
  project_name = local.repo_ref
}
