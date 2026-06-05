# Scripts Directory

Organisation des scripts pour le projet **private-llm-gateway**.

> **🎯 Guide Rapide:** Scripts **Mac** (bash `.sh`) vs Scripts **Windows** (PowerShell `.ps1`)
>
> **📖 Navigation:**
> - **[Utilisateurs Mac](#-sur-mac-macos-apple-silicon)** — Démarrage rapide
> - **[Utilisateurs Windows](#-sur-windows-via-powershell)** — Setup tunnel SSH
> - **[Architecture](#%EF%B8%8F-architecture)** — Comprendre le système
> - **[Troubleshooting](#%EF%B8%8F-troubleshooting)** — Résoudre les problèmes
> - **[Référence Technique](#-inventaire-complet-des-scripts)** — Détails des scripts et common.sh

---

## 📁 Structure

```
scripts/
├── README.md                              ← Ce fichier
│
├── 🍎 Scripts Mac (bash)
├── start-mac-server-with-tunnel-info.sh  ← Démarrer macMLX + afficher instructions Windows
├── macmlx-start.sh                        ← Démarrer le serveur macMLX
├── install-mlx.sh                         ← Installer les dépendances macMLX
├── common.sh                              ← Bibliothèque partagée (ADR-603)
├── start-ollama.sh                        ← Démarrer Ollama (alternative)
├── start-litellm.sh                       ← Démarrer LiteLM proxy
├── start-local-agent.sh                   ← Démarrer l'agent local Azure Relay
├── check-local-endpoint.sh                ← Tester l'endpoint local
└── check-public-endpoint.sh               ← Tester l'endpoint public
│
└── 🪟 Scripts Windows (PowerShell)
    └── windows/
        ├── README.md                      ← Documentation complète Windows
        ├── start-mac-tunnel.ps1           ← Créer tunnel SSH Windows → Mac
        └── test-mac-connection.ps1        ← Tester la connexion via tunnel
```

---

## 🎯 Quel Script Utiliser?

### 🍎 **Sur Mac (macOS, Apple Silicon)**

#### Démarrage Simple
```bash
make macmlx-start              # Juste démarrer le serveur
make macmlx-status             # Vérifier le statut
make macmlx-stop               # Arrêter le serveur
```

#### Démarrage avec Instructions Windows
```bash
make macmlx-start-with-info    # Démarrer + afficher les instructions pour Windows
# ou directement:
./scripts/start-mac-server-with-tunnel-info.sh
```

**Ce que fait `start-mac-server-with-tunnel-info.sh`:**
- ✅ Démarre le serveur macMLX sur le Mac
- ✅ Affiche les 3 modèles disponibles
- ✅ Affiche les instructions complètes pour Windows
- ✅ Montre l'IP du Mac pour SSH
- ✅ Montre les commandes de connexion

---

### 🪟 **Sur Windows (via PowerShell)**

> **Tous les scripts Windows sont dans `scripts/windows/`**

#### 1️⃣ Créer le Tunnel SSH
```powershell
cd scripts\windows
.\start-mac-tunnel.ps1
```

**Ce que fait `start-mac-tunnel.ps1`:**
- ✅ Détecte les conflits de port
- ✅ Crée un tunnel SSH Windows → Mac
- ✅ Forward le port 8080
- ✅ Configure keepalive (60 secondes)
- ✅ Garde le tunnel ouvert

**⚠️ Important:** Laissez cette fenêtre PowerShell ouverte!

#### 2️⃣ Tester la Connexion
```powershell
.\test-mac-connection.ps1
```

**Ce que fait `test-mac-connection.ps1`:**
- ✅ Vérifie la santé du serveur
- ✅ Liste les modèles disponibles
- ✅ Teste une completion
- ✅ Recommande le meilleur modèle

#### 📚 Documentation Complète Windows
Voir [scripts/windows/README.md](./windows/README.md) pour:
- Troubleshooting détaillé
- Configuration avancée (AutoSSH, Task Scheduler)
- Guide complet

---

## 🏗️ Architecture

### Scénario 1: Local Mac (pas de Windows)

```
┌─────────────────────────┐
│  Mac (Local)            │
│                         │
│  ┌─────────────────┐    │
│  │ macMLX Server   │    │
│  │ Port: 8080      │    │
│  └─────────────────┘    │
│          ↑              │
│          │              │
│  ┌─────────────────┐    │
│  │ VS Code Copilot │    │
│  │ localhost:8080  │    │
│  └─────────────────┘    │
└─────────────────────────┘
```

**Scripts utilisés:**
- `make macmlx-start` (Mac)
- Configuration VS Code locale

---

### Scénario 2: Windows → Mac via SSH Tunnel

```
┌─────────────────────────┐
│  Mac (192.168.7.116)    │
│                         │
│  ┌─────────────────┐    │
│  │ macMLX Server   │    │
│  │ Port: 8080      │    │
│  └─────────────────┘    │
│          ↑              │
│          │ localhost    │
│          ↓              │
│  ┌─────────────────┐    │
│  │ SSH Server      │    │
│  │ Port: 22        │    │
│  └─────────────────┘    │
└─────────────────────────┘
          ↑
          │ SSH Tunnel
          │ Port Forward: 8080 → 8080
          │
┌─────────────────────────┐
│  Windows 11             │
│                         │
│  ┌─────────────────┐    │
│  │ VS Code Copilot │    │
│  │ localhost:8080  │    │
│  └─────────────────┘    │
│          ↑              │
│          │              │
│  ┌─────────────────┐    │
│  │ SSH Client      │    │
│  │ Tunnel Actif    │    │
│  └─────────────────┘    │
└─────────────────────────┘
```

**Scripts utilisés:**
- `make macmlx-start-with-info` (Mac) — affiche instructions
- `start-mac-tunnel.ps1` (Windows) — crée tunnel
- `test-mac-connection.ps1` (Windows) — teste

---

## 🚀 Workflow Complet Windows → Mac

### Première Fois (Setup)

**1️⃣ Sur Mac:**
```bash
cd ~/path/to/private-llm-gateway
make install                    # Installer les dépendances
make macmlx-download MODEL=...  # Télécharger un modèle
make macmlx-start-with-info     # Démarrer + voir instructions
```

**2️⃣ Sur Windows:**
```powershell
# Cloner le repo
git clone https://github.com/michel-heon/private-llm-gateway.git
cd private-llm-gateway\scripts\windows

# Créer le tunnel
.\start-mac-tunnel.ps1         # ← Laisser ouvert!

# Dans un autre PowerShell:
.\test-mac-connection.ps1      # Tester
```

**3️⃣ Configurer VS Code (Windows):**
```json
// settings.json
{
  "github.copilot.advanced": {
    "endpoint": "http://localhost:8080/v1",
    "model": "mlx-community/Codestral-22B-v0.1-4bit"
  }
}
```

**4️⃣ Recharger VS Code:**
- `Ctrl + Shift + P` → `Developer: Reload Window`

---

### Usage Quotidien

**Sur Mac (une fois par jour):**
```bash
make macmlx-start              # Démarrer le serveur
```

**Sur Windows (chaque session de travail):**
```powershell
cd scripts\windows
.\start-mac-tunnel.ps1         # Créer le tunnel (garder ouvert)
```

> **💡 Astuce:** Configurez le tunnel pour démarrer automatiquement au boot Windows (voir [windows/README.md](./windows/README.md))

---

## 📊 Comparaison des Modèles

| Modèle | Taille RAM | Usage Recommandé | Performance |
|--------|-----------|------------------|-------------|
| **Qwen2.5-7B-Instruct-4bit** | 4 GB | Polyvalent (défaut) | ⭐⭐⭐⭐ |
| **Mistral-7B-Instruct-v0.3-4bit** | 3.8 GB | Conversationnel | ⭐⭐⭐ |
| **Codestral-22B-v0.1-4bit** | 12 GB | Production de code | ⭐⭐⭐⭐⭐ |

**Recommandation pour VS Code Copilot:** `Codestral-22B-v0.1-4bit`

---

## �️ Troubleshooting

### Mac

**Serveur ne démarre pas:**
```bash
make macmlx-status             # Vérifier le statut
pkill -f mlx_lm.server         # Tuer le processus
make macmlx-start              # Redémarrer
```

**Modèles manquants:**
```bash
make macmlx-download-status    # Vérifier les téléchargements
make macmlx-download MODEL=... # Télécharger un modèle
```

### Windows

**Tunnel ne se connecte pas:**
```powershell
# Tester SSH manuellement
ssh michelheon@192.168.7.116

# Vérifier les clés SSH
ls $env:USERPROFILE\.ssh\
```

**Port 8080 déjà utilisé:**
```powershell
# Voir ce qui utilise le port
Get-NetTCPConnection -LocalPort 8080

# Tuer le processus
Stop-Process -Id <PID> -Force
```

**Documentation complète:** [scripts/windows/README.md](./windows/README.md)

---

## 🎯 Quick Links

### Mac Users
```bash
make help                      # Voir toutes les commandes
make macmlx-start-with-info    # Démarrer avec instructions Windows
```

### Windows Users
```powershell
cd scripts\windows
Get-Content README.md          # Documentation complète
.\start-mac-tunnel.ps1         # Créer tunnel
.\test-mac-connection.ps1      # Tester
```

---

## 📚 Documentation Complète

- **Setup Windows → Mac:** [../docs/guides/integration/windows-ssh-quick-start.md](../docs/guides/integration/windows-ssh-quick-start.md)
- **VS Code BYOK:** [../docs/guides/integration/vscode-copilot-byok.md](../docs/guides/integration/vscode-copilot-byok.md)
- **Scripts Windows:** [windows/README.md](./windows/README.md)
- **README Principal:** [../README.md](../README.md)

---

## �📋 Inventaire Complet des Scripts

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

#### Via Makefile (Recommended)

```bash
# Install dependencies (first time only)
make install

# Download a specific model (pre-download for faster startup)
make macmlx-download MODEL=mlx-community/Codestral-22B-v0.1-4bit
make macmlx-download MODEL=mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit

# Check download progress (shows all models in cache)
make macmlx-download-status

# Start server with default model (Qwen2.5-7B-Instruct-4bit)
make macmlx-start

# Check server status and health
make macmlx-status

# Stop server
make macmlx-stop

# Show all available commands
make help
```

#### Direct Script Usage

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
