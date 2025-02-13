✅ Branches take top priority—if a branch is allowed, it overrides everything else.

✅ Environments serve as a fallback—**if a branch is not allowed, but the environment is**, the workflow runs.

✅ Tags can allow deployments from versioned releases if neither branch nor environment is explicitly allowed.

✅ `allow_deployments` acts as a global override—if enabled, all workflows can assume the role.

✅ IAM role permissions (`allowed_role_actions` and `allowed_role_resources`) determine AWS access.