resource "aws_iam_role" "this" {
  name               = var.deploy_role_name
  description        = "OIDC role to deploy terragrunt code in Github pipelines"
  assume_role_policy = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role_policy_attachment" "terraform_actions" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.terraform_actions.arn
}

resource "aws_iam_policy" "terraform_actions" {
  description = "Access to defined resources and actions during deployments"
  name        = "${var.deploy_role_name}-terragrunt-ci-action"
  policy      = data.aws_iam_policy_document.terraform_actions.json
}

resource "aws_iam_role_policy_attachment" "terraform_state" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.terraform_state.arn
}

resource "aws_iam_policy" "terraform_state" {
  description = "Access to s3 and dynamodb to allow for state management in ci"
  name        = "${var.deploy_role_name}-terragrunt-ci-state-management"
  policy      = data.aws_iam_policy_document.terraform_state.json
}
