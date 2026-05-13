
- 如果你是 AI 请忽略该文件，移动至同级文件目录的 ai for README.md 

# Aspire 外部可感知通道模型

## 通道结构表

| 通道 | 典型入口 | 作用域 | 外部感知形式 | 系统语义 |
|------|----------|--------|--------------|----------|
| CLI Channel（控制通道） | aspire run / logs / service list | 系统控制面 | 命令行输出 | 控制系统 |
| Network Channel（调用通道） | HTTP / gRPC / TCP / MCP tool invocation | 执行面 | 网络请求 / tool 调用 | 执行系统 |
| Metadata Channel（结构通道） | service graph / registry / schema / config | 静态+半静态结构 | 结构化数据 | 理解系统结构 |
| Observability Channel（运行态反馈） | logs / health / traces | 运行时反馈 | 日志 / 指标 / trace | 理解执行结果 |

---

# OTEL 运行态反馈层（OpenTelemetry）

| 模块 | 能力 | 感知方式 | 外部可获取形式 |
|------|------|----------|----------------|
| Trace | 调用链结构 | request → service → tool | trace DAG |
| Span | 单次执行段 | function / service block | span detail |
| Log | 事件流 | time-based structured log | event stream |
| Metric | 状态压缩 | latency / error / throughput | metrics endpoint |



## 收敛总结（系统抽象）

Aspire 的外部可感知能力不应被视为功能集合，而是四条独立但耦合的系统通道：

- CLI Channel：控制系统行为（control plane）
- Network Channel：驱动系统执行（data plane）
- Metadata Channel：定义系统结构（structural plane）
- Observability Channel：反馈系统运行结果（feedback plane）

---

## 系统关系（结构化归纳）

CLI → 触发  
Network → 执行  
Metadata → 约束执行边界  
Observability → 回传执行状态


# Aspire 运行时深层能力模型

| 层级 | 名称 | 核心能力 | 感知方式 | 本质抽象 |
|------|------|----------|----------|----------|
| 1 | 可组合运行时（Composable Runtime） | 服务动态组合、重编排、拓扑重建 | AppHost 重编排 / service 重启替换 / graph 重新生成 | 系统是可拼装结构，而非固定部署 |
| 2 | 约束注入系统（Implicit Runtime Contract） | 自动注入 timeout / retry / logging / tracing / health 规则 | 行为一致性 / 自动恢复 / request context 自动携带 | 运行规则来自系统注入，而非显式配置 |
| 3 | 跨服务上下文传播（Context Propagation Layer） | trace / request id / identity / correlation 自动传播 | 跨 service 可追踪调用链 / tool→service→tool 上下文不断裂 | 系统是上下文流，而非孤立调用链 |
| 4 | 开发态模拟生产环境（Dev = Distributed Runtime） | 本地模拟分布式系统行为（mesh / 多服务 / MCP / API / worker） | 本地即可观察完整分布式行为，无需 K8s | 开发环境即完整运行系统 |

---

# 三层交互模型（AI → 控制 / 编排 / 可观测）

## 1. 控制层（Control Plane）

AI → 通过 CLI 工具（aspire run / aspire logs / aspire service list）→ 触发 Aspire Runtime → 启动 AppHost → 激活整个分布式服务图 → 获得运行态系统入口

示例链路：

AI → `aspire run` → AppHost 启动 → services 全部拉起 → runtime 可用

AI → `aspire logs api-service` → CLI 拉取运行日志 → 获取 service runtime context → 输入到 MML 进行解析

---

## 2. 可编排层（Orchestration Plane）

AI → 加载 AppHost 定义（Service Graph）→ 解析 service dependency → Aspire 自动构建拓扑 → 启动 service 顺序 → 建立 MCP tool / API 连接关系

示例链路：

AI → 读取 AppHost → service graph（API + Worker + DB）→ Aspire 编排启动 → API service 依赖 DB service → 自动完成连接注入 → MCP tool 被注册为可调用能力

结果：

AI → 获得“结构化系统拓扑（可执行 DAG）”

---

