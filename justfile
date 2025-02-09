_default:
    just --list


get-git-token:
    #!/usr/bin/env bash
    if ! gh auth status &> /dev/null; then
        gh auth login
    fi
    GITHUB_TOKEN=$(gh auth token 2>/dev/null)
    echo $GITHUB_TOKEN


branch name:
    #!/usr/bin/env bash
    git checkout main
    git fetch && git pull
    git branch {{ name }} && git checkout {{ name }}


format:    
    #!/usr/bin/env bash
    terraform fmt -recursive
    terragrunt hclfmt


get-cache-key os tg_directory:
    #!/usr/bin/env bash
    LOCK_HASH=$(sha256sum "{{ tg_directory }}/.terraform.lock.hcl" | awk '{ print $1 }')
    echo "terragrunt-{{ os }}-{{ tg_directory }}-${LOCK_HASH}"


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
    cd {{justfile_directory()}}/infra/live/{{env}}/{{module}} ; terragrunt {{op}}


tg-all op:
    #!/usr/bin/env bash
    cd {{justfile_directory()}}/infra/live 
    terragrunt run-all {{op}}


init env:
    #!/usr/bin/env bash
    export TF_VAR_git_token=$(just get-git-token)
    just tg {{env}} aws/oidc apply
    just tg {{env}} github/environment apply


setup:
    #!/usr/bin/env bash
    export TF_VAR_git_token=$(just get-git-token)
    just tg ci github/repo apply


PROJECT_DIR := justfile_directory()

clean-terragrunt-cache:
    @echo "Cleaning up .terraform directories in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type d -name ".terraform" -exec rm -rf {} +
    @echo "Cleaning up .terraform.lock.hcl files in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type f -name ".terraform.lock.hcl" -exec rm -f {} +
    @echo "Clearing Terragrunt cache..."
    rm -rf ~/.terragrunt
