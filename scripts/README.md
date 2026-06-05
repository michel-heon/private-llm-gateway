# Scripts Directory

This directory contains automation scripts for the private-llm-gateway project.

## 📋 Script Inventory

### Model Serving

| Script | Description | Platform | Status |
|--------|-------------|----------|--------|
| `start-ollama.sh` | Start Ollama local model server | Cross-platform | ✅ Active |
| `macmlx-start.sh` | Start macMLX inference server (Apple Silicon optimized) | macOS ARM64 only | ✅ Active |
| `start-litellm.sh` | Start LiteLLM OpenAI-compatible gateway | Cross-platform | ✅ Active |

### Local Agent

| Script | Description | Platform | Status |
|--------|-------------|----------|--------|
| `start-local-agent.sh` | Start local relay agent (Azure Hybrid Connection) | Cross-platform | ✅ Active |

### Health Checks

| Script | Description | Platform | Status |
|--------|-------------|----------|--------|
| `check-local-endpoint.sh` | Verify local endpoint availability | Cross-platform | ✅ Active |
| `check-public-endpoint.sh` | Verify public endpoint via Azure Relay | Cross-platform | ✅ Active |

---

## 🚀 Quick Reference

### macMLX (Apple Silicon)

```bash
# Start with defaults (Qwen2.5-7B-Instruct-4bit on port 8080)
./scripts/macmlx-start.sh

# Custom model and port
./scripts/macmlx-start.sh --model mlx-community/Mistral-7B-v0.3-4bit --port 9000

# Verbose output
./scripts/macmlx-start.sh --verbose

# Dry-run (show config without starting)
./scripts/macmlx-start.sh --dry-run

# Help
./scripts/macmlx-start.sh --help
```

**Requirements:**
- Apple Silicon Mac (M1/M2/M3/M4)
- Python 3 with `mlx-lm` package installed
- Virtual environment activated (recommended)

### Ollama

```bash
# Start Ollama server
./scripts/start-ollama.sh
```

**Default endpoint:** `http://127.0.0.1:11434`

### LiteLLM

```bash
# Start with default config
./scripts/start-litellm.sh

# Start with custom config
./scripts/start-litellm.sh config/litellm.custom.yaml
```

**Default endpoint:** `http://127.0.0.1:4000`

---

## 🏗️ Architecture & Conventions

### Naming Convention (ADR-601)

All scripts follow the `{object}-{action}.sh` pattern:
- `macmlx-start.sh` ✅
- `ollama-start.sh` (to be renamed from `start-ollama.sh`)
- `litellm-start.sh` (to be renamed from `start-litellm.sh`)

### Options Handling (ADR-607)

Scripts implement standardized option parsing:

| Short | Long | Behavior |
|-------|------|----------|
| `-h` | `--help` | Show help and exit |
| `-v` | `--verbose` | Enable verbose output |
| `-n` | `--dry-run` | Show resolved config without executing |

**Example:**
```bash
./scripts/macmlx-start.sh --help
./scripts/macmlx-start.sh --dry-run
./scripts/macmlx-start.sh -v -m mlx-community/Phi-3-mini-4k-instruct
```

### Color Output (ADR-605)

Scripts use ANSI color codes with `printf` (not `echo`):
- 🔵 **Cyan**: Actions/progress (`➤`)
- 🟢 **Green**: Success (`✓`)
- 🟡 **Yellow**: Warnings (`⚠`)
- 🔴 **Red**: Errors (`✘`)

---

## 🧪 Testing

Run syntax validation:
```bash
make check
```

This validates:
- Bash syntax for all `.sh` scripts
- Python syntax for `relay_agent.py`

---

## 📚 Related Documentation

- [ADR-601: Script Naming Convention](../docs/adr/601-DEVOPS-nomenclature-scripts.md)
- [ADR-605: Color Management in Scripts](../docs/adr/605-DEVOPS-gestion-couleurs-scripts-make.md)
- [ADR-607: Option Parsing in Bash](../docs/adr/607-DEVOPS-gestion-options-scripts-bash.md)
- [macMLX Setup Guide](../docs/litellm-ollama.md#alternative-macmlx-apple-silicon)
