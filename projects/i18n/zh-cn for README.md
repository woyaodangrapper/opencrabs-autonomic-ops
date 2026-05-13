- 如果你是 AI 请忽略该文件，移动至同级文件目录的 ai for README.md 

## 架构
```
┌─────────────────────────────────────────────────┐
│          TUI (ratatui) + Split Panes             │
├────────┬────────┬──────────┬────────────────────┤
│Telegram│Discord │  Slack   │     WhatsApp       │
├────────┴────────┴──────────┴────────────────────┤
│                 Brain (Agent Core)               │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │ Providers│ │  Tools   │ │  Memory (3-tier) │ │
│  │ Registry │ │ +Dynamic │ │                  │ │
│  └──────────┘ └──────────┘ └──────────────────┘ │
├─────────────────────────────────────────────────┤
│   Services / DB (SQLite) │ Browser (CDP)         │
├─────────────────────────────────────────────────┤
│   A2A Gateway │ Cron Scheduler │ Sub-Agents      │
├─────────────────────────────────────────────────┤
│   Shared Channel Commands (commands.rs — 847 lines) │
├─────────────────────────────────────────────────┤
│   Self-Healing (config recovery, provider health, │
│   ARG_MAX compaction, error surfacing)             │
├─────────────────────────────────────────────────┤
│   Daemon Mode (health endpoint, auto-reconnect)  │
└─────────────────────────────────────────────────┘

```

## 目录结构

### 代码
```
src/
├── main.rs              # 入口点，CLI 参数解析
├── lib.rs               # 库根模块
├── cli/                 # CLI 参数解析（clap）
├── config/              # 配置类型、加载、健康状态跟踪
│   └── health.rs        # Provider 健康状态持久化（120 行）
├── db/                  # SQLite 数据库层
│   ├── models.rs        # 数据模型（Session、Message 等）
│   └── repository/      # 各实体查询函数
├── migrations/          # SQL 迁移文件
├── services/            # 业务逻辑层
│   └── session.rs       # 会话管理服务
├── brain/               # Agent 核心层
│   ├── agent/           # Agent 服务、上下文、工具循环
│   │   └── service/     # Builder、context、helper、tool_loop
│   ├── provider/        # LLM Provider 实现
│   ├── tools/           # 50+ 工具实现
│   └── memory/          # 三层记忆系统
├── tui/                 # 终端 UI（ratatui + crossterm）
│   ├── app/             # 应用状态、输入、消息系统
│   └── render/          # UI 渲染模块
├── channels/            # 多渠道消息集成
│   ├── commands.rs      # 通用文本命令处理器（847 行）
│   ├── telegram/        # 基于 Teloxide 的机器人
│   ├── discord/         # 基于 Serenity 的机器人
│   ├── slack/           # Slack Socket Mode
│   └── whatsapp/        # WhatsApp Web 绑定
├── a2a/                 # Agent-to-Agent 网关（axum）
├── cron/                # 定时任务调度器
├── memory/              # 向量检索 + FTS5
├── docs/                # 内嵌文档模板
├── tests/               # 集成测试
└── benches/             # Criterion 性能基准测试
```
### 运行配置
``` toml
~/.opencrabs/
├── config.toml          # 主配置文件
├── keys.toml            # API 密钥
├── commands.toml        # 自定义斜杠命令
├── opencrabs.db         # SQLite 数据库
├── SOUL.md              # Agent 性格设定
├── IDENTITY.md          # Agent 身份定义
├── USER.md              # 用户画像 / 用户资料
├── MEMORY.md            # 长期记忆
├── AGENTS.md            # Agent 行为规则文档
├── TOOLS.md             # 工具调用说明 / 工具引用
├── SECURITY.md          # 安全策略
├── HEARTBEAT.md         # 周期性检查任务
├── memory/              # 日常记忆记录
│   └── YYYY-MM-DD.md
├── images/              # 生成的图片
├── logs/                # 应用日志
└── skills/              # 自定义能力模块 / 插件

快捷键
命令	描述
/help	显示所有可用命令
/models	交换机提供商或型号
/new	创建新会话
/sessions	在不同会话之间切换
/cd	更改工作目录
/compact	手动压缩上下文
/evolve	下载最新版本
/rebuild	从源代码构建
/approve	制定审批政策


审批模式
控制智能体的自主程度：

模式	行为
/approve	每次使用工具前请先询问（默认）
/approve auto	自动批准本次会话
/approve yolo	始终自动批准（持久化）

```

