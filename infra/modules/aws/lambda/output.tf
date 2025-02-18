output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.this.url
}
