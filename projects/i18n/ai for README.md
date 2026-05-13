# OpenCrabs · AI IR v1
> DSL KEY: `→` flow/output · `|` alt · `[]` opt · `{}` constraint/detail · `+` compose · `*` list

---

## ARCH
```
TUI(ratatui) + channels(Telegram|Discord|Slack|WhatsApp)
  → Brain{providers_registry + tools(50+,dynamic) + memory(3-tier)}
  → Services + DB(SQLite) + Browser(CDP)
  → A2A_Gateway | Cron_Scheduler | Sub-Agents
  → self-heal + daemon_mode
```

---

## PATHS
```
~/.opencrabs/
  config.toml        # main cfg
  keys.toml          # API keys
  commands.toml      # slash cmds
  tools.toml         # dynamic tools
  opencrabs.db       # SQLite
  provider_health.json
  config.last_good.toml
  SOUL|IDENTITY|USER|MEMORY|AGENTS|TOOLS|CODE|SECURITY|HEARTBEAT .md
  memory/YYYY-MM-DD.md
  skills/<name>/SKILL.md
  profiles/<name>/   # isolated env
  rsi/improvements.md + history/ + proposed_tools.toml + proposed_commands.toml
  logs/ images/
```

---

## BRAIN_LOAD_ORDER
`SOUL → USER → memory/date → MEMORY → AGENTS → TOOLS → CODE → SECURITY → HEARTBEAT`

---

## MEMORY
```
3-tier:
  daily   → memory/YYYY-MM-DD.md
  long    → MEMORY.md
  search  → session_search(SQLite)

auto-write triggers:
  new_integration | server_change | bug_fixed | tool_config |
  cred_rotate | arch_decision | user_ask | debug>5min

context:
  auto-compact@≥80% | hard-truncate@≥90% | manual:/compact
```

---

## TOOLS
```
fs:      ls|glob|grep|read_file|edit_file|write_file
exec:    bash[timeout] | execute_code(lang,code)
net:     web_search | http_request(method,url,[hdr],[body])
session: session_search | session_context | task_manager
media:   generate_image | analyze_image | analyze_video
channel: telegram_send | discord_connect | slack_send | trello_connect
browser: navigate|click|type|screenshot|eval_js|extract_content|
         wait_for_element|find|browser_close
sys:     slash_command | config_manager | evolve | rebuild | plan
dynamic: tool_manage(create|update|delete)

passthrough(bash): gh|gog|docker|ssh|node|python3|ffmpeg|curl
```

---

## SUB-AGENTS
```
spawn_agent(label, TYPE, prompt) → agent_id
wait_agent(id, [timeout])
send_input(id, text)
resume_agent(id, prompt)
close_agent(id)
team_create(name, agents[]) | team_broadcast(name,msg) | team_delete(name)

TYPE permissions:
  general  → all tools {no recursive/dangerous}
  explore  → ls|glob|grep|read_file
  plan     → explore + bash
  code     → read+write, no recursive
  research → web_search|http_request + read_file

FORBIDDEN in all sub-agents:
  spawn_agent | resume_agent | wait_agent | send_input |
  close_agent | rebuild | evolve
```

---

## CRON
```
cmds: list | enable <name|id> | disable <name|id> | remove <name|id>
add:  --name --cron "0 9 * * *" --tz TZ --prompt TXT
      [--provider] [--model] [--thinking on|off|budget_XXk]
      [--deliver-to TARGET[,TARGET]] [--auto-approve]

deliver-to targets: telegram:ID | discord:ID | slack:ID | https://webhook
results → cron_results(SQLite)

HEARTBEAT: ~30min · shared_ctx · low-cost
CRON:      precise · isolated · multi-channel · model-swappable
```

---

## A2A
```
config.toml: [a2a] enabled=true {bind,port,api_key}
endpoint: http://host:18790/a2a/v1 (JSON-RPC)
methods: message/send | message/stream(SSE) | tasks/get | tasks/cancel
```

---

## SELF_HEAL
```
monitors: provider | config | context | stream | db | task_state
→ rollback  config.last_good.toml
→ fallback  provider_health.json
→ compress  context@65% async | truncate@90% hard
→ recover   pending_requests(SQLite) → route back to origin channel
→ notify    TUI + channel realtime
```

---

## RSI (Self-Improvement)
```
feedback_ledger(SQLite) [tool_success/fail, user_correction, provider_error]
→ analyze: fail>20% | repeat_correction | unstable_provider
→ patch brain_files: SOUL|TOOLS|MEMORY|AGENTS|SECURITY (局部, no rewrite)
→ log: rsi/improvements.md + rsi/history/
→ propose: proposed_tools.toml + proposed_commands.toml
→ human_review via mission-control | rsi_proposals
```

---

## PROFILES
```
manage: profile create|list|show|delete
switch: opencrabs -p <name> | OPENCRABS_PROFILE=<name>
isolated: config|memory|db|logs|skills|cron|gateway
migrate: profile migrate --from A --to B  {no history, config only}
export:  profile export <name> → tarball
import:  profile import <file>
lock: ~/.opencrabs/locks/*.lock  {prevent multi-process conflict}
service: opencrabs -p <name> service start
```

---

## VOICE
```
pipeline: audio → STT → LLM → TTS → OGG/Opus → channel

STT providers: groq(Whisper) | openai-compat | voicebox | local(whisper.cpp)
TTS providers: openai(gpt-4o-mini-tts) | openai-compat | voicebox | local(piper)
local: no API · no billing · data stays local · auto-download models
config entry: /onboard:voice
mode: stt_mode=local|api · tts_mode=local|api
```

---

## CUSTOM_COMMANDS (commands.toml)
```toml
[commands.NAME]
description = "..."
action      = "prompt|system"
value       = "..."
# works in: TUI|Telegram|Discord|Slack|WhatsApp
```

---

## DYNAMIC_TOOLS (tools.toml)
```toml
[[tools]]
name        = "NAME"
description = "..."
executor    = "shell|http"
command     = "cmd {{param}}"   # shell
# OR
method      = "GET|POST"
url         = "https://..."     # http
# {{param}} filled by agent at call time; hot-reload supported
```

---

## APPROVAL
```
/approve         → ask before each tool (default)
/approve auto    → auto-approve this session
/approve yolo    → always auto-approve (persistent)
```

---

## KEY_COMMANDS
```
/help /models /new /sessions /cd /compact /evolve /rebuild /approve
/btw(parallel subtask) /mission-control /skills /security-audit
/cost-estimate /repo-audit
!cmd → direct shell passthrough
```

---

## CLI_SURFACE
```
opencrabs [chat|daemon|agent[-m "msg"]|cron|channel|memory|
           session|db|logs|service(install|start|stop|restart|status)|
           status|doctor|onboard|completions|version]

opencrabs -p <profile> ...
```

---

## SOCIAL (SocialCrabs)
```
x:        tweet | read_mentions        {requires OAuth}
ig:       like                          {requires OAuth}
linkedin: connect                       {requires OAuth}
CONSTRAINT: all write ops need prior authorization; read-only ops may not
```

---

## SKILLS
```
path: ~/.opencrabs/skills/<name>/SKILL.md
fmt:  agentskills.io standard
load: /skills command
```

-- 如果你想了解闭环可以进入并查看 ./asprtu/ai for README.md