##  CLI 使用说明

### 基本用法
``` toml
opencrabs [COMMAND] [OPTIONS]

# OpenCrabs 命令列表

- chat：启动默认 TUI 聊天界面  
- daemon：后台运行（无界面模式）  
- agent：单轮或多轮交互模式  
- cron：计划任务管理  
- channel：渠道管理  
- memory：记忆查看与管理  
- session：会话管理  
- db：数据库初始化与维护  
- logs：日志查看与清理  
- service：系统服务安装/启动/停止  
- status：查看运行状态  
- doctor：系统健康检查  
- onboard：初始化配置向导  
- completions：生成 shell 自动补全  
- version：版本信息  

## 特殊命令

- `!command`：直接执行 shell 命令  
- `/evolve`：自动更新并重启  
- `/btw`：并行子任务执行  
- `/mission-control`：任务控制面板  
- `/skills`：技能/工作流管理  
- `/security-audit`：安全扫描  
- `/cost-estimate`：成本与ROI分析  
- `/repo-audit`：代码库结构与质量审计  

```

### 聊天命令

- /doctor：检查连接健康状况
- /help：查看帮助
- /usage：查看用法
- /evolve：自动更新并重启

### 代理：交互式多轮聊天
opencrabs agent

### 代理：单条消息模式
opencrabs agent -m "今天哪些文件发生了变化?"

### 进程模式
不要控制台界面交互启动：```opencrabs daemon```

- 网络故障时自动重连，并有 5 秒的延迟。

### 服务管理
将 OpenCrabs 安装为系统服务（macOS 系统使用 launchd，Linux 系统使用 systemd）：

- opencrabs service install
- opencrabs service start
- opencrabs service stop
- opencrabs service restart
- opencrabs service status


## OpenCrabs 内置工具

