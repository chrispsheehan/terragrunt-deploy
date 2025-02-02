locals {
  repo_subjects = [for ref in var.repo_refs : format("repo:%s:ref:%s", var.git_repo, ref)]
  allowed_entities = concat(
    [
      "repo:${var.git_repo}:environment:${var.environment}"
    ],
    local.repo_subjects
  )
  oidc_domain = "token.actions.githubusercontent.com"
  oidc_actions = [
    "sts:AssumeRoleWithWebIdentity",
    "sts:TagSession"
  ]
  s3_actions = [
    "s3:ListBucket",
    "s3:GetBucketLocation",
    "s3:GetBucketPolicy",
    "s3:GetBucketPublicAccessBlock",
    "s3:GetBucketVersioning",
    "s3:GetEncryptionConfiguration",
    "s3:GetObject",
    "s3:PutObject",
    "s3:DeleteObject",
  ]
  dyanamodb_actions = [
    "dynamodb:ListTables",
    "dynamodb:DescribeTable",
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:DeleteItem",
    "dynamodb:DescribeContinuousBackups",
    "dynamodb:DescribeTimeToLive",
    "dynamodb:ListTagsOfResource"
  ]
  iam_actions = [
    "iam:GetOpenIDConnectProvider",
    "iam:GetRole",
    "iam:GetPolicy",
    "iam:GetPolicyVersion",
    "iam:GetPolicyVersions",
    "iam:ListPolicyVersions",
    "iam:CreatePolicyVersion",
    "iam:DeletePolicyVersion",
    "iam:ListRolePolicies",
    "iam:ListAttachedRolePolicies",
    "iam:UpdateAssumeRolePolicy",
  ]
}
