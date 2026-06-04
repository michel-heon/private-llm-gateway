# Architecture

## Goal

Expose a local macOS-hosted LLM as an OpenAI-compatible HTTPS endpoint:

`https://llm.example.com/v1`

## Data flow

1. Client (VS Code / Copilot Chat BYOK where supported) sends OpenAI-style request over HTTPS.
2. Azure HTTPS proxy authenticates request and forwards to Azure Relay Hybrid Connection.
3. Local relay agent on macOS receives request via relay.
4. Agent forwards request to LiteLLM (`http://127.0.0.1:4000`).
5. LiteLLM routes to Ollama (`http://127.0.0.1:11434`).
6. Response returns back through the same path.

## Design notes

- Public ingress must be Azure HTTPS proxy (App Service, Container Apps, or similar).
- Azure Relay is private connectivity, not public ingress.
- Ollama and LiteLLM should remain localhost-only.
- Add TODOs for tenant/resource/domain specifics during deployment.

## TODOs

- TODO: Replace placeholder Azure resource names with your subscription resources.
- TODO: Replace `llm.example.com` with your domain.
