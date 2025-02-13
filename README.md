# terragrunt-deploy

Repo configuration and modular deployments of aws resources leveraging Github action environments. Enabling configuration at global and environment levels.

- use multiple providers (aws/github) while sharing env vars
- low-friction method to initially setting up workflows/ci
- caching terraform init files via github cache in ci

## setup local env

Requires a github login with relevant repository privileges.

`just` is used to run `aws` and `terragrunt` commands.

```sh
brew install just
brew install awscli
brew install gh
brew install coreutils
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
    - **note** the environment controls which branches are allowed to deploy

```sh
just init prod
```

## locally plan

This is in the format of `just tg [environment] [provider/module] [action]`. Example below.

```sh
just tg prod aws/bucket plan
```

## variables

Defined via files named `infra/live/[env]_vars.hcl`. i.e `infra/live/dev_vars.hcl`.

## re-create lock files

```sh
just clean-terragrunt-cache
just tg-all init
```

## releases

Update version within `pyproject.toml` and commit to `main` to trigger a release.

Prod is deployed when a release is created.


## temp deploy branch

In some cases it may be necessary to deploy from a temporary branch.

To add one run the below. This example allows `some-temp-branch` to deploy from `dev`. Select branch on manual trigger in UI at `/actions/workflows/deploy_dev.yml`.

```sh
TEMP_DEPLOY_BRANCH=some-temp-branch just init dev
```

To setup automatic deployments on push. Add the branch name to `.github/workflows/deploy_dev.yml` as below.

```yaml
on:
  workflow_dispatch:
  push:
    branches:
      - main
      - some-temp-branch
```

revert with

```sh
just init dev
```

## gotchas

***WARNING***
Terragrunt will create the s3 state bucket the first time this is done - this should only happen *ONCE*.

```sh
Remote state S3 bucket your-state-bucket-name-tfstate does not exist or you dont have permissions to access it. Would you like Terragrunt to create it? (y/n) y
```