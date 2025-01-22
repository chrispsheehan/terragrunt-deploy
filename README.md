# terragrunt-deploy

setup env

```sh
brew install just
brew install awscli
```

init
Remote state S3 bucket [your-state-bucket-name]-tfstate does not exist or you don't have permissions to access it. Would you like Terragrunt to create it? (y/n) y

just tg dev aws/bucket plan
just tg dev github/environment plan