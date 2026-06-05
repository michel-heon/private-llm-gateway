# VS Code and Copilot BYOK / Custom Endpoint

## Intended integration scope

This project targets **Copilot Chat / VS Code BYOK / Custom Endpoint** scenarios where supported.

It does **not** claim to replace or provide GitHub Copilot inline completions.

## Typical endpoint shape

- Base URL: `https://llm.example.com/v1`
- Auth: bearer token or API key required by your Azure HTTPS proxy
- API style: OpenAI-compatible requests/responses via LiteLLM

## Setup reminders

- Confirm feature support in your VS Code / Copilot plan.
- Configure model names that exist in your LiteLLM mapping.
- Validate request and response formats using local checks first.

## TODOs

- TODO: Document exact client settings for your VS Code/Copilot version.
