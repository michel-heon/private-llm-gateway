# Scripts Directory

This directory contains automation scripts for the private-llm-gateway project.

## 📋 Script Inventory

### Installation

| Script | Description | Platform | Status |
|--------|-------------|----------|--------|
| `install-mlx.sh` | Install mlx-lm in virtual environment (venv approach) | macOS ARM64 only | ✅ Active |

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

### Shared Library (ADR-603: DRY Principle)

| Script | Description | Platform | Status |
|--------|-------------|----------|--------|
| `common.sh` | Shared functions library (logging, validation, system checks) | Cross-platform | ✅ Active |

---

## 📚 common.sh — Shared Library (ADR-603)

The `common.sh` file implements the **DRY (Don't Repeat Yourself) principle** by centralizing reusable functions across all bash scripts.

### Sourcing in Your Scripts

```bash
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"
```

### Logging Functions (ADR-605)

```bash
log_info "Starting service..."        # ➤ Info with cyan arrow
log_success "Service started"         # ✓ Success with green checkmark
log_warning "Port already in use"     # ⚠ Warning with yellow sign
log_error "Failed to connect"         # ✘ Error with red X
log_verbose "Checking config..."      # [VERBOSE] if VERBOSE=true
log_config "Model" "Qwen2.5-7B"       # Formatted key-value pair
print_config_header "Configuration"   # Section header
```

### System Validation Functions

```bash
is_apple_silicon                                  # Returns 0 if arm64 architecture
is_port_available "8080"                          # Returns 0 if port is free
command_exists "python3"                          # Returns 0 if command exists
python_package_exists "mlx_lm" ["python_cmd"]    # Returns 0 if Python package installed (custom python optional)
```

### Health Check Functions

```bash
check_service_health "http://localhost:8080/health" [timeout]  # Returns 0 if service responds
is_process_running "mlx_lm.server"                             # Returns 0 if process active
get_process_pid "mlx_lm.server"                                # Returns PID or empty
```

### Error Handling Functions

```bash
die "Configuration file not found"                                        # Log error and exit 1
require_command "python3" "Install: brew install python3"                 # Require command or exit
require_port_available "8080"                                             # Require port free or exit
require_python_package "mlx_lm" "pip install mlx-lm" ["python_cmd"]      # Require Python package or exit (custom python optional)
```

### Utilities

```bash
handle_dry_run                              # Exit with warning if DRY_RUN=true
get_command_version "python3" "--version"   # Returns version or "unknown"
```

### Exported Variables (ADR-605)

The following ANSI color codes are available after sourcing:
- `RED`, `GREEN`, `YELLOW`, `BLUE`, `CYAN`, `BOLD`, `NC` (No Color)

### Usage Example

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

# Use shared functions
log_info "Initializing..."
require_command "curl" "Install: brew install curl"
require_port_available "8080"

log_success "Ready!"
```

---

## 🚀 Quick Reference

### macMLX (Apple Silicon)

```bash
# Install mlx-lm (first time only)
./scripts/install-mlx.sh

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
- Python 3 with `mlx-lm` package installed (see `install-mlx.sh`)

**Notes:**
- Virtual environment (`venv/`) is detected and used automatically if present
- Falls back to system Python if no venv found

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
