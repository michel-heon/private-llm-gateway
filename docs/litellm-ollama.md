# LiteLLM + Ollama

## Local serving model

- Ollama provides local model runtime (`127.0.0.1:11434`)
- LiteLLM provides OpenAI-compatible API (`127.0.0.1:4000`)

## Benefits

- Keeps local model provider swappable
- Allows client compatibility with OpenAI-style APIs

## Example model mapping

Use `config/litellm.example.yaml` to map exposed model IDs to Ollama models.

## TODOs

- TODO: Pick model names and context settings suitable for your machine.
