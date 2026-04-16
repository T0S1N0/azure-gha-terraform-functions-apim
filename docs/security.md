# Security & governance

## Identity & access (RBAC)
- **Terraform deployer (GitHub Actions SP)**: scoped to the target subscription or (preferably) a dedicated resource group per environment.
- **Function managed identity**: granted only what it needs:
  - `Azure Service Bus Data Sender` (and/or `Azure Service Bus Data Receiver`) on the Service Bus namespace or queue
  - (Optional) `Key Vault Secrets User` if reading secrets at runtime

## Secrets
- GitHub Actions authenticates with a **service principal secret** stored in GitHub Secrets:
  - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_SECRET`
- App-level secrets should live in **Key Vault** (or use managed identity and avoid secrets entirely where possible).

## Policy (guardrails)
This repo includes a minimal, practical policy set (enabled via Terraform) designed to reflect enterprise landing-zone governance:
- Require tags (owner/cost/env)
- Enforce diagnostic settings where possible
- Optional: deny public network access for supported services (toggle per environment)

## Networking (secure-by-default path)
- Baseline uses VNet + subnets with the option to add private endpoints + private DNS.
- For tight enterprise environments, prefer:
  - private endpoints for Key Vault / Storage / Service Bus
  - APIM in internal mode or behind WAF (scenario-specific)

