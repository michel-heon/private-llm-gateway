# Azure HTTPS Proxy

## Why this layer is required

The public API endpoint must be an HTTPS-capable Azure service.
Azure Relay alone is not publicly routable API ingress.

## Candidate services

- Azure App Service
- Azure Container Apps
- Any small HTTPS service in Azure with auth + relay connectivity

## Responsibilities

- TLS termination
- Request authentication/authorization
- Basic policy enforcement (rate limits, size limits)
- Forwarding to Azure Relay Hybrid Connection

## TODOs

- TODO: Choose service type for your subscription.
- TODO: Configure managed identity / secret retrieval.
- TODO: Add deployment manifests for YOUR_AZURE_RESOURCE_GROUP.
