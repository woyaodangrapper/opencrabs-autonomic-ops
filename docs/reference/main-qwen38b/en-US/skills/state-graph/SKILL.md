---
name: state-graph
description: "OCAO state coherence skill: track task, session, profile, pane, agent, A2A, files, and policy to avoid state fragmentation."
---

# State Graph

Keywords: OCAO, state, session, profile, pane, agent id, task id, policy drift, Chinese output.

User-facing output must always be Chinese.

## Track

For non-trivial work record:
- active goal
- workspace/profile
- session/pane
- files touched
- agents spawned and ids
- A2A task/context ids
- approvals
- tests/checks
- pending next action

## Use

Use before switching sessions, panes, profiles, or agents. Use after compaction. Use when results conflict.

## Output

Return a short state ledger and next action. Do not dump history.

## Rule

One final answer owns the merged truth. Subagents and panes produce inputs, not final state.
