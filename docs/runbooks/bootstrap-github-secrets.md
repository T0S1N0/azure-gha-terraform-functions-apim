# Runbook: bootstrap GitHub Secrets

## Create an Azure service principal
Use a dedicated service principal for CI/CD and grant it least-privilege access.

Example (subscription scope):

```bash
SUBSCRIPTION_ID="<sub-id>"
SP_NAME="sp-gha-terraform"

az account set --subscription "$SUBSCRIPTION_ID"
az ad sp create-for-rbac \
  --name "$SP_NAME" \
  --role "Contributor" \
  --scopes "/subscriptions/$SUBSCRIPTION_ID"
```

Capture:
- **client id** (appId)
- **client secret** (password)
- **tenant id**
- **subscription id**

## Create Terraform state backend and capture outputs
Deploy `infra/terraform/shared/state` and capture:
- `resource_group_name`
- `storage_account_name`
- `container_name`

## Add GitHub Secrets
Set these repository secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_CLIENT_SECRET`
- `TFSTATE_RESOURCE_GROUP`
- `TFSTATE_STORAGE_ACCOUNT`
- `TFSTATE_CONTAINER`

## Protect production
In GitHub, create environments:
- `dev` (no reviewers required)
- `prod` (require reviewers)

