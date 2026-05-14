---
name: repo-audit
description: "OCAO repository health audit scored 0-100. Detect manifests first, run native tooling, cite evidence, avoid fake metrics."
---

# Repo Audit

Keywords: OCAO, repo health, language detection, tooling, CI, tests, dependencies, score, Chinese output.

User-facing output must always be Chinese.

## Route

Use for broad repository quality/maintainability audits. First detect project type. Do not apply one ecosystem's metrics to another. In OpenCrabs routing, this is a complex task when the repo is large, polyglot, or needs tool execution.

## Detect

Look for manifests:
- Rust: `Cargo.toml`.
- Node: `package.json` plus lockfile.
- Python: `pyproject.toml`, `requirements*.txt`, `Pipfile.lock`.
- Go: `go.mod`.
- JVM: `pom.xml`, `build.gradle*`.
- .NET: `*.csproj`, `*.fsproj`.
- Ruby/PHP/Swift/Dart/Elixir/Terraform/Docker: their standard manifests.

Multiple manifests mean polyglot or monorepo; report per stack.

## Run When Available

Use native tools only when installed:
- Rust: `cargo clippy`, `cargo test`, `cargo audit`, `cargo tree`, `cargo outdated`.
- Node: audit, lint, typecheck, tests via the detected package manager.
- Python: `ruff`, `pytest`, `mypy`, `pip-audit`.
- Go: `go vet`, `go test`, `staticcheck`, `govulncheck`.
- Others: use ecosystem scanners/build tools.

If missing, say what would run and continue with static/git checks.

## Universal Checks

- Git history: contributors, churn hotspots, reverts, commit discipline.
- Tests: source/test ratio using ecosystem conventions.
- CI/CD: workflow files, triggers, release automation.
- Structure: file size, module boundaries, god files, coupling.
- Dependencies: CVEs, staleness, unmaintained packages.
- Docs: README, license, changelog, setup instructions.
- Hygiene: `.gitignore`, secrets scan, build/dev experience.

## Score

Score 0-100 with weighted dimensions:
- tooling/lint/typecheck;
- dependency posture;
- tests;
- structure;
- error handling;
- documentation;
- CI/build hygiene;
- git workflow.

Renormalize when a dimension does not apply.

## Output

Markdown report:
- detected languages and manifests;
- tools available, run, skipped;
- score table;
- critical findings with evidence;
- healthy patterns;
- per-language notes only for detected languages;
- prioritized next steps: P0/P1/P2;
- what was not examined.

## Discipline

No fake zeros. No generic padding. Every finding needs file:line, command output, or git stat. If confidence is low, mark as limitation instead of a finding.
