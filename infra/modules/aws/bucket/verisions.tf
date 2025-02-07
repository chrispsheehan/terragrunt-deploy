terraform {
  //this is overridden by backend setup in infra/terragrunt.hcl
  backend "s3" {}
  ///////////////////////////////////////////////////////////

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.67.0"
    }
  }
}
