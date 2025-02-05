locals {
  oidc_repo_refs = [
    "heads/dev",
    "heads/github-actions-init"
  ]
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
}
