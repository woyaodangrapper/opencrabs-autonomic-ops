#!/usr/bin/env bash
# deploy.sh — pre-production 主部署入口
# 位置：projects/pre-production/deploy.sh
#
# 流程：
#   1. 检查 opencrabs 二进制 → 不存在则执行构建并等待
#   2. 检查 ~/.opencrabs/ → 不存在代表子代理未初始化，
#      将 pre-production/ 下除 scripts/ 之外的所有文件复制过去
#
# 用法（从任意目录，WSL/Linux 环境）：
#   bash projects/pre-production/deploy.sh
# 覆盖参数（可选）：
#   OPENCRABS_ROOT=/path/to/.opencrabs bash deploy.sh


set -euo pipefail

# ─── 颜色 ──────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()  { echo -e "${BOLD}[info]${RESET}  $*"; }
ok()    { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${RESET}  $*"; }
error() { echo -e "${RED}[error]${RESET} $*"; exit 1; }

# ─── 路径解析 ─────────────────────────────────────────
# 脚本位置：projects/pre-production/deploy.sh
# 仓库根目录 = ../../  (pre-production → projects → repo root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PRE_PROD_DIR="$SCRIPT_DIR"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

BINARY="$REPO_ROOT/opencrabs/target/release/opencrabs"
BUILD_SETUP_DIR="$REPO_ROOT/opencrabs/src/scripts"
OPENCRABS_ROOT="${OPENCRABS_ROOT:-$HOME/.opencrabs}"

info "仓库根目录：  $REPO_ROOT"
info "pre-production：$PRE_PROD_DIR"
info "部署目标：    $OPENCRABS_ROOT"
echo ""

# ═══════════════════════════════════════════════════════
# 第一步：二进制检查 → 不存在则构建
# ═══════════════════════════════════════════════════════
if [ -f "$BINARY" ]; then
    ok "二进制已存在：$BINARY"
else
    warn "未找到二进制，开始构建..."


    if [ ! -d "$BUILD_SETUP_DIR" ]; then
        error "构建脚本目录不存在：$BUILD_SETUP_DIR"
    fi

    for script in setup.sh install.sh; do
        if [ -f "$BUILD_SETUP_DIR/$script" ]; then
            info "安装系统依赖：$BUILD_SETUP_DIR/$script"
            bash "$BUILD_SETUP_DIR/$script"
        else
            warn "未找到构建脚本：$BUILD_SETUP_DIR/$script，跳过"
        fi
    done

    info "执行 cargo build --release..."
    export PATH="$HOME/.cargo/bin:$PATH"
    # 切换到 opencrabs 目录（即 opencrabs/）
    pushd "$REPO_ROOT/opencrabs/" > /dev/null
    cargo build --release
    popd > /dev/null

    if [ ! -f "$BINARY" ]; then
        error "构建后仍未找到二进制：$BINARY"
    fi

    ok "构建完成：$BINARY"
fi

echo ""

# ═══════════════════════════════════════════════════════
# 第二步：~/.opencrabs/ 检查 → 不存在则初始化 profiles
# ═══════════════════════════════════════════════════════
if [ -d "$OPENCRABS_ROOT" ]; then
    ok "~/.opencrabs/ 已存在 — 子代理已初始化，跳过 profiles 复制"
    echo ""
    echo "若需强制重新部署指定 profile，使用各 profile 下的 scripts/deploy.sh："
    echo "  bash $PRE_PROD_DIR/profiles/laborer/scripts/deploy.sh"

    # ─── 交互询问是否启动 OCAO ─────────────────────────────
    read -p "是否立即启动 opencrabs-autonomic-ops (OCAO)? [y/N]: " start_ocao
    if [[ "$start_ocao" =~ ^[Yy]$ ]]; then
        echo "\n[info] 启动 opencrabs-autonomic-ops...\n"
        "$BINARY"
    fi

    exit 0
fi

warn "~/.opencrabs/ 不存在 — 子代理未初始化，开始复制 pre-production 内容..."
echo ""

mkdir -p "$OPENCRABS_ROOT"
info "目标目录已创建：$OPENCRABS_ROOT"

# 将 pre-production/ 下除 scripts/ 之外的所有内容复制至 ~/.opencrabs/
while IFS= read -r -d '' item; do
    rel="${item#"$PRE_PROD_DIR"/}"
    # 跳过 scripts/ 目录本身及其所有子项
    case "$rel" in
        scripts|scripts/*) continue ;;
    esac
    dst="$OPENCRABS_ROOT/$rel"
    if [ -d "$item" ]; then
        mkdir -p "$dst"
    else
        mkdir -p "$(dirname "$dst")"
        cp "$item" "$dst"
        echo "  [复制] $rel"
    fi
done < <(find "$PRE_PROD_DIR" -mindepth 1 -print0)

# keys.toml 权限加固（递归查找）
while IFS= read -r -d '' kf; do
    chmod 600 "$kf"
    echo "  [chmod 600] ${kf#"$OPENCRABS_ROOT"/}"
done < <(find "$OPENCRABS_ROOT" -name "keys.toml" -type f -print0)

# ═══════════════════════════════════════════════════════
echo ""
ok "初始化完成：$OPENCRABS_ROOT"
echo ""
echo "后续步骤："
echo "  opencrabs profile list"
echo "  opencrabs -p laborer chat"
echo "  opencrabs -p laborer daemon"
echo ""
echo "注册 Cron 任务（参考各 profile 下 cron-tasks.toml.example）："
echo "  opencrabs -p laborer cron list"

# ─── 交互询问是否启动 OCAO ─────────────────────────────
read -p "是否立即启动 opencrabs-autonomic-ops (OCAO)? [y/N]: " start_ocao
if [[ "$start_ocao" =~ ^[Yy]$ ]]; then
    echo "\n[info] 启动 opencrabs-autonomic-ops...\n"
    "$BINARY"
fi
