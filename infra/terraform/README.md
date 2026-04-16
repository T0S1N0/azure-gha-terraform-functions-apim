# Terraform

## Structure
- `modules/`: reusable building blocks (networking, security, app platform resources)
- `shared/state/`: one-time bootstrap for the Azure Storage backend
- `envs/dev`, `envs/prod`: environment compositions that call modules

## Typical workflow
1. Bootstrap remote state: `shared/state/`
2. Configure backends in `envs/dev/backend.tf` and `envs/prod/backend.tf`
3. Deploy:
   - `terraform init`
   - `terraform plan`
   - `terraform apply`

