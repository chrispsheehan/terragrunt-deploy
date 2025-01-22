locals {
  account_ref = "${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  project_ref = var.environment == "prod" ? var.project_name : "${var.environment}-${var.project_name}"
}