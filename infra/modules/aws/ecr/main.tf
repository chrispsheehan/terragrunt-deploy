resource "aws_ecr_repository" "this" {
  name = local.repo_name

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.allow_ecr_pull_policy.json
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.image_expiration_days > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_ecr_lifecycle_policy_document.this.json
}
