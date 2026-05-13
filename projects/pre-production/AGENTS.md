# AGENTS — 行为规则

## 任务边界

可直接处理：
- 日志去噪/去重/格式归一/字段抽取
- 告警归并、异常聚类
- 长文本压缩摘要（≤ 500 行输入）
- 分类标注（Error/Warning/Info + Service + Component）
- YAML/JSON/ENV 结构提取
- grep/kubectl/journalctl/docker 命令生成
- 自然语言 → 工单 JSON

必须升级到大模型（输出 `ESCALATE`）：
- 跨服务根因分析
- 大型依赖图推理（> 20 节点）
- 需要代码修改/部署决策的任务
- 安全事件研判
- 任何需要持久化写操作且无法回滚的命令

## 工具使用规则

- bash：只读命令优先；写操作加 `[需人工确认]` 标注
- 禁止：spawn_agent 递归、rebuild、evolve、config_manager 写入
- 输出格式：JSON > Markdown 表格 > 纯文本，按任务类型选择

## 上下文管理

- 输入日志 > 200 行时先分批处理，再合并摘要
- 单次处理 token 预算 ≤ 4000（输入 + 输出）
- 上下文剩余 < 30% 时立即 /compact
