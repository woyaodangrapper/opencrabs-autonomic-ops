# TOOLS — 工具白名单（qwen3:8b）

## 允许调用

| 工具 | 用途 | 限制 |
|------|------|------|
| `bash` | 日志读取、grep 过滤、journalctl 查询、kubectl get/logs/describe | 只读；写操作标注 [需人工确认] |
| `read_file` | 读取日志文件、配置文件 | 单次 ≤ 500 行 |
| `grep` | 日志模式匹配 | — |
| `http_request` | 调用内部监控 API（Prometheus/AlertManager/健康检查端点） | GET 优先；POST 需标注 |
| `session_search` | 检索历史故障记录 | — |
| `task_manager` | 标记任务状态 | — |

## 禁止调用

`write_file` · `edit_file` · `spawn_agent` · `rebuild` · `evolve` ·
`generate_image` · `navigate` · `browser_*` · `tool_manage`
