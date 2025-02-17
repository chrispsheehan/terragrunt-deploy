variable "lambda_code_bucket" {
  description = "Name of the s3 bucket to create"
  type        = string
}

variable "s3_expiration_days" {
  description = "Number of days before objects are deleted (set to 0 to disable)"
  type        = number
  default     = 0
}

variable "deploy_role_name" {
  type        = string
  description = "The name of the OIDC role used in deploying the environment"
}

variable "allowed_read_aws_account_ids" {
  description = "AWS account ids allowed to download s3 object(s)"
  type        = list(string)
  default     = []
}

variable "allowed_write_role_arns" {
  description = "AWS OIDC role allowed to upload s3 object(s)"
  type        = list(string)
  default     = []
}