terraform {
  backend "s3" {}

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}