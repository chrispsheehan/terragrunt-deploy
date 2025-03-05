data "aws_iam_policy_document" "allow_ecr_pull_policy" {
  statement {
    sid     = "AllowCrossAccountPull"
    effect  = "Allow"
    actions = local.ecr_pull_actions
    principals {
      type        = "AWS"
      identifiers = local.allowed_account_principals
    }
  }
}

data "aws_ecr_lifecycle_policy_document" "this" {
  rule {
    priority    = 1
    description = "Remove images after ${var.image_expiration_days} days"

    selection {
      tag_status   = "any"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = var.image_expiration_days
    }

    action {
      type = "expire"
    }
  }
}
