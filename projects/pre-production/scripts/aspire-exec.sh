#!/bin/bash
# aspire-exec.sh — 通过 aspire ps 动态解析 AppHost 路径，再执行任意 aspire 子命令
# 用法: aspire-exec.sh <subcommand> [args...]
# 部署: cp opencrabs/aspire-exec.sh ~/.opencrabs/aspire-exec.sh && chmod +x ~/.opencrabs/aspire-exec.sh

set -e

APPHOST=$(aspire ps --format Json --non-interactive 2>/dev/null \
  | grep '"appHostPath"' \
  | sed 's/.*"appHostPath": "\(.*\)".*/\1/' \
  | head -1)

if [ -z "$APPHOST" ]; then
  echo "[aspire-exec] ERROR: 未找到运行中的 AppHost，请先执行 'aspire run'" >&2
  exit 1
fi

echo "[aspire-exec] AppHost: $APPHOST" >&2
exec aspire "$@" --apphost "$APPHOST" --non-interactive
