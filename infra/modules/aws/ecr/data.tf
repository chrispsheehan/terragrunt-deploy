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
    description = "Remove all but the latest ${var.min_image_count} images after ${var.max_day_count} days"

    selection {
      tag_status   = "any"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = var.max_day_count
    }

    action {
      type = "expire"
    }
  }

  rule {
    priority    = 2
    description = "Keep only the latest ${var.min_image_count} images"

    selection {
      tag_status   = "tagged"
      count_type   = "imageCountMoreThan"
      count_number = var.min_image_count
    }

    action {
      type = "expire"
    }
  }
}
