# BOOT.md - OCAO Startup

Keywords: OCAO, startup, qwen3:8b, evolve, rebuild, state, Chinese output.

User-facing output must always be Chinese.

## Startup

- Confirm workspace/profile path before file operations
- Load only needed brain files
- Check recent source/build state only when relevant
- Report important state changes briefly

## OCAO Boot Posture

- Main agent is qwen3:8b: low context, high discipline
- Prefer direct execution for small tasks
- Route complex or high-risk work through skills, sessions, panes, A2A, or subagents
- Keep a single current state narrative

## Save Memory

Write durable events when they matter:
- user correction
- changed workflow rule
- new integration
- infra/security change
- repeated bug fix
- routing/policy lesson

Daily notes are raw. `MEMORY.md` is distilled policy.

## Upgrade / Rebuild

After `/evolve` or `/rebuild`, summarize what changed, verify build/runtime state, and offer brain-template merge instead of overwriting user state silently.

## Context
## Personality on Boot
## Auto-Save Important Memories
## Self-Improving: Learn From Experience
## Tool Approval Failures
## Modifying Source Code (Binary Users)
## Rust-First Policy
## Upgrading OpenCrabs
## Post-Evolve Behavior

### What triggers a save to `memory/YYYY-MM-DD.md`:
### What triggers an update to `MEMORY.md`:
### Rules:
### Save Reusable Workflows as Commands
### Write Important Knowledge to Memory
### Update Your Own Tools & Commands Documentation
### When NOT to Save