locals {
  repo_refs = [
    "heads/dev"
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
  repo_refs        = local.repo_refs
  resources        = local.resources
}