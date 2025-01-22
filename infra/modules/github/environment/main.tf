resource "github_repository_environment" "this" {
  environment         = var.environment
  repository          = data.github_repository.this.full_name
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}
