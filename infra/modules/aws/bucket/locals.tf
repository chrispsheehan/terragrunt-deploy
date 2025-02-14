locals {
  read_actions = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  ci_actions = concat(local.read_actions, [
    "s3:PutObject"
  ])
}
