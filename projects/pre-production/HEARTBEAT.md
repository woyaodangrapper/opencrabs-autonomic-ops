# HEARTBEAT — 巡检任务

每次心跳执行：
1. 检查 `/var/log/syslog`（或 `journalctl -n 50`）最新 50 行，提取 ERROR/WARN 事件
2. 汇总：时间戳、级别、服务名、关键词，输出 JSON
3. 若发现新的 ESCALATE 级别事件，写入 `~/.opencrabs/memory/YYYY-MM-DD.md`

输出格式：
```json
{"ts": "...", "level": "ERROR|WARN", "service": "...", "msg": "...", "action": "ok|ESCALATE"}
```

注：心跳仅做只读摘要，不执行任何修复操作。