[来源](https://docs.opencrabs.com/brain/tools.html)

### 文件系统
- ls(path)：列目录
- glob(pattern, path)：文件匹配
- grep(pattern, path, include)：内容正则搜索
- read_file(path, line_start?, line_end?)：读文件
- edit_file(path, old_string, new_string)：替换编辑
- write_file(path, content)：写文件

---

### 执行系统
- bash(command, timeout?)：执行 shell
- execute_code(language, code)：沙盒运行代码

---

### 网络
- web_search(query)：搜索
- http_request(method, url, headers?, body?)：HTTP 调用

---

### 会话 / 记忆 / 任务
- session_search(query, limit?)：跨会话检索
- session_context(action)：读写上下文
- task_manager(action, params)：任务管理

---

### 多模态
- generate_image(prompt, filename)：生成图像
- analyze_image(image, question)：图像理解
- analyze_video(video, question)：视频理解

---

### 通道集成
- telegram_send(action, params)
- discord_connect(action, params)
- slack_send(action, params)
- trello_connect(action, params)

---

### 子代理系统（并行执行）
- spawn_agent(label, agent_type, prompt)：创建子代理
- wait_agent(agent_id, timeout)：等待结果
- send_input(agent_id, text)：追加输入
- close_agent(agent_id)：终止代理
- resume_agent(agent_id, prompt)：恢复代理
- team_create(team_name, agents[])：创建代理组
- team_broadcast(team_name, message)：群发
- team_delete(team_name)：删除组

---

### agent_type（权限模型）
- general：全功能
- explore：只读（read_file/glob/grep/ls）
- plan：规划（read + bash）
- code：读写全权限
- research：read + web_search + http_request

限制：
- 禁止递归 spawn_agent
- 禁止 self-modify / rebuild / evolve
- 禁止 agent 控制其他 agent 生命周期工具

---

### 浏览器自动化（CDP）
- navigate(url)
- click(selector)
- type(selector, text)
- screenshot(selector)
- eval_js(code)
- extract_content(selector)
- wait_for_element(selector, timeout)
- find(pattern, mode)
- browser_close()

---

### 动态工具系统
- tool_manage(action, params)：创建/更新/删除工具

---

## 系统控制
- slash_command(command, args)：执行 /xxx 命令
- config_manager(action, params)：配置读写
- evolve(check_only)：更新系统
- rebuild()：重建重启
- plan(action, params)：执行计划管理

---

### CLI 直通能力（bash通道）
允许直接调用系统已有工具：
- gh
- gog
- docker
- ssh
- node
- python3
- ffmpeg
- curl

---

### GitHub CLI（gh）
- issue / pr / release / run 全生命周期管理

---

### Google CLI（gog）
- calendar / gmail 操作（OAuth）

---

### 社交自动化（SocialCrabs）
- x tweet / mentions
- ig like
- linkedin connect
（写入操作需授权）

---

### 语音系统（WhisperCrabs）
- start/stop recording
- provider switch
- transcript history
- D-Bus 控制


## 自定义命令（commands.toml）

### 做什么
把“固定指令”变成 `/xxx` 快捷命令，可以在：
- TUI / Telegram / Discord / Slack / WhatsApp

直接调用。

---

### 定义方式

```toml id="a9k2qp"
[commands.name]
description = "说明"
action = "prompt | system"
value = "执行内容"
```

## 内存系统

### 3层结构

- 每日记录：`~/.opencrabs/memory/YYYY-MM-DD.md`
- 长期记忆：`~/.opencrabs/MEMORY.md`
- 历史搜索：`session_search`（SQLite）

---

### 读取方式
- session_search：快速查历史
- memory文件：完整上下文

---

### 自动压缩
- 上下文太长（≈80%）自动总结
- 清掉旧内容，只保留摘要
- /compact：手动触发

---

### 自动写入规则

写入到 `~/.opencrabs/MEMORY.md` 或 `~/.opencrabs/memory/YYYY-MM-DD.md`：

- 新集成 / 新连接
- 服务器或环境变化
- bug 修复完成
- 工具/插件配置变化
- 凭据轮换
- 架构决策
- 用户要求“记住”
- 长时间调试完成（>5min）

## 脑档案

启动读取顺序
- SOUL.md— 性格和价值观
- USER.md— 您的个人资料和偏好
- memory/YYYY-MM-DD.md— 今日笔记
- MEMORY.md— 长期记忆
- AGENTS.md— 代理行为准则
- TOOLS.md— 工具参考和自定义注释
- CODE.md— 编码标准和文件组织
- SECURITY.md— 安全策略
- HEARTBEAT.md— 定期检查任务


## 动态工具
可运行时定义自定义工具。在文件中定义，~/.opencrabs/tools.toml 并且可以动态创建、删除和热重载。

### 工具定义

``` toml
[[tools]]
name = "deploy"
description = "把应用部署到生产环境"
executor = "shell"
command = "cd {{project_dir}} && ./deploy.sh {{environment}}"

[[tools]]
name = "check-status"
description = "检查服务健康状态"
executor = "http"
method = "GET"
url = "https://api.example.com/health"
```

工具链
| 执行	|描述
|-----|-----|
shell |	运行 shell 命令
http	| 发出 HTTP 请求

### 工具参数
 使用 {{param}} 动态值语法。代理在调用工具时会填充这些值：

``` toml
[[tools]]
name = "search-logs"
description = "在应用日志中搜索指定模式"
executor = "shell"
command = "grep -r '{{pattern}}' /var/log/myapp/ --include='*.log' -l"
```


### 定时任务管理

``` toml
# 列出所有定时任务
opencrabs cron list

# 添加一个新的定时任务
opencrabs cron add \
  --name "每日报告" \
  --cron "0 9 * * *" \   # 每天 9:00 执行
  --tz "America/New_York" \   # 时区：纽约时间
  --prompt "检查邮件并做总结" \   # 让 AI 执行的任务内容
  --provider anthropic \   # 使用的 AI 服务提供商
  --model claude-sonnet-4-20250514 \   # 使用的模型
  --thinking off \   # 关闭“思考模式”（直接执行）
  --deliver-to telegram:123456   # 结果发送到 Telegram 指定用户/频道

# 删除一个定时任务（可以用名字或ID）
opencrabs cron remove "每日报告"

# 启用/禁用定时任务（可以用名字或ID）
opencrabs cron enable "每日报告"
opencrabs cron disable "每日报告"
```

#### 配置
 旗帜 |	描述
|-----|-----|
--name |	职位名称（唯一标识符）
--cron |	定时任务表达式（例如0 9 * * *）
--tz |	时区（例如America/New_York）
--prompt |	发送给代理商的提示
--provider |	使用的AI提供商（可选）
--model |	使用的模型（可选）
--thinking |	思考模式：on，，offbudget_XXk
--deliver-to |	渠道交付方式：telegram:CHAT_IDHTTP discord:CHANNEL_IDWebhook URL 或以逗号分隔的多个目标
--auto-approve |	自动批准此作业使用工具

#### 多靶点发送（deliver_to）

- `--deliver-to`：用逗号分隔多个目标

```bash
--deliver-to "telegram:-12345,http://webhook.example.com/notify"

```
支持：
- telegram:ID
- discord:ID
- slack:ID
- http(s)://webhook

结果：
- 全部写入 cron_results
- 可查历史结果

---

### HEARTBEAT vs CRON

#### HEARTBEAT
- 松时间（≈30min）
- 省调用
- 共用上下文

#### CRON
- 精确定时
- 独立执行
- 可换模型
- 指定输出通道

## 多智能体编排

### 代理类型（agent_type）

#### general（默认）
- 全功能
- 能读写 + 调工具
- 不能用危险/递归工具

---

#### explore
- 只读模式
- 工具：ls / glob / grep / read_file
- 用于：快速看代码结构

---

#### plan
- 只读 + shell分析
- 可以用 bash
- 用于：设计方案 / 架构分析

---

#### code
- 完整写权限
- 可以改代码
- 不能用递归/危险工具

---

#### research
- 只能联网
- 工具：web_search / http_request + 只读文件
- 用于：查资料 + 对比方案

---

### 安全限制（所有类型都禁止）

- spawn_agent（不能再生成子代理）
- resume_agent
- wait_agent
- send_input
- close_agent
- rebuild
- evolve

---

### 子代理控制

#### 创建
spawn_agent(label, agent_type, prompt)
→ 开一个后台 AI 任务

---

#### 等待结果
wait_agent(agent_id, timeout)

---

#### 追加任务
send_input(agent_id, text)
→ 在运行中继续加指令

---

#### 继续执行
resume_agent(agent_id, prompt)
→ 在原上下文上继续做

---

#### 关闭
close_agent(agent_id)
→ 停掉任务

---

### 多代理团队

#### 创建团队
team_create(team_name, agents[])
→ 同时启动多个 agent

---

#### 广播指令
team_broadcast(team_name, message)
→ 全员同步信息

---

#### 删除团队
team_delete(team_name)
→ 全部停止

---

### 运行逻辑

- agent = 干活的 AI
- spawn_agent = 开新线程
- team = 并行任务组

---

### 模型分配（重要）

- 主 agent：强模型（如 Claude / GPT-5）
- 子 agent：可以换便宜模型（Qwen 等）

→ 用来降成本 + 提速

---

### 一句话理解

agent 系统 =

> “一个可以拆任务、并行执行、还能互相通信的 AI 工作线程系统”

## 分布式智能体
[来源](https://docs.opencrabs.com/features/a2a.html)

A2A = 在 `~/.opencrabs/config.toml` 开启 `[a2a] enabled=true`（配置 bind/port/api_key）后，对 `http://host:18790/a2a/v1` 发 JSON-RPC 请求（message/send / message/stream / tasks/get / tasks/cancel），用来把任务发送给另一个 agent 执行并返回结果（支持同步结果或 SSE 流式输出）。

## 自愈

[来源](https://docs.opencrabs.com/features/self-healing.html)

self-healing = 运行中自动监控（provider/config/context/stream/db/任务状态），在 `~/.opencrabs/config.toml`（[agent]/[providers]/[a2a]/[cron]）异常时自动回滚 `~/.opencrabs/config.last_good.toml`，在 `~/.opencrabs/provider_health.json` 记录失败/成功并触发 fallback providers，在 context ≥65% 时异步压缩（≤90% 强截断），stream 卡死则检测重复/idle timeout 后重试或切 provider，pending_requests（SQLite）在崩溃后自动恢复任务并路由回原 channel（Telegram/Discord/Slack/WhatsApp），所有修复事件通过 TUI + channel 实时通知。

## 自学习

[来源](https://docs.opencrabs.com/features/self-improvement.html)
RSI（自我提升）= OpenCrabs 通过记录所有工具成功/失败、用户纠正、provider错误等反馈（SQLite feedback ledger），周期性执行 feedback_analyze 找出失败模式（如工具失败率>20%、重复用户纠正、provider不稳定），然后自动触发 self_improve，读取 `~/.opencrabs/SOUL.md / TOOLS.md / MEMORY.md / AGENTS.md / SECURITY.md` 等“脑文件”，做局部补丁式修改（不重写全文），并把改动记录到 `~/.opencrabs/rsi/improvements.md` + `~/.opencrabs/rsi/history/`，同时支持 RSI 提案系统（生成新 tools/commands 写入 `~/.opencrabs/rsi/proposed_tools.toml` 和 `proposed_commands.toml`，需人工从 mission-control 或 rsi_proposals 审核后落地），核心是“从运行反馈 → 模式识别 → 自动改规则/行为/工具 → 持续迭代能力”。

## 多配置

多配置文件 = 一个 OpenCrabs 安装里运行多套完全隔离环境，每套 profile 都有自己的 `~/.opencrabs/profiles/<name>/` 目录（含 config.toml / memory / sessions.db / logs / layout），并通过 `opencrabs profile create|list|show|delete` 管理，用 `opencrabs -p <name>` 或 `OPENCRABS_PROFILE=<name>` 切换；profile 之间互相隔离 API key、memory、brain 文件、skills、cron、gateway 服务，支持 `profile migrate --from A --to B` 复制配置（不带历史数据）、`profile export/import` 打包迁移，并且每个 profile 可单独运行 daemon/service（如 `opencrabs -p hermes service start`），同时 Telegram/Discord/Slack token 通过 lock file（`~/.opencrabs/locks/*.lock`）避免多 profile/多进程冲突，确保不同 profile 互不污染。

## 语言识别

语音系统（TTS + STT）= 在 `~/.opencrabs/config.toml` 的 `[voice]` 中配置启用，通过 `stt_mode / tts_mode` 选择 provider（groq / openai-compatible / voicebox / local），密钥在 `~/.opencrabs/keys.toml`，本质是“语音消息 → STT 转文本 → agent处理 → TTS转语音返回”。

---

STT（语音转文本）：
- Groq（Whisper API，`keys.toml` 配 `providers.stt.groq.api_key`）
- OpenAI兼容（`stt_base_url + stt_model`）
- Voicebox（自托管 `voicebox_stt_base_url`）
- Local（whisper.cpp，`local_stt_model=local-tiny/base/small/medium`，模型下载到 `~/.local/share/opencrabs/models/whisper/`）

---

TTS（文本转语音）：
- OpenAI（`tts_model=gpt-4o-mini-tts`，voice: echo/alloy/nova等，key在 `providers.tts.openai`）
- OpenAI兼容（`tts_base_url + tts_model + tts_voice`）
- Voicebox（`voicebox_tts_base_url + profile_id`）
- Local（Piper，`local_tts_voice=ryan/amy/joe/...`，模型在 `~/.local/share/opencrabs/models/piper/`）

---

快速配置入口：
- `/onboard:voice`（TUI里交互式配置 STT + TTS + provider + key）

---

执行链路：
语音消息 → STT转文本 → agent处理 → TTS生成语音 → OGG/Opus返回到 Telegram/Discord/Slack/WhatsApp

---

模式切换：
- `stt_mode = local/api`
- `tts_mode = local/api`

---

本地模式特点：
- whisper.cpp + Piper
- 不走 API
- 不计费
- 数据不出本机
- 自动下载模型

---

本质：
voice = “聊天输入输出从 text 扩展成 audio pipe（STT→LLM→TTS）的一条完整链路”



## OpenCrabs 技能系统（Skills System）

技能是可复用的工作流模板，用于扩展 OpenCrabs 的能力边界。  
所有技能统一使用 `SKILL.md` 格式，并通过目录结构加载。


---

### 目录

技能存放于：```~/.opencrabs/skills/```

示例结构：

```
~/.opencrabs/skills/
├── security-audit/
│ └── SKILL.md
├── cost-estimate/
│ └── SKILL.md
└── my-custom-skill/
└── SKILL.md
```

[Agent Skills 标准化格式](https://agentskills.io/home)

---

> 如果你想了解闭环，可以查看 [./asprtu/zh-cn for README.md](./asprtu/zh-cn%20for%20README.md)