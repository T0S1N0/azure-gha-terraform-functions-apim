# azure-gha-terraform-functions-apim

A production-style Azure Cloud reference template that uses Terraform and GitHub Actions to deploy a secure, observable **API Management → Azure Functions → Service Bus** workflow, showcasing RBAC/governance, networking patterns, remote state, and dev→prod environment promotion.

## What this repo demonstrates
- **Terraform** (IaC) with **remote state** in Azure Storage
- **GitHub Actions** CI/CD (plan/apply + app deploy)
- **Azure Functions** (HTTP) behind **API Management**
- **Azure Service Bus** for messaging
- **Key Vault**, **Application Insights**, **Log Analytics**, and diagnostics
- **RBAC** + (optional) **Azure Policy** guardrails

## Architecture (high level)
1. Client calls **API Management**.
2. APIM forwards to **Azure Functions** backend.
3. Function enqueues a message to **Service Bus**.
4. Logs/metrics flow into **Application Insights / Log Analytics**.

More detail: see [`docs/architecture.md`](docs/architecture.md).

## Environments and flow
- **dev**
  - Deploy infra by running the `terraform-apply` workflow with `environment=dev`
  - App deploy runs automatically after a successful `apply-dev` via the `deploy-app-dev` job (zip deploy)
- **prod**
  - Deploy infra by running the `terraform-apply` workflow with `environment=prod` (or `both`)
  - Use GitHub **Environments** for approvals/controls

## Repo layout
- `infra/terraform/`: Terraform modules + environment compositions
- `app/functions/`: sample Functions app
- `app/contracts/`: OpenAPI and APIM policy snippets
- `.github/workflows/`: GitHub Actions pipelines
- `docs/`: architecture, runbooks, security, troubleshooting

## Quickstart (local)
1. Install prerequisites:
   - Terraform
   - Azure CLI
   - (Optional) Functions Core Tools
2. Bootstrap Terraform state (one-time): see [`infra/terraform/shared/state/README.md`](infra/terraform/shared/state/README.md)
3. Deploy dev infra:
   - `cd infra/terraform/envs/dev`
   - `terraform init`
   - `terraform plan`
   - `terraform apply`

## Quickstart (GitHub Actions)
This repo uses **OIDC** with `azure/login` (no `AZURE_CLIENT_SECRET` required).

1. Configure GitHub OIDC in Azure and grant permissions.
   - Runbook: [`docs/runbooks/bootstrap-github-secrets.md`](docs/runbooks/bootstrap-github-secrets.md)
2. Set GitHub **Secrets** or **Variables** (workflows read either).
   - **Azure auth**
     - `AZURE_CLIENT_ID`
     - `AZURE_TENANT_ID`
     - `AZURE_SUBSCRIPTION_ID`
   - **Terraform remote state**
     - `TFSTATE_RESOURCE_GROUP` (default `rg-tfstate`)
     - `TFSTATE_STORAGE_ACCOUNT` (optional; auto-discovered by tag `purpose=terraform-state`)
     - `TFSTATE_CONTAINER` (default `tfstate`)
3. Open a PR to get a Terraform plan via `terraform-plan`.
4. Deploy via `terraform-apply` (manual dispatch recommended):
   - `environment=dev | prod | both`
   - `reset=true` for a **hard reset** (delete tfstate blob + delete resource group) and recreate cleanly

## End-to-end test (APIM → Function → Service Bus)
### Call the API via APIM
By default, APIM requires a **subscription key** (header `Ocp-Apim-Subscription-Key`). The demo API is exposed under:

- **Default path**: `/demo/ping`

#### 1) Discover APIM gateway URL

```bash
RG_DEV="rg-cce-dev"
APIM_NAME=$(az apim list -g "$RG_DEV" --query "[0].name" -o tsv)
APIM_GATEWAY=$(az apim show -g "$RG_DEV" -n "$APIM_NAME" --query gatewayUrl -o tsv)
echo "$APIM_GATEWAY"
```

#### 2) Create a subscription for `demo-api` and fetch its key

```bash
RG_DEV="rg-cce-dev"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
APIM_NAME=$(az apim list -g "$RG_DEV" --query "[0].name" -o tsv)

SID="e2e-demo-api"
SUB_RESOURCE_ID="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RG_DEV}/providers/Microsoft.ApiManagement/service/${APIM_NAME}/subscriptions/${SID}"

az rest --method put \
  --uri "https://management.azure.com${SUB_RESOURCE_ID}?api-version=2022-08-01" \
  --body '{
    "properties": {
      "displayName": "E2E demo-api",
      "scope": "/apis/demo-api",
      "state": "active",
      "allowTracing": false
    }
  }' >/dev/null

KEY=$(az rest --method post \
  --uri "https://management.azure.com${SUB_RESOURCE_ID}/listSecrets?api-version=2022-08-01" \
  --query primaryKey -o tsv)

echo "$KEY"
```

#### 3) Call the endpoint

```bash
RG_DEV="rg-cce-dev"
APIM_NAME=$(az apim list -g "$RG_DEV" --query "[0].name" -o tsv)
APIM_GATEWAY=$(az apim show -g "$RG_DEV" -n "$APIM_NAME" --query gatewayUrl -o tsv)

curl -sS -H "Ocp-Apim-Subscription-Key: $KEY" \
  "$APIM_GATEWAY/demo/ping"
```

Expected:
- HTTP **200**
- JSON contains `"ok": true` and usually `"queued": true`

### Verify the message was enqueued in Service Bus

```bash
RG_DEV="rg-cce-dev"
SB_NAME=$(az servicebus namespace list -g "$RG_DEV" --query "[0].name" -o tsv)
QUEUE_NAME=$(az servicebus queue list -g "$RG_DEV" --namespace-name "$SB_NAME" --query "[0].name" -o tsv)

az servicebus queue show -g "$RG_DEV" --namespace-name "$SB_NAME" --name "$QUEUE_NAME" \
  --query "countDetails.activeMessageCount" -o tsv
```

## Environments
- See **Environments and flow** above.

## Permissions notes (optional features)
- **RBAC role assignments**:
  - Creation is disabled by default (`enable_rbac_role_assignments=false`) to avoid requiring `Owner` / `User Access Administrator`
  - If enabled, the Terraform runner identity must be able to write role assignments (`Microsoft.Authorization/roleAssignments/write`)
- **Azure Policy**:
  - Disabled by default (policy definitions require elevated permissions)

## Notes
- The template is **subscription-scoped by default**, but the docs include guidance for **management-group scope** (enterprise landing zones).
