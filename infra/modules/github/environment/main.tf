resource "github_repository_environment" "this" {
  environment         = var.environment
  repository          = data.github_repository.this.full_name
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_actions_environment_variable" "this" {
  for_each = var.variables

  repository    = data.github_repository.this.full_name
  environment   = github_repository_environment.this.environment
  variable_name = each.key
  value         = each.value
}
