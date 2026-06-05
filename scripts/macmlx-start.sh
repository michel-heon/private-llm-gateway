#!/usr/bin/env bash
set -euo pipefail

# Source common functions (ADR-603: DRY principle)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

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

# Display resolved configuration
print_config_header "macMLX Configuration"
log_config "Model" "${MODEL}"
log_config "Port" "${PORT}"
log_config "Server" "http://127.0.0.1:${PORT}"
printf "\n"

# Dry-run mode: exit after showing config (ADR-603: DRY)
handle_dry_run

# Pre-flight checks (ADR-603: use common validation functions)
log_verbose "Checking system architecture..."
if ! is_apple_silicon; then
    ARCH=$(uname -m)
    log_error "macMLX requires Apple Silicon (arm64), detected: ${ARCH}"
    printf "  ${YELLOW}→ Use Ollama instead on this platform${NC}\n" >&2
    exit 1
fi
log_verbose "✓ Running on Apple Silicon ($(uname -m))"

# Check Python availability
log_verbose "Checking Python availability..."
require_command "python3" "Install Python: brew install python3"
PYTHON_VERSION=$(get_command_version "python3" "--version")
log_verbose "✓ Python found: ${PYTHON_VERSION}"

# Check mlx-lm installation
log_verbose "Checking mlx-lm installation..."
require_python_package "mlx_lm" "Install it: pip install mlx-lm"
MLX_VERSION=$(python3 -c "import mlx_lm; print(mlx_lm.__version__)" 2>/dev/null || echo "unknown")
log_verbose "✓ mlx-lm found: ${MLX_VERSION}"

# Check port availability
log_verbose "Checking if port ${PORT} is available..."
require_port_available "${PORT}"
log_verbose "✓ Port ${PORT} is available"

# All checks passed
log_success "Pre-flight checks passed"
printf "\n"

# Start macMLX server
log_info "Starting macMLX server..."
printf "  ${YELLOW}Press Ctrl+C to stop${NC}\n\n"

# Build command
CMD=(python3 -m mlx_lm.server --model "${MODEL}" --port "${PORT}")

if [[ "${VERBOSE}" == "true" ]]; then
    log_verbose "Command: ${CMD[*]}"
    printf "\n"
fi

# Execute mlx_lm.server
# Note: This runs in foreground, blocking the terminal
exec "${CMD[@]}"
