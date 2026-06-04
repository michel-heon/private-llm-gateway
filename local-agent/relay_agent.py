#!/usr/bin/env python3
"""Prototype local relay agent for private-llm-gateway.

This is an initial skeleton. It is not production-ready.
"""

from __future__ import annotations

import json
import os
import urllib.error
import urllib.request


RELAY_CONNECTION_STRING = os.getenv("AZURE_RELAY_CONNECTION_STRING", "YOUR_AZURE_RELAY_CONNECTION_STRING")
HYBRID_CONNECTION_NAME = os.getenv("HYBRID_CONNECTION_NAME", "YOUR_HYBRID_CONNECTION_NAME")
LOCAL_LITELLM_URL = os.getenv("LOCAL_LITELLM_URL", "http://127.0.0.1:4000")
INTERNAL_SHARED_TOKEN = os.getenv("INTERNAL_SHARED_TOKEN", "YOUR_INTERNAL_SHARED_TOKEN")


class LocalRelayAgent:
    """Minimal prototype structure for a relay-backed local forwarding agent."""

    def connect_to_relay(self) -> None:
        if RELAY_CONNECTION_STRING.startswith("YOUR_"):
            raise RuntimeError("Set AZURE_RELAY_CONNECTION_STRING before starting the agent.")
        print(f"[TODO] Connect to Azure Relay Hybrid Connection: {HYBRID_CONNECTION_NAME}")

    def forward_to_litellm(self, method: str, path: str, body: bytes, headers: dict[str, str]) -> tuple[int, bytes, str]:
        target_url = f"{LOCAL_LITELLM_URL.rstrip('/')}/{path.lstrip('/')}"
        request = urllib.request.Request(url=target_url, data=body, method=method)
        for key, value in headers.items():
            request.add_header(key, value)

        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                return response.status, response.read(), response.headers.get("Content-Type", "application/json")
        except urllib.error.HTTPError as exc:
            return exc.code, exc.read(), exc.headers.get("Content-Type", "application/json")

    def run(self) -> None:
        self.connect_to_relay()
        print("[TODO] Start receiving HTTP requests from Azure Relay and proxy to LiteLLM.")
        print(json.dumps({
            "hybrid_connection": HYBRID_CONNECTION_NAME,
            "local_target": LOCAL_LITELLM_URL,
            "shared_token_configured": not INTERNAL_SHARED_TOKEN.startswith("YOUR_"),
        }))


if __name__ == "__main__":
    agent = LocalRelayAgent()
    agent.run()
