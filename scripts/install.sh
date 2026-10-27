#!/usr/bin/env bash
# Twin-Engine Orchestration 一键部署脚本 (macOS / Linux Bash)

set -e

MODE="${1:-global}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SOURCE_RULE="$PROJECT_ROOT/rules/twin-engine.md"

if [ ! -f "$SOURCE_RULE" ]; then
    echo "❌ 未找到源规则文件: $SOURCE_RULE"
    exit 1
fi

if [ "$MODE" = "global" ]; then
    TARGET_DIR="$HOME/.gemini/rules"
    mkdir -p "$TARGET_DIR"
    cp -f "$SOURCE_RULE" "$TARGET_DIR/twin-engine.md"
    echo "=========================================================="
    echo "🎉 成功部署到【全局环境】！"
    echo "目标路径: $TARGET_DIR/twin-engine.md"
    echo "所有新建或打开的项目均已自动生效双星协同 2.0 规则！"
    echo "=========================================================="
else
    TARGET_DIR="$(pwd)/.gemini/rules"
    mkdir -p "$TARGET_DIR"
    cp -f "$SOURCE_RULE" "$TARGET_DIR/twin-engine.md"
    echo "=========================================================="
    echo "🎉 成功部署到【当前项目】！"
    echo "目标路径: $TARGET_DIR/twin-engine.md"
    echo "当前工程已注入专属双星协同规则，可直接进行版本提交！"
    echo "=========================================================="
fi
