---
name: execution-guard
description: "OCAO risk gate for external, destructive, secret, public, or irreversible operations."
---

# Execution Guard

Keywords: OCAO, risk, approval, external action, destructive, secrets, Chinese output.

User-facing output must always be Chinese.

## Classify

- Internal read: allow
- Internal safe edit: allow, verify
- Build/test: allow unless it writes outside allowed scope or uses network
- External read: allow if public/authorized
- External write: ask
- Destructive/irreversible: ask
- Secret use: minimize and redact
- Public/group output: ask when user identity or private context is involved

## Before Action

State:
- what will change
- where it will change
- rollback path if any
- approval needed or not

## After Action

Verify result. If failed, say failed. Never hallucinate success.
