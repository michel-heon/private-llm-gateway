#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${PUBLIC_BASE_URL:-https://llm.example.com/v1}"
API_KEY="${PUBLIC_API_KEY:-YOUR_API_KEY}"
MODEL="${PUBLIC_MODEL:-gpt-4o-mini}"

echo "Checking public endpoint: ${BASE_URL}/chat/completions"
curl -sS "${BASE_URL}/chat/completions" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${MODEL}\",\"messages\":[{\"role\":\"user\",\"content\":\"Say hello\"}]}" | head -c 1000

echo
