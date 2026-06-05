# Security

## Baseline requirements

- Enforce HTTPS on the public endpoint.
- Require authentication on every public request.
- Keep local services bound to `127.0.0.1`.
- Do not expose Ollama directly to the Internet.
- Use least privilege identities and scoped secrets.

## Recommended controls

- API keys or token-based auth at Azure HTTPS proxy.
- Rate limiting and request body size limits.
- Allowlist trusted client origins/IPs where feasible.
- Structured logs with redaction of prompts, keys, and PII.
- Secret storage in Azure Key Vault or equivalent.
- Certificate lifecycle and TLS policy management.

## Operational hygiene

- Rotate credentials periodically.
- Audit relay and proxy access logs.
- Patch runtime dependencies and OS regularly.
- Track abuse and anomaly signals.

## Important warning

This repository is a starter foundation, not a complete production hardening guide.
