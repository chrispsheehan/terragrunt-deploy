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

variable "oidc_repo_refs" {
  type        = list(string)
  description = "The target repo refs for OIDC access i.e heads/main or tags/*"
}

variable "environment" {
  type = string
}

variable "oidc_role_actions" {
  type        = list(string)
  description = "The action(s) to be allowed i.e. [dynamodb:*]"
}

variable "deploy_role_name" {
  type        = string
  description = "The role to use by OIDC"
}

variable "git_repo" {
  type        = string
  description = "The target repo for OIDC access i.e octo-org/octo-repo"
}

variable "oidc_resources" {
  type        = list(string)
  description = "The resource(s) to be allowed"
  default     = ["*"]
}
