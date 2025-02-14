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
    @echo "Cleaning up .terragrunt-cache directories in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type d -name ".terragrunt-cache" -exec rm -rf {} +
    @echo "Cleaning up terragrunt-debug.tfvars.json files in {{PROJECT_DIR}}..."
    find {{PROJECT_DIR}} -type f -name "terragrunt-debug.tfvars.json" -exec rm -f {} +


build version:
    #!/usr/bin/env bash
    python_dir="{{PROJECT_DIR}}/src"
    cd $python_dir
    zip_file="{{PROJECT_DIR}}/{{version}}.zip"
    zip -r $zip_file . > /dev/null
    echo $zip_file


local-upload s3_bucket_name:
    #!/usr/bin/env bash
    local_version="$(hostname | tr 'A-Z>.' 'a-z--')-$(git rev-parse --short HEAD)"
    zip_file_path=$(just build $local_version)
    aws s3 cp "$zip_file_path" "s3://{{s3_bucket_name}}/" --quiet
    basename $zip_file_path


local-deploy env:
    #!/usr/bin/env bash
    just init {{env}}
    just tg {{env}} aws/oidc apply
    just tg {{env}} aws/bucket apply
    s3_bucket_name=$(just tg {{env}} aws/bucket 'output -raw bucket_name')
    export TF_VAR_lambda_code_key=$(just local-upload $s3_bucket_name)
    echo "deploying.. $TF_VAR_lambda_code_key"
    just tg {{env}} aws/lambda apply