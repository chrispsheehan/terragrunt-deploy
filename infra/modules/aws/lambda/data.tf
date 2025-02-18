data "aws_s3_bucket" "this" {
  bucket = var.lambda_code_deploy_bucket
}

data "aws_s3_object" "this" {
  bucket = data.aws_s3_bucket.this.bucket
  key    = var.lambda_code_key
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_s3_read" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      data.aws_s3_bucket.this.arn,
      "${data.aws_s3_bucket.this.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "logs_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]

    effect = "Allow"

    resources = [
      "${aws_cloudwatch_log_group.this.arn}",
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "lambda_sqs" {
  statement {
    sid    = "SQSPermissions"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility"
    ]
    resources = [aws_sqs_queue.this.arn]
  }
}