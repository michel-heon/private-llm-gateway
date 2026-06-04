#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${LOCAL_BASE_URL:-http://127.0.0.1:4000/v1}"
API_KEY="${LOCAL_API_KEY:-YOUR_API_KEY}"
MODEL="${LOCAL_MODEL:-gpt-4o-mini}"

echo "Checking local endpoint: ${BASE_URL}/chat/completions"
curl -sS "${BASE_URL}/chat/completions" \
  -H "X-API-Key: ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${MODEL}\",\"messages\":[{\"role\":\"user\",\"content\":\"Say hello\"}]}" | head -c 1000

echo
