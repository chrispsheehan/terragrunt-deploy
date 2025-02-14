variable "lambda_code_bucket" {
  description = "Name of the s3 bucket to create"
  type        = string
}

variable "s3_expiration_days" {
  description = "Number of days before objects are deleted (set to 0 to disable)"
  type        = number
  default     = 0
}