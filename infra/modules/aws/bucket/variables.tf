variable "aws_region" {
  description = "Region to which resources will be deployed"
  type        = string
}

variable "environment" {
  description = "Environment to which resources will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name used in naming deployed resources"
  type        = string
}