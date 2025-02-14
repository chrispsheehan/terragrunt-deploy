data "aws_iam_policy_document" "allow_bucket_roles" {
  statement {
    effect = "Allow"
    sid     = "AllowGetAndListFromDefinedIamRoles"

    actions = local.read_actions

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.allowed_read_role_arns
    }
  }

  statement {
    effect = "Allow"
    sid     = "AllowGetListAndPutFromDefinedIamRoles"

    actions = local.read_actions

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.allowed_write_role_arns
    }
  }
}
