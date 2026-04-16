# Troubleshooting

## GitHub Actions auth failures
- Ensure the SP has permissions at the correct scope (subscription or RG).
- Verify GitHub Secrets values are correct:
  - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_CLIENT_SECRET`

## Terraform state issues
- Confirm the backend Storage account/container exist and network rules allow access from the runner.
- If using strict networking, you may need a self-hosted runner inside the VNet.

## APIM returns 502/503
- Check APIM backend settings: URL points to the Function default host name.
- Verify Function app is running and reachable (public or via networking config).
- Review APIM diagnostics and App Insights traces.

## Function can’t send to Service Bus
- Confirm managed identity is enabled on the Function.
- Confirm RBAC role assignment exists:
  - `Azure Service Bus Data Sender` at namespace or queue scope
- Check Service Bus firewall settings (if enabled).

