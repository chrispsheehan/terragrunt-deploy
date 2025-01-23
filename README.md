# terragrunt-deploy

## setup local env

`just` is used to run `aws` and `terragrunt` commands.

```sh
brew install just
brew install awscli
```

## initiate locally

Initially the aws OIDC role needs to be created with a local script. This allows Github to execute, via terragrunt, defined actions on defined resources.

This is done with `just tg ci aws/oidc apply`

***WARNING***
Terragrunt will create the s3 state bucket the first time this is done - this should only happen *ONCE*.

```sh
Remote state S3 bucket your-state-bucket-name-tfstate does not exist or you dont have permissions to access it. Would you like Terragrunt to create it? (y/n) y
```

## locally plan

This is in the format of `just tg [environment] [provider/module]`[action]

Examples below

```sh
just tg dev aws/bucket plan
just tg dev github/environment plan
```