# OpenCrabs Autonomic Ops — Copilot Instructions

## Workspace Layout

This repo has two distinct parts:

| Directory                  | Purpose                                                                     |
| -------------------------- | --------------------------------------------------------------------------- |
| `opencrabs/`               | Rust binary/library — the AI agent engine                                   |
| `projects/pre-production/` | OCAO runtime workspace — config, brain files, skills for the deployed agent |

> **Important**: `AGENTS.md` files inside `projects/` and `docs/reference/` are runtime instructions for the OCAO agent, not for this coding agent.

## Build & Test (run from `opencrabs/`)

```bash
# Build
cargo build --all-features

# CI checks (all three must pass before a PR)
cargo fmt --all -- --check
cargo clippy --lib --bins --tests --all-features -- -D warnings
cargo test --all-features --verbose
```

Rust toolchain: `stable` (edition 2024, min `rust-version = "1.91"`). See [rust-toolchain.toml](../opencrabs/rust-toolchain.toml).

## Source Architecture (`opencrabs/src/`)

```
brain/
  agent/       # AgentService — tool loop, context management
  provider/    # LLM providers: Anthropic, OpenAI-compatible, Gemini, Copilot, Claude CLI, Qwen…
  tools/       # Built-in tools: bash, edit, read, grep, web_search, a2a_send, plan_tool…
  mission_control/
  rsi*.rs      # Recursive Self-Improvement engine (runs hourly)
a2a/           # Agent-to-Agent protocol (A2A RC v1.0, JSON-RPC 2.0, axum server)
channels/      # Telegram, Discord, Slack, WhatsApp, Voice (Whisper + TTS)
config/        # TOML config loading (types.rs, secrets.rs, profile.rs)
db/            # SQLite via deadpool-sqlite + rusqlite (migrations in migrations/)
memory/        # FTS5 + vector search (qmd crate), hybrid RRF ranking
tui/           # Terminal UI (ratatui + crossterm)
cli/           # CLI entry (clap), crash recovery, cron
```

Key references: [CONTRIBUTING.md](../opencrabs/CONTRIBUTING.md) · [TESTING.md](../opencrabs/TESTING.md)

## Rust Conventions

- Files: `snake_case.rs` · Structs/Enums: `PascalCase` · Constants: `SCREAMING_SNAKE_CASE`
- Errors: `anyhow::Result` for application code, `thiserror` for typed library errors
- Async: `tokio` only — never block in async context
- Commit style: [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `refactor:`)
- No stub/placeholder code (`todo!()`, `unimplemented!()`, empty `vec![]` returns)
- Every bug fix needs a regression test; every feature needs unit tests

## LLM Provider System

Providers live in `src/brain/provider/`. The factory pattern (`factory.rs`) selects the provider based on `config.toml`. Config keys follow `[providers.<name>]` or `[providers.custom.<name>]`. The `crabrace` crate (`crabrace = "0.1.0"`) is the provider registry abstraction.

## A2A Protocol

`src/a2a/` implements A2A RC v1.0 over axum. Entry: `server::start_server()`. Debate/multi-agent: `debate::run_debate()`. Agent card served at `/.well-known/agent.json`.

## Config Files (pre-production)

Config for the running agent is in `projects/pre-production/`. TOML sections:

- `[providers.ollama]` — local Ollama endpoint
- `[providers.custom.<name>]` — any OpenAI-compatible endpoint
- `[agent]` — context limits, subagent routing
- `[cron]` — scheduled task provider
- `[channels.*]` — enable/disable messaging channels

> `[providers.ollama]` cannot appear multiple times in the same TOML file (duplicate keys). Use `[providers.ollama.<alias>]` or separate profiles for multiple Ollama models.

## Memory & State

User workspace state lives in `~/.opencrabs/` (Linux/macOS) or `%APPDATA%\opencrabs\` (Windows). The SQLite DB defaults to `~/.opencrabs/opencrabs.db`. FTS5 memory index is rebuilt via `memory::reindex()`.

## RSI (Recursive Self-Improvement)

`src/brain/rsi.rs` — background hourly cycle. Reads `feedback_ledger` from DB, requires ≥50 entries before running. Controlled by `[agent].self_improvement_provider` / `self_improvement_model` in config.
