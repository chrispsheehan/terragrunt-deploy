locals {
  # aws_account_id = 700011111111 could set a different account id here

  aws_account_id = get_aws_account_id()
  # add account ids for environments which differ to the deploying account (above)
  allowed_read_aws_account_ids = [
    local.aws_account_id
  ]
}

inputs = {
  # aws_account_id = local.aws_account_id
  allowed_read_aws_account_ids = local.allowed_read_aws_account_ids
}
