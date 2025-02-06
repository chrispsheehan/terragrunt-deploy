locals {
  allowed_actions = [
    "actions/cache@*",
    "actions/checkout@*",
    "actions/setup-python@*",
    "aws-actions/configure-aws-credentials@*",
    "softprops/action-gh-release@*"
  ]
}