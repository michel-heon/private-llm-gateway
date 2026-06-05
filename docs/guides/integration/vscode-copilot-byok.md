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

### Step 1: Install and Download Model

```bash
# Install dependencies (one-time setup)
make install

# Pre-download a coding-optimized model (recommended, much faster than on-demand)
make macmlx-download MODEL=mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit

# Or use default model (Qwen2.5-7B - general purpose)
make macmlx-start

# Verify it's running
make macmlx-status
curl http://127.0.0.1:8080/v1/models
```

**Model Download Tips:**
- Pre-downloading saves 5-30 minutes on first startup
- Download runs in background (multi-threaded)
- Models are cached in `~/.cache/huggingface/hub/`
- See [recommended coding models](#coding-models-recommended) below

### Step 2: Configure VS Code Settings

#### Option A: Via Settings UI (Recommended for beginners)

1. **Open VS Code Settings**
   - **macOS:** `Cmd + ,` (virgule) ou `Code → Settings... → Settings`
   - **Windows/Linux:** `Ctrl + ,` ou `File → Preferences → Settings`

2. **Search for Copilot settings**
   - Dans la barre de recherche en haut, tapez: `copilot advanced`
   - Vous verrez apparaître des options Copilot

3. **⚠️ Note importante**  
   La configuration custom endpoint n'est **pas toujours disponible dans l'UI**. Si vous ne voyez pas l'option "GitHub > Copilot: Advanced", passez à l'**Option B (JSON)** ci-dessous.

#### Option B: Via Settings JSON (Méthode universelle)

1. **Ouvrir le fichier settings.json**
   
   **Méthode 1 - Raccourci clavier:**
   - **macOS:** `Cmd + Shift + P` → Tapez "Preferences: Open User Settings (JSON)"
   - **Windows/Linux:** `Ctrl + Shift + P` → Tapez "Preferences: Open User Settings (JSON)"
   - Appuyez sur `Entrée`

   **Méthode 2 - Via l'interface:**
   - Ouvrez les Settings (`Cmd + ,` ou `Ctrl + ,`)
   - Cliquez sur l'icône 📄 **"Open Settings (JSON)"** en haut à droite de l'onglet Settings
   - (L'icône ressemble à un document avec une flèche)

2. **Ajouter la configuration**

   Le fichier `settings.json` s'ouvre. Vous verrez du contenu existant comme:
   ```json
   {
     "editor.fontSize": 14,
     "workbench.colorTheme": "Dark+",
     ...
   }
   ```

   **Ajoutez la configuration Copilot** AVANT la dernière accolade fermante `}`:

   ```json
   {
     "editor.fontSize": 14,
     "workbench.colorTheme": "Dark+",
     
     "github.copilot.advanced": {
       "endpoint": "http://127.0.0.1:8080/v1",
       "model": "mlx-community/Qwen2.5-7B-Instruct-4bit"
     }
   }
   ```

   ⚠️ **Important:**
   - Ajoutez une **virgule** après la ligne précédente si nécessaire
   - Respectez l'indentation (2 espaces)
   - VS Code affiche des erreurs de syntaxe en rouge si mal formaté

3. **Sauvegarder**
   - **macOS:** `Cmd + S`
   - **Windows/Linux:** `Ctrl + S`
   - Le fichier se sauvegarde automatiquement après quelques secondes

4. **Vérifier la configuration**
   - Aucune erreur rouge ne doit apparaître dans le fichier
   - Si erreur: vérifiez les virgules, accolades, guillemets

#### Exemples de configuration complète

**Configuration minimale (macMLX direct):**
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:8080/v1",
    "model": "mlx-community/Qwen2.5-7B-Instruct-4bit"
  }
}
```

**Configuration avec model coding spécialisé:**
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:8080/v1",
    "model": "mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit"
  }
}
```

**Alternative: Using LiteLLM Proxy (si vous utilisez le proxy):**
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:4000/v1",
    "model": "qwen2.5-mlx"
  }
}
```

#### Où se trouve le fichier settings.json?

Si vous voulez l'éditer directement dans un éditeur de texte:
- **macOS:** `~/Library/Application Support/Code/User/settings.json`
- **Linux:** `~/.config/Code/User/settings.json`
- **Windows:** `%APPDATA%\Code\User\settings.json`

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

### Coding Models (Recommended)

For **code generation with minimal hallucinations**, use these specialized models:

| Model | Size | RAM | Speed | Code Quality | Best For |
|-------|------|-----|-------|--------------|----------|
| **DeepSeek-Coder-V2.5-7B** | 7B | ~4GB | Fast | ⭐⭐⭐⭐⭐ | Code, debug, refactoring |
| **Qwen2.5-Coder-7B** | 7B | ~4GB | Fast | ⭐⭐⭐⭐⭐ | Code reviews, best practices |
| **Qwen2.5-Coder-14B** | 14B | ~8GB | Medium | ⭐⭐⭐⭐⭐ | Complex code, architecture |
| **Codestral-22B** | 22B | ~14GB | Slow | ⭐⭐⭐⭐⭐ | Production code (M2 Max/M3+) |
| Qwen2.5-7B (default) | 7B | ~4GB | Fast | ⭐⭐⭐⭐ | General purpose |

**Download and use a coding model:**
```bash
# Pre-download (recommended)
make macmlx-download MODEL=mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit

# Start with coding model
./scripts/macmlx-start.sh --model mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit
```

**VS Code configuration:**
```json
{
  "github.copilot.advanced": {
    "endpoint": "http://127.0.0.1:8080/v1",
    "model": "mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit"
  }
}
```

### macMLX (Local - Port 8080)

Check available models:
```bash
curl http://127.0.0.1:8080/v1/models | python3 -m json.tool
```

Browse all models at [Hugging Face MLX Community](https://huggingface.co/mlx-community)

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
- **Pre-download models:** `make macmlx-download MODEL=...` (eliminates first-load delay)
- Use 4-bit quantized models (smaller, faster)
- Close other applications to free RAM
- Choose smaller models: 7B for speed, 14B/22B for quality
- Lower temperature in VS Code settings: `"temperature": 0.1` (reduces hallucinations)

---

## Performance Tips

### Model Selection by Hardware

**M1/M2 (8-16GB RAM):**
```bash
make macmlx-download MODEL=mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit
```
✅ Best balance: performance + quality

**M2 Pro/Max or M3 (32GB+ RAM):**
```bash
make macmlx-download MODEL=mlx-community/Qwen2.5-Coder-14B-Instruct-4bit
```
✅ Maximum code quality

**Mac Studio/M2 Max+ (64GB+ RAM):**
```bash
make macmlx-download MODEL=mlx-community/Codestral-22B-v0.1-4bit
```
✅ Production-grade code generation

### Model Size Reference

| Model Type | Size | RAM Required | Speed | Code Quality |
|------------|------|--------------|-------|-------------|
| 3B (4-bit) | ~2GB | ~2GB | Very Fast | Good |
| 7B (4-bit) | ~4GB | ~4GB | Fast | Excellent |
| 14B (4-bit) | ~8GB | ~8GB | Medium | Outstanding |
| 22B (4-bit) | ~13GB | ~14GB | Slow | Premium |

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
