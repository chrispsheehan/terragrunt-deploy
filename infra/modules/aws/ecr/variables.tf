variable "base_ecr_name" {
  description = "Forms first part of repo URI/name"
  type        = string
}

variable "project_name" {
  description = "Forms second part of repo URI/name"
  type        = string
}

variable "allowed_read_aws_account_ids" {
  description = "AWS Account allowed to pull from ci ecr"
  type        = list(string)
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "image_expiration_days" {
  description = "Number of days before images are deleted (set to 0 to disable)"
  type        = number
  default     = 0
}
