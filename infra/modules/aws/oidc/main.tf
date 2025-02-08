resource "aws_iam_role" "this" {
  name               = var.deploy_role_name
  description        = "OIDC role to manage AWS resources in Github pipelines"
  assume_role_policy = data.aws_iam_policy_document.github_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "assume_identity" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.assume_identity.arn
}

resource "aws_iam_policy" "assume_identity" {
  description = "Assume OIDC role policy for Github Actions"
  name        = local.assume_identity_policy_name
  policy      = data.aws_iam_policy_document.assume_identity.json
}

resource "aws_iam_role_policy_attachment" "role_management" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.role_management.arn
}

resource "aws_iam_policy" "role_management" {
  description = "Allow management of OIDC role resources and actions"
  name        = local.role_management_policy_name
  policy      = data.aws_iam_policy_document.role_management.json
}

resource "aws_iam_role_policy_attachment" "defined" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.defined.arn
}

resource "aws_iam_policy" "defined" {
  description = "Access to defined resources and actions for Github actions"
  name        = local.defined_access_policy_name
  policy      = data.aws_iam_policy_document.defined.json
}

resource "aws_iam_role_policy_attachment" "state_management" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.state_management.arn
}

resource "aws_iam_policy" "state_management" {
  description = "Access to s3 and dynamodb to allow for state management in ci"
  name        = local.state_management_policy_name
  policy      = data.aws_iam_policy_document.state_management.json
}
