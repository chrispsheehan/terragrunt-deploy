resource "aws_s3_bucket" "this" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.aws_region}-${var.project_name}"
}