# Runbook: rollback

## Infrastructure
- Roll back by re-applying a previous version of the Terraform configuration (tag/commit).
- For destructive changes, prefer a `terraform plan` review and staged rollouts (dev → prod).

## Application
- Re-deploy a previous Functions artifact from CI (or re-run a workflow for a previous commit).

