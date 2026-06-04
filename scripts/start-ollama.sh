#!/usr/bin/env bash
set -euo pipefail

echo "Starting Ollama (expected on 127.0.0.1:11434)..."
ollama serve
