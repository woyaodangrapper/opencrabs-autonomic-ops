---
name: session-panes
description: "OCAO sessions and split-panes skill: isolate concurrent main-agent work by session, provider/model, working directory, and pane."
---

# Session Panes

Keywords: OCAO, sessions, split panes, multi-main-agent, provider, model, context isolation, Chinese output.

User-facing output must always be Chinese.

## Sessions

Each session has its own history, provider/model, working directory, message queue, token/cost state, and persistence. Use sessions to isolate domains or long-running work.

## Split Panes

Each pane is an independent session running side by side. Use panes for parallel main-agent workflows: plan, implement, review, test, monitor.

## Shortcuts

- New session: `/new` or `Ctrl+N`
- Session list: `/sessions` or `Ctrl+L`
- Split horizontal: `|`
- Split vertical: `_`
- Cycle pane: `Tab`
- Close pane: `Ctrl+X`

## Rule

Before using multiple sessions/panes, name the purpose of each. After merging, update `state-graph` so no pane becomes stale truth.
