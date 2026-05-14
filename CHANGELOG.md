# Changelog

## Unreleased

- Refactored OpenCrabs brain templates into compressed OCAO operations profiles for a `qwen3:8b` main agent.
- Injected OCAO personality and routing rules across root brain files: Chinese user-facing output, English compressed brain files, simple-task direct execution, complex-task delegation, execution guard, state graph, and policy store.
- Rebuilt skills around the OCAO architecture: added `main-router`, `execution-guard`, `state-graph`, `policy-store`, `orchestrate-agents`, and `session-panes`.
- Retained and aligned core operational skills: `a2a-gateway`, `browser-cdp`, `dynamic-tools`, `repo-audit`, and `security-audit`.
- Disabled framework-misaligned skills: `cost-estimate` and `opencli`.
