# VS Code Copilot BYOK (Bring Your Own Key)

Configure VS Code Copilot to use your own OpenAI-compatible LLM endpoints instead of GitHub's default models.

## Overview

This guide covers two scenarios:

1. **Local Development** — Use macMLX or Ollama running on your Mac
2. **Production** — Use Azure-hosted LiteLLM proxy with public HTTPS endpoint

## Prerequisites

- VS Code with GitHub Copilot extension installed
- Copilot subscription that supports custom endpoints (check your plan)
- Running LLM server (macMLX, Ollama, or remote LiteLLM proxy)

---

## Scenario 1: Local macMLX (Apple Silicon)

### Step 1: Start macMLX Server

```bash
# Install and start macMLX
make install           # One-time setup
make macmlx-start      # Start server

# Verify it's running
make macmlx-status
curl http://127.0.0.1:8080/v1/models
```

### Step 2: Configure VS Code Settings

Open VS Code Settings (JSON) and add:

```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:8080/v1",
    "model": "mlx-community/Qwen2.5-7B-Instruct-4bit"
  }
}
```

**Alternative: Using LiteLLM Proxy (if running)**

```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:4000/v1",
    "model": "qwen2.5-mlx"
  }
}
```

### Step 3: Test the Configuration

1. Open a code file in VS Code
2. Open Copilot Chat (`Ctrl+Shift+I` or `Cmd+Shift+I`)
3. Ask a question: "What is 2+2?"
4. Verify response comes from your local model

**Expected behavior:**
- ✅ Copilot Chat responds using your local model
- ✅ No API key required for local endpoints
- ✅ Fast responses (local inference)

---

## Scenario 2: Remote LiteLLM (Production)

### Endpoint Configuration

When your LiteLLM proxy is deployed to Azure with HTTPS endpoint:

```json
{
  "github.copilot.advanced": {
    "endpoint": "https://llm.example.com/v1",
    "apiKey": "your-bearer-token-here"
  }
}
```

### Security Considerations

- ✅ Use HTTPS endpoints only (required by VS Code)
- ✅ Store API keys in VS Code settings (encrypted at rest)
- ✅ Rotate keys regularly
- ⚠️ Don't commit VS Code settings with API keys to version control

---

## Available Models

### macMLX (Local - Port 8080)

Check available models:
```bash
curl http://127.0.0.1:8080/v1/models | python3 -m json.tool
```

Common models:
- `mlx-community/Qwen2.5-7B-Instruct-4bit` (default)
- `mlx-community/Mistral-7B-Instruct-v0.3-4bit`
- Any model from [Hugging Face MLX Community](https://huggingface.co/mlx-community)

### LiteLLM (Local - Port 4000 or Remote)

Models are defined in `config/litellm.yaml`. Example:

```yaml
model_list:
  - model_name: qwen2.5-mlx
    litellm_params:
      model: openai/mlx-community/Qwen2.5-7B-Instruct-4bit
      api_base: http://localhost:8080/v1
      api_key: dummy
```

---

## Troubleshooting

### Issue: "Failed to connect to endpoint"

**Cause:** Server not running or wrong port

**Solution:**
```bash
# Check if server is running
make macmlx-status

# Check port is listening
lsof -i :8080

# Restart server if needed
make macmlx-stop && make macmlx-start
```

### Issue: "Model not found"

**Cause:** Model name mismatch between VS Code config and server

**Solution:**
```bash
# List available models
curl http://127.0.0.1:8080/v1/models

# Update VS Code settings with exact model ID
```

### Issue: "Authentication failed"

**Cause:** 
- Local endpoint requires no API key (leave blank or use "not-needed")
- Remote endpoint requires valid bearer token

**Solution:**
```json
// Local (no auth)
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:8080/v1"
    // No apiKey needed
  }
}

// Remote (with auth)
{
  "github.copilot.advanced": {
    "endpoint": "https://llm.example.com/v1",
    "apiKey": "sk-..."
  }
}
```

### Issue: "Slow responses"

**Cause:** Model loading or insufficient resources

**Check:**
```bash
# Monitor server logs
tail -f /tmp/macmlx.log

# Check CPU/RAM usage
top -pid $(pgrep -f mlx_lm.server)
```

**Optimize:**
- Use 4-bit quantized models (smaller, faster)
- Close other applications to free RAM
- Choose smaller models (7B vs 13B)

---

## Performance Tips

### Model Selection

| Model Size | RAM Required | Speed | Quality |
|------------|--------------|-------|---------|
| 3B (4-bit) | ~2GB | Very Fast | Good |
| 7B (4-bit) | ~4GB | Fast | Excellent |
| 13B (4-bit) | ~8GB | Medium | Outstanding |

### macMLX vs Ollama

On **Apple Silicon Macs**, macMLX typically provides:
- 1.5-2x faster inference
- Better memory efficiency
- Native Metal acceleration

See [docs/guides/setup/litellm-ollama.md](../setup/litellm-ollama.md#performance-comparison) for benchmarks.

---

## Related Documentation

- [macMLX Setup Guide](../setup/litellm-ollama.md#alternative-macmlx-apple-silicon)
- [API Usage Examples](../setup/litellm-ollama.md#using-the-macmlx-api)
- [LiteLLM Configuration](../setup/litellm-ollama.md#litellm-configuration-for-macmlx)

---

## Limitations

- ❌ **Inline code completion** — This setup provides Copilot Chat only, not inline suggestions
- ❌ **Context awareness** — Local models may not have the same context understanding as GitHub's Copilot
- ⚠️ **HTTPS required** — VS Code requires HTTPS for remote endpoints (use ngrok or Azure Relay for testing)
- ⚠️ **Experimental feature** — Custom endpoints may not be available in all Copilot plans
