locals {
  global_vars      = read_terragrunt_config("global_vars.hcl")
  default_branch   = local.global_vars.inputs.default_branch

  oidc_repo_refs = [
    "heads/${local.default_branch}",
    "tags/*"
  ]
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
}
