resource "aws_s3_bucket" "this" {
  bucket = var.lambda_code_bucket
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_bucket_roles.json
}

resource "aws_s3_bucket_lifecycle_configuration" "delete_old_files" {
  count = var.s3_expiration_days > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id     = "delete-expired-objects"
    status = "Enabled"

    expiration {
      days = var.s3_expiration_days
    }
  }
}
