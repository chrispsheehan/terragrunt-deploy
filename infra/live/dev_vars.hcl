locals {
  oidc_repo_refs = [
    "heads/dev",
    "heads/github-actions-init"
  ]
  # aws_account_id = 700011111111 could set a different account id here
}

inputs = {
  oidc_repo_refs = local.oidc_repo_refs
  # aws_account_id = local.aws_account_id
}
