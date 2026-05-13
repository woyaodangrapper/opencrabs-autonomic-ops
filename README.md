

<p align="center">
	<img src="docs/images/logo.svg" alt="OpenCrabs Logo" width="120"/>
</p>

# 🧬 OpenCrabs Autonomic Ops

```mermaid
flowchart TD

A[用户输入] --> B[主代理 qwen3:8b]

B --> C[轻量 Brain Files<br/>规则解析 / 意图理解 / 事件识别]

C --> D{复杂度判断}

D -->|简单| E[直接执行 qwen3:8b<br/>文本处理 / 事件处理 / 拓扑理解 / 诊断辅助]

D -->|复杂| F[multi-agent + policy store（能力路由 + 决策）]

F --> G[子代理A：规划器<br/>subagent_provider → gpt-5.5]

F --> H[子代理B：执行器<br/>subagent_provider → qwen3:8b]

F --> I[子代理C：工具/检索代理]

G --> X{是否需要拆解?}

X -->|否（误判复杂）| E

X -->|是| J[A2A 协同通信]

H --> J
I --> J

J --> K[Multi-Profile 调度层（领域专家选择）]

K --> P1[领域专家A：Ops Profile]
K --> P2[领域专家B：Research Profile]
K --> P3[领域专家C：Coding Profile]

P1 --> L[结果汇总与合并]
P2 --> L
P3 --> L

L --> M[split-panes 多窗口展示]

M --> N[最终输出 + policy store 更新（反馈回写）]

%% ===== P0 ISSUE TAGS =====
B -.-> R1[🟥 ROUTER-UNCERTAINTY]
C -.-> R2[🟥 STATE-FRAGMENTATION]
F -.-> R3[🟥 STATE-FRAGMENTATION]
J -.-> R4[🟥 STATE-FRAGMENTATION]
K -.-> R5[🟥 STATE-FRAGMENTATION]
N -.-> R6[🟥 POLICY-DRIFT]
```
---
# 崩溃节点优先级（按系统风险排序）

| 优先级 | 节点 | 崩溃强度 | 影响范围 | 为什么优先 |
|--------|------|----------|----------|------------|
| P0 | Router (qwen3:8b) | 极高 | 全系统 | 所有任务分发入口，错误会被指数级放大 |
| P0 | System State Graph | 极高 | 全系统 | 状态不一致会导致所有 agent 决策基准错误 |
| P1 | Execution Layer | 高 | 生产环境 | 不可回滚操作直接造成不可逆损害 |
| P1 | Policy Store | 高 | 长期系统行为 | 错误策略会自我强化导致系统退化 |
| P2 | A2A / Multi-Agent | 中-高 | 局部爆炸 | 主要导致复杂度失控，但不一定立即破坏系统 |
---
