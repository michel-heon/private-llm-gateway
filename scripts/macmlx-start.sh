#!/usr/bin/env bash
set -euo pipefail

# Colors (ADR-605)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default values
DEFAULT_MODEL="mlx-community/Qwen2.5-7B-Instruct-4bit"
DEFAULT_PORT="8080"
VERBOSE=false
DRY_RUN=false

MODEL="${DEFAULT_MODEL}"
PORT="${DEFAULT_PORT}"

# Usage function (ADR-607)
_usage() {
    printf "${BOLD}macmlx-start.sh${NC} — Start macMLX inference server\n\n"
    printf "${BOLD}Usage:${NC}\n"
    printf "  macmlx-start.sh [-h] [-v] [-n] [-m <model>] [-p <port>]\n\n"
    printf "${BOLD}Options:${NC}\n"
    printf "  ${GREEN}-h, --help${NC}               Show this help and exit\n"
    printf "  ${GREEN}-v, --verbose${NC}            Enable verbose output\n"
    printf "  ${GREEN}-n, --dry-run${NC}            Show resolved configuration without executing\n"
    printf "  ${GREEN}-m, --model${NC} ${BOLD}<model>${NC}     MLX model to load (default: %s)\n" "${DEFAULT_MODEL}"
    printf "  ${GREEN}-p, --port${NC} ${BOLD}<port>${NC}       Server port (default: %s)\n\n" "${DEFAULT_PORT}"
    printf "${BOLD}Examples:${NC}\n"
    printf "  macmlx-start.sh\n"
    printf "  macmlx-start.sh --model mlx-community/Mistral-7B-v0.3-4bit --port 8080\n"
    printf "  macmlx-start.sh -m mlx-community/Meta-Llama-3-8B-Instruct-4bit -p 9000\n"
    printf "  macmlx-start.sh --dry-run\n\n"
    printf "${BOLD}Requirements:${NC}\n"
    printf "  - Apple Silicon Mac (M1/M2/M3/M4)\n"
    printf "  - Python virtual environment activated\n"
    printf "  - mlx-lm package installed (pip install mlx-lm)\n\n"
}

# Parse options (ADR-607)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            _usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        -n|--dry-run)
            DRY_RUN=true
            ;;
        -m|--model)
            if [[ $# -lt 2 ]]; then
                printf "${RED}✘ %s requires an argument${NC}\n" "$1" >&2
                _usage >&2
                exit 1
            fi
            MODEL="$2"
            shift
            ;;
        -p|--port)
            if [[ $# -lt 2 ]]; then
                printf "${RED}✘ %s requires an argument${NC}\n" "$1" >&2
                _usage >&2
                exit 1
            fi
            PORT="$2"
            shift
            ;;
        --)
            shift
            break
            ;;
        -*)
            printf "${RED}✘ Unknown option: %s${NC}\n" "$1" >&2
            _usage >&2
            exit 1
            ;;
        *)
            printf "${RED}✘ Unexpected positional argument: %s${NC}\n" "$1" >&2
            _usage >&2
            exit 1
            ;;
    esac
    shift
done

# Verbose logging helper
_log_verbose() {
    if [[ "${VERBOSE}" == "true" ]]; then
        printf "${CYAN}[VERBOSE]${NC} %s\n" "$1"
    fi
}

# Display resolved configuration
printf "${CYAN}➤ macMLX Configuration${NC}\n"
printf "  Model:  ${BOLD}%s${NC}\n" "${MODEL}"
printf "  Port:   ${BOLD}%s${NC}\n" "${PORT}"
printf "  Server: ${BOLD}http://127.0.0.1:%s${NC}\n\n" "${PORT}"

# Dry-run mode: exit after showing config
if [[ "${DRY_RUN}" == "true" ]]; then
    printf "${YELLOW}⚠ Dry-run mode — configuration shown, not starting server${NC}\n"
    exit 0
fi

# Check 1: Verify we're on Apple Silicon
_log_verbose "Checking system architecture..."
ARCH=$(uname -m)
if [[ "${ARCH}" != "arm64" ]]; then
    printf "${RED}✘ macMLX requires Apple Silicon (arm64), detected: %s${NC}\n" "${ARCH}" >&2
    printf "  ${YELLOW}→ Use Ollama instead on this platform${NC}\n" >&2
    exit 1
fi
_log_verbose "✓ Running on Apple Silicon (${ARCH})"

# Check 2: Verify Python is available
_log_verbose "Checking Python availability..."
if ! command -v python3 &>/dev/null; then
    printf "${RED}✘ Python 3 is not installed or not in PATH${NC}\n" >&2
    printf "  ${YELLOW}→ Install Python: brew install python3${NC}\n" >&2
    exit 1
fi
PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
_log_verbose "✓ Python found: ${PYTHON_VERSION}"

# Check 3: Verify mlx-lm is installed
_log_verbose "Checking mlx-lm installation..."
if ! python3 -c "import mlx_lm" 2>/dev/null; then
    printf "${RED}✘ mlx-lm package is not installed${NC}\n" >&2
    printf "  ${YELLOW}→ Install it: pip install mlx-lm${NC}\n" >&2
    printf "  ${YELLOW}→ Or activate your virtual environment:${NC}\n" >&2
    printf "     source venv/bin/activate\n" >&2
    exit 1
fi
MLX_VERSION=$(python3 -c "import mlx_lm; print(mlx_lm.__version__)" 2>/dev/null || echo "unknown")
_log_verbose "✓ mlx-lm found: ${MLX_VERSION}"

# Check 4: Verify port is available
_log_verbose "Checking if port ${PORT} is available..."
if lsof -Pi ":${PORT}" -sTCP:LISTEN -t &>/dev/null; then
    printf "${RED}✘ Port %s is already in use${NC}\n" "${PORT}" >&2
    printf "  ${YELLOW}→ Running processes:${NC}\n" >&2
    lsof -Pi ":${PORT}" -sTCP:LISTEN | head -2 >&2
    printf "  ${YELLOW}→ Choose a different port with --port${NC}\n" >&2
    exit 1
fi
_log_verbose "✓ Port ${PORT} is available"

# All checks passed
printf "${GREEN}✓ Pre-flight checks passed${NC}\n\n"

# Start macMLX server
printf "${CYAN}➤ Starting macMLX server...${NC}\n"
printf "  ${YELLOW}Press Ctrl+C to stop${NC}\n\n"

# Build command
CMD=(python3 -m mlx_lm.server --model "${MODEL}" --port "${PORT}")

if [[ "${VERBOSE}" == "true" ]]; then
    printf "${CYAN}[VERBOSE]${NC} Command: %s\n\n" "${CMD[*]}"
fi

# Execute mlx_lm.server
# Note: This runs in foreground, blocking the terminal
exec "${CMD[@]}"
