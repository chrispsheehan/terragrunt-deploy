terraform {
  // overridden by backend setup in infra/terragrunt.hcl ////
  backend "s3" {} // only required for local modules ///////
  ///////////////////////////////////////////////////////////

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}