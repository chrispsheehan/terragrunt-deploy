variable "deploy_role_name" {
  type        = string
  description = "The name of the OIDC role to be created"
}

variable "github_repo" {
  type        = string
  description = "The target repo for OIDC access i.e octo-org/octo-repo"
}

variable "state_bucket" {
  description = "Name of s3 terraform state bucket - used to allow state updates in ci deployments"
  type        = string
}

variable "state_lock_table" {
  description = "Name of dynamo db terraform state lock table - used to allow state locking in ci deployments"
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

variable "deploy_environments" {
  type        = list(string)
  description = "The github environments allowed to deploy with this role"
  default     = []
}

variable "allow_deployments" {
  type        = bool
  description = "Allow github deployments to use role"
  default     = false
}

variable "allowed_role_actions" {
  type        = list(string)
  description = "The action(s) to be allowed i.e. [dynamodb:*]"
  default     = []
}

variable "allowed_role_resources" {
  type        = list(string)
  description = "The resource(s) to be allowed - will be limited by the above actions"
  default     = ["*"]
}
