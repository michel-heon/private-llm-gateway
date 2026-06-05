SHELL := /bin/bash

# Colors (ADR-605)
# Note: Colors defined here for Makefile targets. Scripts use scripts/common.sh (ADR-603)
RED    := \033[0;31m
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
CYAN   := \033[0;36m
BOLD   := \033[1m
NC     := \033[0m

# Variables
DEFAULT_MACMLX_MODEL := mlx-community/Qwen2.5-7B-Instruct-4bit
DEFAULT_MACMLX_PORT  := 8080

.PHONY: help check start-local test-local test-public \
        install macmlx-download macmlx-start macmlx-stop macmlx-status

##@ Help

help: ## Show this help
	@printf "$(BLUE)═══════════════════════════════════════════════════$(NC)\n"
	@printf "$(GREEN)  private-llm-gateway — LLM Gateway Management      $(NC)\n"
	@printf "$(BLUE)═══════════════════════════════════════════════════$(NC)\n\n"
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make $(CYAN)<target>$(NC)\n\n"} \
	     /^##@/ { printf "\n$(BOLD)%s$(NC)\n", substr($$0, 5) } \
	     /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf "\n"

##@ Validation

check: ## Check syntax of scripts and Python files
	@bash -n scripts/*.sh
	@python3 -m py_compile local-agent/relay_agent.py
	@printf "$(GREEN)✓ Syntax check passed$(NC)\n"

##@ Local Services (Ollama)

start-local: ## Start Ollama
	@./scripts/start-ollama.sh

##@ Local Services (macMLX - Apple Silicon)

install: ## Install macMLX dependencies in virtual environment (Apple Silicon only)
	@./scripts/install-mlx.sh

macmlx-download: ## Download a macMLX model (Usage: make macmlx-download MODEL=mlx-community/Codestral-22B-v0.1-4bit)
	@printf "$(CYAN)➤ Downloading macMLX model...$(NC)\n"
	@if [ -z "$(MODEL)" ]; then \
		printf "$(RED)✘ Error: MODEL variable is required$(NC)\n"; \
		printf "  $(YELLOW)Example: make macmlx-download MODEL=mlx-community/Codestral-22B-v0.1-4bit$(NC)\n"; \
		printf "\n$(CYAN)Popular coding models:$(NC)\n"; \
		printf "  • mlx-community/DeepSeek-Coder-V2.5-7B-Instruct-4bit   $(YELLOW)(Best for code)$(NC)\n"; \
		printf "  • mlx-community/Qwen2.5-Coder-7B-Instruct-4bit          $(YELLOW)(Excellent)$(NC)\n"; \
		printf "  • mlx-community/Codestral-22B-v0.1-4bit                 $(YELLOW)(Premium - 14GB RAM)$(NC)\n"; \
		printf "  • mlx-community/Qwen2.5-7B-Instruct-4bit                $(YELLOW)(Default - General)$(NC)\n"; \
		exit 1; \
	fi
	@printf "  Model: $(BOLD)$(MODEL)$(NC)\n"
	@source venv/bin/activate && \
		pip show huggingface_hub >/dev/null 2>&1 || pip install -q huggingface_hub[cli] && \
		huggingface-cli download "$(MODEL)" --repo-type model && \
		printf "\n$(GREEN)✓ Model downloaded successfully$(NC)\n" && \
		printf "  $(CYAN)→ Start server: ./scripts/macmlx-start.sh --model $(MODEL)$(NC)\n"

macmlx-start: ## Start macMLX server (default: Qwen2.5-7B-Instruct-4bit on port 8080)
	@printf "$(CYAN)➤ Starting macMLX server...$(NC)\n"
	@./scripts/macmlx-start.sh

macmlx-stop: ## Stop macMLX server
	@printf "$(CYAN)➤ Stopping macMLX server...$(NC)\n"
	@pkill -f "mlx_lm.server" && printf "$(GREEN)✓ macMLX stopped$(NC)\n" || printf "$(YELLOW)⚠ No macMLX process found$(NC)\n"

macmlx-status: ## Check macMLX server health
	@printf "$(CYAN)➤ Checking macMLX server status...$(NC)\n"
	@if pgrep -f "mlx_lm.server" > /dev/null; then \
		printf "$(GREEN)✓ macMLX is running$(NC)\n"; \
		printf "  PID: $$(pgrep -f mlx_lm.server)\n"; \
		printf "  Endpoint: $(BOLD)http://127.0.0.1:$(DEFAULT_MACMLX_PORT)$(NC)\n"; \
		printf "\n$(CYAN)Testing endpoint...$(NC)\n"; \
		curl -s http://127.0.0.1:$(DEFAULT_MACMLX_PORT)/health 2>/dev/null && printf "$(GREEN)✓ Health check passed$(NC)\n" || printf "$(YELLOW)⚠ Health endpoint not responding$(NC)\n"; \
	else \
		printf "$(RED)✘ macMLX is not running$(NC)\n"; \
		printf "  $(YELLOW)→ Start with: make macmlx-start$(NC)\n"; \
	fi

##@ Tests

test-local: ## Test local endpoint
	@./scripts/check-local-endpoint.sh

test-public: ## Test public endpoint
	@./scripts/check-public-endpoint.sh
