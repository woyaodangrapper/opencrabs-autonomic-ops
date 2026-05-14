# TOOLS.md - OCAO Tool Map

Keywords: tools, OCAO, skills, sessions, split panes, multi-agent, A2A, Chinese output.

User-facing output must always be Chinese.

## Tool Principle

Tools extend the 8B main agent. Use them to reduce uncertainty, not to create state chaos.

## Skill Roles

- `main-router`: classify and route work
- `execution-guard`: approve/deny risky operations
- `state-graph`: keep task/session/profile state coherent
- `policy-store`: write durable lessons
- `orchestrate-agents`: split and merge complex tasks
- `session-panes`: use sessions and split panes for parallel main-agent work
- `a2a-gateway`: communicate with peer agents
- `browser-cdp`: inspect dynamic web state
- `dynamic-tools`: create runtime integrations
- `repo-audit`, `security-audit`: heavy audits

## Sessions

Each session has separate history, provider/model, working directory, queue, and cost tracking. Use sessions to isolate domains or concurrent work.

## Split Panes

Each pane is an independent session. Use panes for side-by-side planning, implementation, review, and test watching.

## Multi-Agent

Spawn typed agents only for concrete parallel subtasks. Track agent id, task, write scope, and result. Child agents must not own final truth; OCAO merges.

## Dynamic Tools

Create only narrow tools with clear names and least privilege. External write tools require approval policy.

## Local Notes

Store durable environment facts here only. Never store secrets.

## Custom Skills & Plugins
## Mission Control (`/mission-control`)
## Skills picker (`/skills`)
## Skills (Built-in & User)
## Tool Parameter Reference
## Browser Automation (CDP)
## Dynamic Tools (Runtime)
## Profile-Aware Paths
## System Commands (macOS, Windows, Linux)
## System CLI Tools
## What Goes Here
## Path Tips
## LLM Provider Configuration
## Integrations
## Why Separate?

### Rust-First Policy
### Keys
### Keys
### Layout
### Resolution order
### Auto-registration as slash commands
### SKILL.md format
### Built-in skills
### tool_manage actions
### Executor Types
### tools.toml Format
### Commands vs Tools vs Skills
### GitHub CLI (gh)
### Google CLI (gog)
### Adding a New Custom Provider
### Multiple Providers Coexisting
### Per-Session Provider
### Provider Priority (new sessions inherit first enabled)
### Channel Connections
### WhisperCrabs — Voice-to-Text (D-Bus)
### SocialCrabs — Social Media Automation
### Agent-to-Agent (A2A) Gateway