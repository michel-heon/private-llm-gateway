#!/usr/bin/env bash
set -euo pipefail

# Source common functions (ADR-603: DRY principle)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

VENV_DIR="venv"

# Check if we're on Apple Silicon (requirement for mlx-lm)
log_info "Checking system requirements..."
if ! is_apple_silicon; then
    ARCH=$(uname -m)
    log_error "mlx-lm requires Apple Silicon (arm64), detected: ${ARCH}"
    printf "  ${YELLOW}→ Use Ollama instead on this platform${NC}\n" >&2
    exit 1
fi
log_success "Running on Apple Silicon ($(uname -m))"

# Check Python version
require_command "python3" "Install Python: brew install python3"
PYTHON_VERSION=$(get_command_version "python3" "--version")
log_info "Python version: ${PYTHON_VERSION}"

# Create virtual environment if it doesn't exist
if [[ -d "${VENV_DIR}" ]]; then
    log_info "Virtual environment already exists at ${VENV_DIR}/"
else
    log_info "Creating virtual environment at ${VENV_DIR}/"
    python3 -m venv "${VENV_DIR}"
    log_success "Virtual environment created"
fi

# Activate virtual environment and install mlx-lm
log_info "Installing mlx-lm package..."
printf "  ${CYAN}This may take a few minutes on first install...${NC}\n\n"

# Note: We need to activate the venv and run pip in the same subshell
if "${VENV_DIR}/bin/pip" install --upgrade pip >/dev/null 2>&1 && \
   "${VENV_DIR}/bin/pip" install mlx-lm; then
    log_success "mlx-lm installed successfully"
else
    log_error "Failed to install mlx-lm"
    exit 1
fi

# Verify installation
log_info "Verifying installation..."
if "${VENV_DIR}/bin/python3" -c "import mlx_lm; print('mlx-lm version:', mlx_lm.__version__)" 2>/dev/null; then
    log_success "Installation verified"
else
    log_error "Installation verification failed"
    exit 1
fi

printf "\n"
print_config_header "Next Steps"
printf "  ${GREEN}1.${NC} Activate the virtual environment:\n"
printf "     ${CYAN}source ${VENV_DIR}/bin/activate${NC}\n\n"
printf "  ${GREEN}2.${NC} Start macMLX server:\n"
printf "     ${CYAN}make macmlx-start${NC}\n\n"
printf "  ${GREEN}3.${NC} Or use the virtual environment directly:\n"
printf "     ${CYAN}./scripts/macmlx-start.sh${NC}\n\n"
