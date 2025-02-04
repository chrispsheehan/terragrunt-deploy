locals {
  oidc_repo_refs = [
    "heads/main",
    "tags/*"
  ]

  resources = ["*"]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/aws/oidc"
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
  resources = local.resources
}