SHELL := /bin/bash

check:
	bash -n scripts/*.sh
	python3 -m py_compile local-agent/relay_agent.py

start-local:
	./scripts/start-ollama.sh

test-local:
	./scripts/check-local-endpoint.sh

test-public:
	./scripts/check-public-endpoint.sh
