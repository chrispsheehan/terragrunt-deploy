variable "lambda_name" {
  description = "Name of lambda to be deployed"
  type        = string
}

variable "lambda_code_deploy_bucket" {
  description = "Name of s3 bucket from which to pull lambda zipped code from"
  type        = string
}

variable "lambda_code_key" {
  description = "Name of s3 code zip file key containing lambda code i.e /v1.0.0.zip"
  type        = string
}
