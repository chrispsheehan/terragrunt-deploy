locals {
  repo_branch_refs  = [for ref in var.deploy_branches : format("repo:%s:ref:heads/%s", var.github_repo, ref)]
  repo_tag_refs     = [for ref in var.deploy_tags : format("repo:%s:ref:tags/%s", var.github_repo, ref)]
  repo_environments = [for ref in var.environments : format("repo:%s:environment:%s", var.github_repo, ref)]
  repo_deployments  = var.allow_deployments ? [format("repo:%s:deployment", var.github_repo)] : []
  repo_subjects     = concat(local.repo_branch_refs, local.repo_tag_refs, local.repo_environments, local.repo_deployments)
  oidc_domain       = "token.actions.githubusercontent.com"
  oidc_assume_actions = [
    "sts:AssumeRoleWithWebIdentity",
    "sts:TagSession"
  ]
  s3_state_actions = [
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
  dyanamodb_state_actions = [
    "dynamodb:ListTables",
    "dynamodb:DescribeTable",
    "dynamodb:GetItem",
    "dynamodb:PutItem",
    "dynamodb:DeleteItem",
    "dynamodb:DescribeContinuousBackups",
    "dynamodb:DescribeTimeToLive",
    "dynamodb:ListTagsOfResource"
  ]
  oidc_management_actions = [
    "iam:GetOpenIDConnectProvider"
  ]
  role_management_actions = [
    "iam:GetRole",
    "iam:ListRolePolicies",
    "iam:ListAttachedRolePolicies",
    "iam:UpdateAssumeRolePolicy"
  ]
  policy_management_actions = [
    "iam:GetPolicy",
    "iam:GetPolicyVersion",
    "iam:GetPolicyVersions",
    "iam:ListPolicyVersions",
    "iam:CreatePolicyVersion",
    "iam:DeletePolicyVersion",
  ]
}
