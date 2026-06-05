# Local macOS Relay Agent

## Purpose

Run on macOS to terminate Azure Relay traffic locally, then proxy requests to LiteLLM on localhost.

## Responsibilities

- Connect outbound to Azure Relay Hybrid Connection
- Receive proxied HTTP requests
- Forward to `http://127.0.0.1:4000`
- Return response back through relay

## Safety defaults

- Keep LiteLLM on localhost only
- Keep Ollama on localhost only
- Avoid writing raw prompt contents to logs

## TODOs

- TODO: Add production-grade retries, health probes, and telemetry.
- TODO: Add hardened auth validation between proxy and agent.
