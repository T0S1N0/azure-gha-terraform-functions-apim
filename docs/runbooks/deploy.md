# Runbook: deploy

## Local deploy (dev)
1. Bootstrap Terraform state (one-time): `infra/terraform/shared/state/README.md`
2. `cd infra/terraform/envs/dev`
3. `terraform init`
4. `terraform plan`
5. `terraform apply`

## GitHub Actions deploy
- PR triggers `terraform plan`
- Merge to `main` triggers `terraform apply` for **dev**
- **prod** requires manual approval via GitHub Environments

