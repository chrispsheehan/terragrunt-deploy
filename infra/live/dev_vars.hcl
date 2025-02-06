locals {
  deploy_branches = [
    "dev"
  ]
}

inputs = {
  deploy_branches = local.deploy_branches
}
