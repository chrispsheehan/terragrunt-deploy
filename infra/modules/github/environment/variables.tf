variable "aws_region" {
  description = "Region to which resources will be deployed"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account to which resources will be deployed"
  type        = string
}

variable "deploy_role_name" {
  description = "AWS role used in ci deployments"
  type        = string
}

variable "git_token" {
  description = "Git token used in authentication of github provider"
  type        = string
}

variable "git_repo" {
  description = "Name of a the github repo"
  type        = string
}

variable "environment" {
  description = "Name of github actions environment"
  type        = string
}
