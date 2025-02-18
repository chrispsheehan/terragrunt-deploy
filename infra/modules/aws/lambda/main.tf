resource "aws_iam_role" "this" {
  name               = "${var.lambda_name}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "lambda_s3" {
  name   = "${var.lambda_name}-lambda-s3-policy"
  policy = data.aws_iam_policy_document.lambda_s3_read.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  policy_arn = aws_iam_policy.lambda_s3.arn
  role       = aws_iam_role.this.name
}

resource "aws_lambda_function" "this" {
  function_name = var.lambda_name
  role          = aws_iam_role.this.arn
  handler       = local.lambda_handler
  runtime       = local.lambda_runtime

  s3_bucket        = data.aws_s3_bucket.this.bucket
  s3_key           = data.aws_s3_object.this.key
  source_code_hash = data.aws_s3_object.this.etag
}

resource "aws_sqs_queue" "this" {
  name = "${var.lambda_name}-sqs"
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = aws_sqs_queue.this.arn
  function_name    = aws_lambda_function.this.arn
  enabled          = true
  batch_size       = 10
}

resource "aws_iam_policy" "sqs" {
  name   = "${var.lambda_name}-lambda-sqs-policy"
  policy = data.aws_iam_policy_document.lambda_s3_read.json
}

resource "aws_iam_role_policy_attachment" "sqs_policy" {
  policy_arn = aws_iam_policy.sqs.arn
  role       = aws_iam_role.this.name
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 1
}

resource "aws_iam_policy" "cloudwatch" {
  name   = "${var.lambda_name}-cloudwatch-policy"
  policy = data.aws_iam_policy_document.lambda_s3_read.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = aws_iam_policy.lambda_s3.arn
  role       = aws_iam_role.this.name
}