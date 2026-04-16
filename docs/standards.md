# Technical standards (template)

## Naming
- Use a short `project` code and `environment` suffix.
- Keep globally-unique resources within length constraints (Storage/KeyVault).

## Tagging
Required tags used by this template:
- `project`
- `env`
- `owner`
- `costCenter`

## Terraform
- Prefer small modules with clear inputs/outputs.
- Use remote state (Azure Storage) and environment separation.
- Treat `prod` as protected: approvals + slower rollout.

## Security defaults
- Use managed identities for workload-to-workload auth where possible.
- Scope RBAC to the smallest workable scope (namespace/queue/RG).
- Keep secrets in GitHub Secrets (CI) and Key Vault (runtime) when needed.

