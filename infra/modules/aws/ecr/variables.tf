variable "base_ecr_name" {
  default = "Forms first part of repo URI/name"
  type    = string
}

variable "project_name" {
  default = "Forms second part of repo URI/name"
  type    = string
}

variable "allowed_read_aws_account_ids" {
  description = "AWS Account allowed to pull from ci ecr"
  type        = list(string)
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "min_image_count" {
  description = "Minimum image count to remain in ECR"
  type        = number
  default     = 1
}

variable "max_day_count" {
  description = "Maximum days to keep image in ECR"
  type        = number
  default     = 1
}
