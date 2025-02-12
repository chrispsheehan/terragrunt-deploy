terraform {
  // overridden by backend setup in infra/terragrunt.hcl ////
  backend "s3" {} // only required for local modules ///////
  ///////////////////////////////////////////////////////////

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.67.0"
    }
  }
}
