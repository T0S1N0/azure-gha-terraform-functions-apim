# Runbook: rotate Azure service principal secret (GitHub Actions)

## 1) Create a new client secret
In Entra ID (Azure AD), generate a new client secret for the CI service principal.

CLI example:

```bash
APP_ID="<client-id>"
az ad app credential reset --id "$APP_ID"
```

## 2) Update GitHub Secret
Update `AZURE_CLIENT_SECRET` in GitHub repository secrets.

## 3) Validate
- Trigger `terraform-plan` on a PR (or run `terraform-apply` via workflow dispatch).
- Confirm Azure login succeeds and Terraform can read/write state.

## 4) Revoke old secret
Remove the previous credential from the app registration once the new one is confirmed working.

