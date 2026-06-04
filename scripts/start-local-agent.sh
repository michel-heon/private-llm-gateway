#!/usr/bin/env bash
set -euo pipefail

if [[ -f "config/local-agent.example.env" ]]; then
  # shellcheck disable=SC1091
  source config/local-agent.example.env
fi

echo "Starting local relay agent prototype..."
python3 local-agent/relay_agent.py
