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
1. Create an Azure service principal (SP) and grant access (documented).
2. Set GitHub Secrets:
   - `AZURE_CLIENT_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_CLIENT_SECRET`
   - `TFSTATE_RESOURCE_GROUP` (e.g. `rg-tfstate`)
   - `TFSTATE_STORAGE_ACCOUNT` (from `infra/terraform/shared/state` outputs)
   - `TFSTATE_CONTAINER` (default `tfstate`)
3. Open a PR to see `terraform plan`; merge to `main` to apply to `dev`.

## Environments
- **dev**: auto-apply on merge
- **prod**: protected with GitHub Environments + manual approval

## Notes
- The template is **subscription-scoped by default**, but the docs include guidance for **management-group scope** (enterprise landing zones).
