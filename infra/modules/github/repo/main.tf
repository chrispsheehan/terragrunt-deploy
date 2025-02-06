resource "github_branch_protection" "main" {
  repository_id       = data.github_repository.this.node_id
  pattern             = var.default_branch
  allows_force_pushes = false

  required_pull_request_reviews {
    dismiss_stale_reviews = true
  }
}

resource "github_actions_repository_permissions" "this" {
  repository = data.github_repository.this.name

  allowed_actions = "selected"
  allowed_actions_config {
    github_owned_allowed = true
    patterns_allowed     = local.allowed_actions
    verified_allowed     = true
  }
}
