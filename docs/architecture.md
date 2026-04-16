# Architecture

## Request / data flow

```mermaid
flowchart LR
  Client[Client] --> APIM[APIManagement]
  APIM --> Func[AzureFunctions_HTTP]
  Func --> SB[ServiceBus_Queue]
  Func --> AI[AppInsights]
  APIM --> LA[LogAnalytics]
  SB --> LA
```

## CI/CD flow

```mermaid
flowchart LR
  Dev[Developer] --> PR[PullRequest]
  PR --> Plan[GitHubActions_TerraformPlan]
  Plan --> TFState[AzureStorage_TFState]
  Main[mainBranch] --> Apply[GitHubActions_TerraformApply]
  Apply --> Azure[AzureSubscription]
  Apply --> Deploy[GitHubActions_FunctionDeploy]
  Deploy --> Func[AzureFunctions_HTTP]
```

## Components
- **API Management**: front door, routing, policies (rate limit, headers, optional JWT validation).
- **Azure Functions**: HTTP-triggered function; uses managed identity to access Service Bus and (optionally) Key Vault.
- **Service Bus**: queue for asynchronous messaging.
- **Observability**: Application Insights + Log Analytics; diagnostic settings enabled for platform resources.

## Hybrid considerations
This template is cloud-native but includes notes for hybrid extensions (private endpoints, private DNS, on-prem connectivity via VPN/ExpressRoute, and controlled egress patterns). See `docs/security.md` and `docs/troubleshooting.md`.

