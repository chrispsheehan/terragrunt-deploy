resource "aws_s3_bucket" "this" {
  bucket = "${local.account_ref}-${local.project_ref}"
}