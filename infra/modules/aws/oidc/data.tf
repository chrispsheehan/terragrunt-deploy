data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "this" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_domain}"
}

data "aws_iam_policy_document" "assume_identity" {

  statement {
    sid       = "AllowOIDCRoleAssumeIdentity"
    actions   = local.oidc_assume_actions
    resources = [aws_iam_role.this.arn]
  }

  statement {
    sid       = "AllowReadOIDCProvider"
    actions   = local.oidc_management_actions
    resources = [data.aws_iam_openid_connect_provider.this.arn]
  }
}

data "aws_iam_policy_document" "role_management" {
  statement {
    sid       = "AllowRoleManagementPermissions"
    actions   = local.role_management_actions
    resources = [aws_iam_role.this.arn]
  }

  statement {
    sid     = "AllowPolicyManagementPermissions"
    actions = local.policy_management_actions
    resources = [
      aws_iam_policy.defined.arn,
      aws_iam_policy.assume_identity.arn,
      aws_iam_policy.state_management.arn,
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.role_management_policy_name}"
    ]
  }
}

data "aws_iam_policy_document" "defined" {
  statement {
    sid       = "AllowDefinedResourcePermissions"
    actions   = var.oidc_role_actions
    resources = var.oidc_resources
  }
}

data "aws_iam_policy_document" "github_assume_policy" {
  statement {
    actions = local.oidc_assume_actions
    sid     = "AllowGitHubOIDCProviderAssume"

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

data "aws_iam_policy_document" "state_management" {
  statement {
    sid     = "AllowS3StateManagement"
    actions = local.s3_state_actions
    resources = [
      "${data.aws_s3_bucket.tf_state_bucket.arn}",
      "${data.aws_s3_bucket.tf_state_bucket.arn}/*"
    ]
  }

  statement {
    sid     = "AllowDynamodbLockManagemnt"
    actions = local.dyanamodb_state_actions
    resources = [
      data.aws_dynamodb_table.tf_lock_table.arn
    ]
  }
}
