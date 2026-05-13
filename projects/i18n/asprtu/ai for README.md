# Aspire·AI IR v1
> DSL KEY: `→` flow · `|` alt · `[]` opt · `{}` constraint · `+` compose

---

## CHANNELS
```
CLI         aspire run|logs|service_list          → control_plane
Network     HTTP|gRPC|TCP|MCP_tool_invocation     → data_plane
Metadata    service_graph|registry|schema|config  → structural_plane
Observ.     logs|health|traces                    → feedback_plane

relation: CLI→触发 · Network→执行 · Metadata→约束边界 · Observ.→回传状态
```

---

## OTEL
```
Trace   request→service→tool              → trace_DAG
Span    function|service_block            → span_detail
Log     time-based structured             → event_stream
Metric  latency|error|throughput          → metrics_endpoint
```

---

## RUNTIME_CAPABILITIES
```
L1 Composable       服务动态组合|重编排|拓扑重建   {系统=可拼装结构}
L2 ImplicitContract timeout|retry|log|trace|health 自动注入  {规则来自注入,非配置}
L3 ContextProp      trace_id|request_id|correlation 跨服务自动传播  {系统=上下文流}
L4 Dev=Prod         本地模拟 mesh|多服务|MCP|API|worker  {无需K8s即可观测}
```

---

## AI_INTERACTION_MODEL
```
Control Plane:
  AI → bash(aspire run) → AppHost → service_graph激活 → runtime_entry
  AI → bash(aspire logs <svc>) → structured_logs → MML解析

Orchestration Plane:
  AI → AppHost service_graph(DAG) → dependency解析
  → Aspire自动拓扑构建 → MCP_tool注册为可调用能力

Observability Plane:
  AI → aspire logs|dashboard|trace_API → OTEL数据
  → MML → 请求路径分析|延迟瓶颈|异常归因|tool调用链重建

unified:
  AI(CLI|MCP) → Aspire(控制+编排+运行) → service执行
  → OTEL输出 → MML → 结构化结论 → AI决策
```

---

## OPENCRABS_ASPIRE_LOOP
```
入口: Channel(Telegram|Discord|Slack|TUI)|Cron
  → Brain(SOUL+AGENTS+TOOLS) 匹配规则 → 决策交互Aspire

Control:
  bash(aspire run)           → AppHost + service_graph激活
  bash(aspire service list)  → 当前拓扑
  bash(aspire logs <svc>)    → 结构化日志

Orchestration:
  Brain → DAG解析(API→DB→Worker→MCP_Tool)
  spawn_agent(explore, "拓扑分析") → 只读并行扫描

Observability → Brain摄入:
  structured_logs → 语义解析|异常检测 → MEMORY.md|memory/date
  trace_DAG       → 调用链重建|瓶颈定位 → session_context
  metrics         → 状态摘要           → task_manager

Cognition(MML):
  → 全链路路径分析(API→DB→Tool)
  → 瓶颈|异常归因
  → 决策(修复|扩容|告警|再编排)
  RSI feedback_ledger ← 本次执行反馈

Output:
  → deliver-to 原始Channel
  → [cron_results持久化] [rsi/improvements.md追加]
```

---

## FULL_PIPELINE
```
用户任务
  └→ Brain(SOUL+TOOLS+MEMORY)
       ├→ bash → aspire run|logs|service_list   [Control]
       ├→ spawn_agent(explore) → service_graph  [Orchestration]
       ├→ OTEL → logs|trace|metrics             [Observability]
       ├→ MML → 结论+决策
       ├→ RSI feedback_ledger ← 执行反馈
       └→ Channel输出 + MEMORY写入
```

---

## AXIOM
```
OpenCrabs ≠ Aspire客户端
OpenCrabs = Brain(Aspire三通道→统一认知输入) → 闭合决策环路
```
