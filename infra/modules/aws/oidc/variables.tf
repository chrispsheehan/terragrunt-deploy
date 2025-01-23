variable "aws_region" {
  description = "Region to which resources will be deployed"
  type        = string
}

variable "aws_account_id" {
  description = "Account ID for AWS account"
  type        = string
}

variable "state_bucket" {
  description = "Name of s3 terragrunt state bucket"
  type        = string
}

variable "state_lock_table" {
  description = "Name of dynamo db terragrunt state lock table"
  type        = string
}

variable "repo_refs" {
  type        = list(string)
  description = "The target repo refs for OIDC access i.e heads/main or tags/*"
}

variable "actions" {
  type        = list(string)
  description = "The action(s) to be allowed i.e. [dynamodb:*]"
}

variable "role_name" {
  type        = string
  description = "The role to use by OIDC"
}

variable "resources" {
  type        = list(string)
  description = "The resource(s) to be allowed"
  default     = ["*"]
}
