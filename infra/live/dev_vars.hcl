locals {
  deploy_branches = [
    "dev"
  ]
  # aws_account_id = 700011111111 could set a different account id here
}

inputs = {
  deploy_branches = local.deploy_branches
  # aws_account_id = local.aws_account_id
}
