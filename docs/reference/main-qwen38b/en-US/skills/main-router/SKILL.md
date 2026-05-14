---
name: main-router
description: "OCAO main qwen3:8b routing skill: classify intent, complexity, risk, state need, and choose direct execution, skill, session, pane, A2A, or subagent."
---

# Main Router

Keywords: OCAO, qwen3:8b, router, complexity, risk, direct, delegate, Chinese output.

User-facing output must always be Chinese.

## Purpose

Use this first when the task shape is unclear. The 8B main agent must route before deep work.

## Classify

- Intent: answer, edit, code, audit, operate, research, coordinate
- Complexity: simple, medium, complex
- Risk: safe, external, destructive, secret, public
- State need: none, file, session, profile, A2A, memory
- Output: direct answer, action plan, delegated result, policy update

## Route

- Simple + safe -> direct qwen3:8b execution
- Medium -> use one focused skill/tool
- Complex -> plan then orchestrate agents/sessions
- Risky -> `execution-guard`
- State unclear -> `state-graph`
- Durable lesson -> `policy-store`

## Rule

If unsure between direct and delegate, inspect cheaply first. Do not delegate vague tasks.
