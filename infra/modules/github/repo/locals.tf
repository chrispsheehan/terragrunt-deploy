locals {
  allowed_actions = [
    "actions/cache@*",
    "actions/checkout@*",
    "actions/setup-python@*",
    "aws-actions/configure-aws-credentials@*",
    "extractions/setup-just@*",
    "hashicorp/setup-terraform@*",
    "autero1/action-terragrunt@*"
    "softprops/action-gh-release@*"
  ]
}