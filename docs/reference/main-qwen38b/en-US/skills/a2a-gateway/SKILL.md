---
name: a2a-gateway
description: "OCAO A2A gateway: JSON-RPC peer agents for complex cross-profile work after main-router chooses delegation."
---

# A2A Gateway

Keywords: OCAO, A2A, JSON-RPC, agent card, peer agent, multi-agent, routing, Chinese output.

User-facing output must always be Chinese.

## Route

Use only after `main-router` decides direct qwen3:8b execution is insufficient and peer/profile delegation is useful.

## Endpoints

- `GET /.well-known/agent.json`: discover remote agent card.
- `POST /a2a/v1`: JSON-RPC methods `message/send`, `tasks/get`, `tasks/cancel`.
- `GET /a2a/health`: health check.

## Config

```toml
[a2a]
enabled = true
bind = "127.0.0.1"
port = 18790
```

Default bind must be loopback. Public exposure needs auth, allowlist, and explicit approval.

## Tool

`a2a_send` params:
- `action`: `discover`, `send`, `get`, `cancel`.
- `url`: remote base URL.
- `message`: required for `send`.
- `task_id`: required for `get` or `cancel`.
- `context_id`: optional conversation continuity.
- `api_key`: optional bearer token.

## Safety

Avoid state fragmentation: record task id, context id, remote profile, and final result. Never send secrets or private memory to peers unless explicitly authorized.
