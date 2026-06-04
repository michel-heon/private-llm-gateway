#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:-config/litellm.example.yaml}"

echo "Starting LiteLLM on 127.0.0.1:4000 using ${CONFIG_FILE}"
litellm --host 127.0.0.1 --port 4000 --config "${CONFIG_FILE}"
