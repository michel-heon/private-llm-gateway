#!/usr/bin/env bash
# Common functions for all scripts in Private LLM Gateway
# ADR-603: DRY principle - single source of truth for shared functionality
# ADR-605: Color management with printf

# Source guard: prevent multiple sourcing
[[ -n "${_COMMON_SH_SOURCED:-}" ]] && return 0
readonly _COMMON_SH_SOURCED=1

# ============================================================================
# ANSI Color Definitions (ADR-605)
# ============================================================================
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# ============================================================================
# Logging Functions (ADR-605)
# ============================================================================

# Print info message with cyan arrow
# Usage: log_info "Starting service..."
log_info() {
    printf "${CYAN}➤ %s${NC}\n" "$*" >&2
}

# Print success message with green checkmark
# Usage: log_success "Service started successfully"
log_success() {
    printf "${GREEN}✓ %s${NC}\n" "$*" >&2
}

# Print warning message with yellow warning sign
# Usage: log_warning "Port already in use"
log_warning() {
    printf "${YELLOW}⚠ %s${NC}\n" "$*" >&2
}

# Print error message with red X
# Usage: log_error "Failed to connect"
log_error() {
    printf "${RED}✘ %s${NC}\n" "$*" >&2
}

# Print verbose message (only if VERBOSE=true)
# Usage: log_verbose "Checking configuration..."
log_verbose() {
    if [[ "${VERBOSE:-false}" == "true" ]]; then
        printf "${CYAN}[VERBOSE]${NC} %s\n" "$*" >&2
    fi
}

# Print configuration key-value pair
# Usage: log_config "Model" "Qwen2.5-7B-Instruct-4bit"
log_config() {
    local key="$1"
    local value="$2"
    printf "  %-8s ${BOLD}%s${NC}\n" "${key}:" "${value}" >&2
}

# ============================================================================
# System Checks
# ============================================================================

# Check if running on Apple Silicon (arm64)
# Returns: 0 if Apple Silicon, 1 otherwise
is_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]]
}

# Check if port is available
# Args: $1 = port number
# Returns: 0 if available, 1 if occupied
is_port_available() {
    local port="$1"
    ! lsof -Pi ":${port}" -sTCP:LISTEN -t &>/dev/null
}

# Check if command exists
# Args: $1 = command name
# Returns: 0 if exists, 1 otherwise
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if Python package is installed
# Args: $1 = package name
# Returns: 0 if installed, 1 otherwise
python_package_exists() {
    local package="$1"
    python3 -c "import ${package}" 2>/dev/null
}

# ============================================================================
# Service Health Checks
# ============================================================================

# Check if service is responding at URL
# Args: $1 = URL, $2 = timeout (optional, default: 5)
# Returns: 0 if healthy, 1 otherwise
check_service_health() {
    local url="$1"
    local timeout="${2:-5}"
    curl --silent --fail --max-time "${timeout}" "${url}" >/dev/null 2>&1
}

# Check if process is running by name pattern
# Args: $1 = process name pattern
# Returns: 0 if running, 1 otherwise
is_process_running() {
    local pattern="$1"
    pgrep -f "${pattern}" >/dev/null 2>&1
}

# Get PID of process by name pattern
# Args: $1 = process name pattern
# Returns: PID if found, empty otherwise
get_process_pid() {
    local pattern="$1"
    pgrep -f "${pattern}" 2>/dev/null | head -1
}

# ============================================================================
# Error Handling
# ============================================================================

# Exit with error message
# Usage: die "Configuration file not found"
die() {
    log_error "$*"
    exit 1
}

# Require command to be available
# Usage: require_command "python3" "Install Python 3: brew install python3"
require_command() {
    local cmd="$1"
    local hint="${2:-}"
    
    if ! command_exists "${cmd}"; then
        log_error "${cmd} is not installed or not in PATH"
        [[ -n "${hint}" ]] && printf "  ${YELLOW}→ %s${NC}\n" "${hint}" >&2
        exit 1
    fi
}

# Require port to be available
# Usage: require_port_available "8080"
require_port_available() {
    local port="$1"
    
    if ! is_port_available "${port}"; then
        log_error "Port ${port} is already in use"
        printf "  ${YELLOW}→ Running processes:${NC}\n" >&2
        lsof -Pi ":${port}" -sTCP:LISTEN | head -2 >&2
        printf "  ${YELLOW}→ Choose a different port with --port${NC}\n" >&2
        exit 1
    fi
}

# Require Python package to be installed
# Usage: require_python_package "mlx_lm" "pip install mlx-lm"
require_python_package() {
    local package="$1"
    local hint="${2:-}"
    
    if ! python_package_exists "${package}"; then
        log_error "${package} package is not installed"
        [[ -n "${hint}" ]] && printf "  ${YELLOW}→ %s${NC}\n" "${hint}" >&2
        printf "  ${YELLOW}→ Or activate your virtual environment:${NC}\n" >&2
        printf "     source venv/bin/activate\n" >&2
        exit 1
    fi
}

# ============================================================================
# Configuration Display
# ============================================================================

# Print configuration section header
# Usage: print_config_header "macMLX Configuration"
print_config_header() {
    printf "${CYAN}➤ %s${NC}\n" "$*" >&2
}

# Print dry-run warning and exit
# Usage: handle_dry_run (automatically checks DRY_RUN variable)
handle_dry_run() {
    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        log_warning "Dry-run mode — configuration shown, not starting"
        exit 0
    fi
}

# ============================================================================
# Version Info
# ============================================================================

# Get version of a command
# Args: $1 = command, $2 = version flag (optional, default: --version)
# Returns: version string or "unknown"
get_command_version() {
    local cmd="$1"
    local flag="${2:---version}"
    
    if command_exists "${cmd}"; then
        "${cmd}" "${flag}" 2>&1 | head -1 | cut -d' ' -f2-
    else
        echo "unknown"
    fi
}
