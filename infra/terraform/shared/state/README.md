# Terraform remote state bootstrap (Azure Storage)

This folder provisions the Azure Storage account + container used as the Terraform backend for `envs/dev` and `envs/prod`.

## Prereqs
- Azure CLI authenticated to the target tenant/subscription
- Terraform installed

## One-time steps (recommended)
1. Select subscription:
   - `az account set --subscription "<subscription-id>"`
2. (Optional) Create a dedicated resource group for state:
   - `az group create -n rg-tfstate -l westeurope`
3. Deploy the backend resources:
   - `cd infra/terraform/shared/state`
   - `terraform init`
   - `terraform apply`
4. Copy outputs into your environment backends (`envs/dev`, `envs/prod`):
   - `resource_group_name`
   - `storage_account_name`
   - `container_name`

## Notes
- You can lock down the storage account further (network rules/private endpoints). If you do, GitHub-hosted runners may not reach it; use a self-hosted runner in your network.

