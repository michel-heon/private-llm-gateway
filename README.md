# private-llm-gateway

Documented starter project for exposing a **local LLM on macOS** as a **secure OpenAI-compatible HTTPS API** endpoint for **Copilot Chat / VS Code BYOK / Custom Endpoint** scenarios where supported.

## Project purpose

This repository provides a foundation to build a private gateway stack:

- Local model runtime with **Ollama** on macOS
- Local OpenAI-compatible gateway with **LiteLLM**
- Local relay agent bridging private traffic through **Azure Relay Hybrid Connection**
- Public HTTPS API exposed by an **Azure HTTPS proxy** at `https://llm.example.com/v1`

> Azure Relay is **not** the public API endpoint. It is only the private bridge between Azure and your macOS machine.

## Target architecture

```text
GitHub Copilot Chat / VS Code BYOK
  -> https://llm.example.com/v1
  -> Azure HTTPS proxy
  -> Azure Relay Hybrid Connection
  -> local relay agent on macOS
  -> LiteLLM OpenAI-compatible gateway
  -> Ollama local model runtime
```

See [/docs/architecture/overview.md](/docs/architecture/overview.md).

## Supported use cases

- Private/local model access through an OpenAI-compatible endpoint
- VS Code tools that can call custom OpenAI-compatible HTTPS endpoints
- GitHub Copilot BYOK / Custom Endpoint workflows where supported
- Foundation for further hardening and productionization

## Unsupported use cases

- Directly exposing Ollama to the Internet
- Using Azure Relay alone as a public endpoint
- Claiming support for every Copilot feature in every environment
- Replacing GitHub Copilot inline completions

## Component relationships

- **VS Code / Copilot BYOK / Custom Endpoints**: API clients (when supported by your plan and feature availability)
- **Azure HTTPS proxy**: required Internet-facing TLS endpoint and auth boundary
- **Azure Relay Hybrid Connection**: private bridge from Azure to local agent
- **Local macOS relay agent**: receives proxied requests and forwards to localhost LiteLLM
- **LiteLLM**: OpenAI-compatible API surface mapped to Ollama backend
- **Ollama**: local model runtime bound to localhost
- **GoDaddy DNS**: optional DNS host for mapping `llm.example.com` to Azure proxy

## Security warnings

- Require authentication on the public endpoint (API key, token, or equivalent).
- Enforce HTTPS/TLS at the public edge.
- Keep Ollama and LiteLLM bound to `127.0.0.1` by default.
- Apply rate limiting, request size limits, and structured logging with redaction.
- Use least privilege for Azure identity, relay, and deployment credentials.
- Do not commit secrets; use environment variables and secret stores.

See [/docs/reference/security.md](/docs/reference/security.md).

## Quick start overview

1. Copy and edit example configs in `/config` and `.env.example`.
2. Start Ollama locally: `make start-local` (or `scripts/start-ollama.sh`).
3. Start LiteLLM on localhost: `scripts/start-litellm.sh`.
4. Start local relay prototype: `scripts/start-local-agent.sh`.
5. Test local API: `make test-local`.
6. Deploy Azure HTTPS proxy and Relay resources (TODO placeholders in docs/config).
7. Point DNS (for example via GoDaddy) to the Azure HTTPS proxy.
8. Test public endpoint: `make test-public`.

## Repository layout

- `docs/` architecture, security, integration, DNS, and limitations guides
- `config/` sample config files for LiteLLM, proxy env, relay env, Caddy, and NGINX
- `scripts/` helper scripts to start components and test endpoints
- `local-agent/` minimal prototype relay agent skeleton
