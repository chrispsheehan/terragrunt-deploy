locals {
  default_branch = lookup(include.inputs, "default_branch", "main")
  oidc_repo_refs = [
    "heads/${local.default_branch}",
    "tags/*"
  ]
}

include {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../../modules/aws/oidc"
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
}