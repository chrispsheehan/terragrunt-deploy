resource "aws_iam_role" "this" {
  name               = "${var.lambda_name}-iam"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_s3_read" {
  name   = "${var.lambda_name}-lambda-s3-read-policy"
  policy = data.aws_iam_policy_document.lambda_s3_read.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.lambda_s3_read.arn
  role       = aws_iam_role.this.name
}

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.this.arn
  handler       = local.lambda_handler
  runtime       = local.lambda_runtime

  s3_bucket        = data.aws_s3_bucket.this.bucket
  s3_key           = data.aws_s3_object.this.key
  source_code_hash = data.aws_s3_object.this.etag
}
