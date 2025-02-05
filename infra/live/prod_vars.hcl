locals {
  oidc_repo_refs = [
    "heads/main",
    "tags/*"
  ]
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
}
