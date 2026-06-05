# Azure Relay Hybrid Connection

## Role in this architecture

Azure Relay Hybrid Connection is the private bridge from Azure HTTPS proxy to the local macOS relay agent.

It is **not** the Internet-facing API endpoint.

## Responsibilities

- Broker connectivity between Azure-hosted proxy and local network agent
- Avoid direct inbound port exposure on macOS host

## Configuration placeholders

- `YOUR_AZURE_RELAY_CONNECTION_STRING`
- `YOUR_HYBRID_CONNECTION_NAME`
- `YOUR_AZURE_RESOURCE_GROUP`

## TODOs

- TODO: Provision relay namespace and hybrid connection.
- TODO: Restrict rights and rotate relay keys.
