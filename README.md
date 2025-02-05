# terragrunt-deploy

Repo configuration and modular deployments of aws resources leveraging Github action environments. Enabling configuration at global and environment levels.

## setup local env

Requires a github login with relevant repository privileges.

`just` is used to run `aws` and `terragrunt` commands.

```sh
brew install just
brew install awscli
brew install gh
```

## setup repo

Apply Github repository settings and preferences.

```sh
just setup
```

## initiate an environment locally

Creates:
  - OIDC role for ci deployment to aws resources
  - Github environment containing required environment variables

```sh
just init prod
```

***WARNING***
Terragrunt will create the s3 state bucket the first time this is done - this should only happen *ONCE*.

```sh
Remote state S3 bucket your-state-bucket-name-tfstate does not exist or you dont have permissions to access it. Would you like Terragrunt to create it? (y/n) y
```

## locally plan

This is in the format of `just tg [environment] [provider/module] [action]`. Example below.

```sh
just tg prod aws/bucket plan
```

## variables

Can be set withing an hcl via `inputs = {}` within `infra/terragrunt.hcl` or via files at the below paths.

- root level `infra/live/global_vars.hcl`
- environment level `infra/live/[env_name]_vars.hcl`
  - example `infra/live/dev_vars.hcl`

## releases

Update version within `pyproject.toml` and commit to `main` to trigger a release.

Prod is deployed when a release is created.