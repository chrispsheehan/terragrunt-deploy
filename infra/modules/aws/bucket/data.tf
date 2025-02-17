data "aws_iam_role" "oidc_role" {
  name = var.deploy_role_name
}

data "aws_iam_policy_document" "allow_bucket_roles" {
  dynamic "statement" {
    for_each = var.allowed_read_aws_account_ids
    content {
      sid     = "AllowGetAndListFromAccount_${statement.value}"
      effect  = "Allow"
      actions = local.read_actions
      resources = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*"
      ]

      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${statement.value}:root"]
      }
    }
  }

  statement {
    effect = "Allow"
    sid    = "AllowGetListAndPutFromDefinedIamRoles"

    actions = local.write_actions

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = local.allowed_write_role_arns
    }
  }
}