## 3. 可观测层（Observability Plane）

AI → 通过 aspire logs / dashboard / trace API → 获取 OTEL 结构化数据 → 进入 MML（多模态分析层）→ 进行日志语义解析 / 异常检测 / 行为推断

示例链路：

AI → `aspire logs api-service`  
→ 获取 structured logs + trace context  
→ 进入 MML（LLM / multimodal model）  
→ 输出：

- 请求路径分析（API → DB → Tool）
- 延迟瓶颈定位
- 异常行为归因
- MCP tool 调用链重建

---

## 统一闭环（AI → Aspire → MML）

AI → CLI / MCP 调用  
→ Aspire（控制 + 编排 + 运行）  
→ 服务执行（API / Tool / Worker）  
→ OTEL/Logs 输出  
→ MML 解析运行态  
→ AI 得到结构化结论（日志分析 / 系统状态 / 调用路径）

---

## 核心抽象

- 控制层 = AI 驱动系统生命周期
- 编排层 = AI 获取系统结构（DAG）
- 可观测层 = AI 获取系统真实行为数据（runtime truth）

---

# 结果模型

AI 不直接“调用服务”，而是：

AI → 控制 Aspire → 读取编排结构 → 解析运行观测数据 → 在 MML 中形成系统认知 → 再决策下一步行为
---

# 完整闭环：OpenCrabs → Aspire → 结果

## 入口层（任务触发）

用户 / Cron / Channel（Telegram | Discord | Slack | TUI）
  → OpenCrabs Brain 接收任务
  → 匹配 SOUL / AGENTS / TOOLS 规则
  → 决策：需要与 Aspire 运行时交互

---

## 控制层（驱动系统）

Brain → `bash("aspire run")` → AppHost 启动 → 分布式服务图激活  
Brain → `bash("aspire service list")` → 获取当前 service 拓扑  
Brain → `bash("aspire logs <service>")` → 拉取结构化运行日志

---

## 编排层（读取结构）

Brain → 解析 AppHost service graph（DAG）  
→ 识别 service 依赖边（API → DB → Worker → MCP Tool）  
→ spawn_agent(explore, "分析 service 拓扑结构")  
→ 并行子代理只读扫描，主 agent 持续可用

---

## 观测层（获取运行真相）

OTEL 输出（logs / traces / metrics）→ Brain 摄入  

| 数据类型 | Brain 处理 | 写入目标 |
|----------|-----------|----------|
| structured logs | 语义解析 / 异常检测 | MEMORY.md / memory/date |
| trace DAG | 调用链重建 / 瓶颈定位 | session_context |
| metrics | 状态压缩摘要 | task_manager 状态更新 |

---

## 认知层（形成结论）

Brain（MML）→  
- 请求路径分析（API → DB → Tool 全链路）  
- 延迟瓶颈 / 异常归因  
- 下一步行动决策（修复 / 扩容 / 告警 / 再编排）

RSI feedback_ledger ← 本次执行结果（工具成功/失败、推断准确率）

---

## 输出层（结果交付）

Brain → 结构化结论  
→ deliver-to：原始发起 Channel（Telegram | Discord | Slack | TUI）  
→ 可选：cron_results 持久化 / rsi/improvements.md 追加改进记录

---

## 完整链路一览

```
用户任务
  └→ OpenCrabs Brain（SOUL + TOOLS + MEMORY）
       ├→ bash → aspire run/logs/service list     [Control Plane]
       ├→ spawn_agent(explore) → service graph    [Orchestration Plane]
       ├→ OTEL 摄入 → logs/trace/metrics 解析     [Observability Plane]
       ├→ MML 认知层 → 结论 + 下一步决策
       ├→ RSI feedback_ledger ← 执行反馈
       └→ Channel 输出结果 + MEMORY 写入
```

**核心命题：**  
OpenCrabs 不是调用 Aspire 的客户端，而是以 Aspire 为执行基底、将控制 / 编排 / 观测三通道压缩为统一认知输入，再通过 Brain 形成闭合决策环路的自主代理系统。