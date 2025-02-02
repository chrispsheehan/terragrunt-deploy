data "aws_iam_openid_connect_provider" "this" {
  arn = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_domain}"
}

data "aws_iam_policy_document" "terraform_actions" {
  statement {
    actions   = concat(local.oidc_actions, var.actions)
    resources = var.resources
  }
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = local.oidc_actions

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

data "aws_iam_policy_document" "terraform_state" {
  statement {
    actions = local.oidc_actions
    resources = [
      "*"
    ]
  }

  statement {
    actions = local.iam_actions
    resources = [
      "*"
    ]
  }

  statement {
    actions = local.s3_actions
    resources = [
      "${data.aws_s3_bucket.tf_state_bucket.arn}",
      "${data.aws_s3_bucket.tf_state_bucket.arn}/*"
    ]
  }

  statement {
    actions = local.dyanamodb_actions
    resources = [
      data.aws_dynamodb_table.tf_lock_table.arn
    ]
  }
}