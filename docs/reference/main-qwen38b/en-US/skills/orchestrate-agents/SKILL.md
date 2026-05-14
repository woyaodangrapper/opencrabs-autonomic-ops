---
name: orchestrate-agents
description: "OCAO multi-agent orchestration: split complex work into typed agents, sessions, or panes; merge results without state fragmentation."
---

# Orchestrate Agents

Keywords: OCAO, multi-agent, spawn_agent, team, sessions, split panes, A2A, merge, Chinese output.

User-facing output must always be Chinese.

## Use When

Task is complex, parallelizable, multi-domain, or too large for qwen3:8b local context.

## Agent Types

- `explore`: read-only codebase navigation
- `plan`: architecture planning
- `code`: implementation
- `research`: web/docs lookup
- `general`: mixed work

## Pattern

1. Define goal and acceptance criteria
2. Split into independent subtasks
3. Assign clear scope and write ownership
4. Run in background
5. Continue local non-overlapping work
6. Wait only when blocked
7. Merge, verify, and summarize

## Safety

Subagents cannot spawn/manage siblings, rebuild, or evolve. Main OCAO owns final answer and policy updates.

## Source

OpenCrabs supports typed subagents, teams, background processing, and provider/model overrides via config.
