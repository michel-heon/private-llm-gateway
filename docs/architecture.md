# Architecture

## Goal

Expose a local macOS-hosted LLM as an OpenAI-compatible HTTPS endpoint:

`https://llm.example.com/v1`

## Data flow

1. Client (VS Code / Copilot Chat BYOK where supported) sends OpenAI-style request over HTTPS.
2. Azure HTTPS proxy authenticates request and forwards to Azure Relay Hybrid Connection.
3. Local relay agent on macOS receives request via relay.
4. Agent forwards request to LiteLLM (`http://127.0.0.1:4000`).
5. LiteLLM routes to local LLM runtime:
   - **Ollama**: `http://127.0.0.1:11434` (cross-platform, larger model library)
   - **macMLX**: `http://127.0.0.1:8080` (Apple Silicon only, 2x faster)
6. Response returns back through the same path.

## Design notes

- Public ingress must be Azure HTTPS proxy (App Service, Container Apps, or similar).
- Azure Relay is private connectivity, not public ingress.
- LLM runtime (Ollama or macMLX) and LiteLLM should remain localhost-only.
- Add TODOs for tenant/resource/domain specifics during deployment.

## Runtime LLM Options

Choose between two local LLM runtimes on macOS:

### Ollama
- ✅ Cross-platform (Linux, macOS, Windows)
- ✅ Largest model library
- ✅ Mature ecosystem
- ⚠️ Standard performance on Apple Silicon
- Default port: `11434`

### macMLX (Apple Silicon only)
- ✅ **2x faster** than Ollama on M1/M2/M3/M4
- ✅ Native Metal acceleration
- ✅ Better memory efficiency (unified memory)
- ⚠️ Smaller model library (MLX format required)
- ⚠️ macOS Apple Silicon only
- Default port: `8080`

**Recommendation**: Use macMLX for maximum performance on Apple Silicon. See [litellm-ollama.md](litellm-ollama.md) for detailed configuration.

## TODOs

- TODO: Replace placeholder Azure resource names with your subscription resources.
- TODO: Replace `llm.example.com` with your domain.
- TODO: Choose LLM runtime (Ollama or macMLX) and configure LiteLLM accordingly.
