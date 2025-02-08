data "aws_iam_openid_connect_provider" "this" {
  arn = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_domain}"
}

data "aws_iam_policy_document" "terraform_defined_actions" {

  statement {
    sid       = "AllowOIDCRoleAssumeIdentity"
    actions   = local.oidc_assume_actions
    resources = [aws_iam_role.this.arn]
  }

  statement {
    sid       = "DeployOIDCRoleManagementPermissions"
    actions   = local.oidc_role_management_actions
    resources = [aws_iam_role.this.arn]
  }

  statement {
    sid       = "AllowDefinedResourcePermissions"
    actions   = var.oidc_role_actions
    resources = var.oidc_resources
  }
}

data "aws_iam_policy_document" "github_assume_actions" {
  statement {
    actions = local.oidc_assume_actions
    sid = "AllowGitHubOIDCProviderAssume"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_domain}:aud"

      values = data.aws_iam_openid_connect_provider.this.client_id_list
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_domain}:sub"

      values = local.repo_subjects
    }
  }
}

data "aws_s3_bucket" "tf_state_bucket" {
  bucket = var.state_bucket
}

data "aws_dynamodb_table" "tf_lock_table" {
  name = var.state_lock_table
}

data "aws_iam_policy_document" "terraform_state_management" {
  statement {
    sid = "AllowS3StateManagement"
    actions = local.s3_state_actions
    resources = [
      "${data.aws_s3_bucket.tf_state_bucket.arn}",
      "${data.aws_s3_bucket.tf_state_bucket.arn}/*"
    ]
  }

  statement {
    sid = "AllowDynamodbLockManagemnt"
    actions = local.dyanamodb_state_actions
    resources = [
      data.aws_dynamodb_table.tf_lock_table.arn
    ]
  }
}
