variable "git_token" {
  type = string
}

variable "git_repo" {
  type = string
}

variable "environment" {
  type = string
}

variable "variables" {
  description = "Map of environment variables for the GitHub Actions environment"
  type        = map(string)
  default     = {}
}