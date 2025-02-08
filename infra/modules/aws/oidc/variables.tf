variable "aws_region" {
  description = "Region to which resources will be deployed"
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

variable "deploy_branches" {
  type        = list(string)
  description = "The target repo branches for OIDC access i.e main or feature/this"
  default     = []
}

variable "deploy_tags" {
  type        = list(string)
  description = "The target repo tag for OIDC access i.e * or v*"
  default     = []
}

variable "environments" {
  type        = list(string)
  description = "The github environments allowed to deploy with this role"
  default     = []
}

variable "allow_deployments" {
  type        = bool
  description = "Allow github deployments to use role"
  default     = false
}

variable "oidc_role_actions" {
  type        = list(string)
  description = "The action(s) to be allowed i.e. [dynamodb:*]"
  default     = []
}

variable "deploy_role_name" {
  type        = string
  description = "The role to use by OIDC"
}

variable "github_repo" {
  type        = string
  description = "The target repo for OIDC access i.e octo-org/octo-repo"
}

variable "oidc_resources" {
  type        = list(string)
  description = "The resource(s) to be allowed"
  default     = ["*"]
}
