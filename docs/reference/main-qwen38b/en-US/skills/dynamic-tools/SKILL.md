---
name: dynamic-tools
description: "OCAO runtime tool management with tool_manage and tools.toml for narrow reusable integrations."
---

# Dynamic Tools

Keywords: OCAO, tool_manage, tools.toml, runtime tools, HTTP tool, shell tool, Chinese output.

User-facing output must always be Chinese.

## Route

Use when OCAO needs a narrow reusable callable integration. Slash shortcuts belong in commands; multi-step workflows belong in skills; agent-callable integrations belong here.

## Actions

`tool_manage`:
- `list`: show tools.
- `add`: create tool.
- `remove`: delete tool.
- `enable` / `disable`: toggle.
- `reload`: reload `tools.toml`.

## Executors

- `http`: method, url, headers, params/body.
- `shell`: command and params.

## Storage

Tools persist in `~/.opencrabs/tools.toml` and load into the runtime tool registry.

## Safety

Name and describe tools clearly so the 8B router can select them. Use least privilege. Shell tools and external write actions need approval when risky. Never create tools that expose secrets or broad filesystem/network power without a clear need.
