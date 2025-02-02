_default:
    just --list


get-git-repo:
    #!/bin/bash
    origin_url=$(git remote get-url origin 2>/dev/null)

    if [ -z "$origin_url" ]; then
        echo "No remote named 'origin' found."
        exit 1
    fi

    if [[ $origin_url == git@* ]]; then
        repo_name=$(echo "$origin_url" | sed -e 's/^git@[^:]*://g' -e 's/.git$//')
    elif [[ $origin_url == http* ]]; then
        repo_name=$(echo "$origin_url" | sed -e 's/^https:\/\/[^/]*\///g' -e 's/.git$//')
    else
        echo "Unknown URL format: $origin_url"
        exit 1
    fi

    echo "$repo_name"


branch name:
    #!/usr/bin/env bash
    git checkout main
    git fetch && git pull
    git branch {{ name }} && git checkout {{ name }}


format:    
    #!/usr/bin/env bash
    terraform fmt -recursive
    terragrunt hclfmt


validate:
    #!/usr/bin/env bash
    for dir in terraform_modules/*; do
        if [ -d "$dir" ] && [[ $(basename "$dir") != '!'* ]]; then
            folder_name=$(basename "$dir")
            echo "Validating $folder_name"
            just tg "$folder_name" init
            just tg "$folder_name" validate
        fi
    done


# Terragrunt operation on {{module}} containing terragrunt.hcl
tg env module op:
    #!/usr/bin/env bash
    export AWS_REGION=eu-west-2
    export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
    export GIT_REPO=$(just get-git-repo)
    cd {{justfile_directory()}}/infra/live/{{env}}/{{module}} ; terragrunt {{op}} --terragrunt-debug


PROJECT_DIR := justfile_directory()

clean-terragrunt-cache:
    @echo "Cleaning up .terraform directories in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type d -name ".terraform" -exec rm -rf {} +
    @echo "Cleaning up .terraform.lock.hcl files in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type f -name ".terraform.lock.hcl" -exec rm -f {} +
    @echo "Clearing Terragrunt cache..."
    rm -rf ~/.terragrunt

init:
    #!/usr/bin/env bash
    if ! gh auth status &> /dev/null; then
        gh auth login
    fi
    GITHUB_TOKEN=$(gh auth token 2>/dev/null)
    export GITHUB_TOKEN
    just tg ci aws/oidc init
    just tg ci aws/oidc apply
    just tg ci github/environment init
    just tg ci github/environment apply
