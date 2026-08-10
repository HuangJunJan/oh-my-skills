#!/bin/bash
# PreToolUse hook — 在 Agent 编辑核心规则文件前过一道闸
# 用法：由 harness 在 pre-tool-use 事件时调用，传入工具名和参数
# 退出码：0 = 放行，非 0 = 拦截

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# 被编辑的文件路径（从参数或 stdin 获取）
TARGET_FILE="${1:-}"
if [ -z "$TARGET_FILE" ]; then
  # 尝试从 stdin 读取 JSON 格式的 toolUse 参数（Claude Code 格式）
  TARGET_FILE=$(jq -r '.input?.path? // .args?.path? // empty' 2>/dev/null) || true
fi

# 决议为绝对路径
if [ -n "$TARGET_FILE" ] && [ ! -f "$TARGET_FILE" ]; then
  # 可能是相对路径，相对 ROOT 解析
  if [ -f "$ROOT/$TARGET_FILE" ]; then
    TARGET_FILE="$ROOT/$TARGET_FILE"
  fi
fi

# 定义保护路径（核心规则文件，不允许越权修改）
PROTECTED_PATTERNS=(
  "rules/priority.md"
  "rules/evidence-integrity.md"
  "rules/skill-maintenance.md"
  "SKILL.md"
)

# 检查是否命中保护路径
is_protected=0
for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if echo "$TARGET_FILE" | grep -q "$pattern" 2>/dev/null; then
    is_protected=1
    break
  fi
done

if [ "$is_protected" -eq 0 ]; then
  # 不在保护列表，放行
  exit 0
fi

# 检查文件是否在 skills/ 目录下
if ! echo "$TARGET_FILE" | grep -q "/skills/" 2>/dev/null; then
  # 不在 skills/ 目录，放行
  exit 0
fi

# 检查文件行数（只允许在合理范围内修改）
if [ -f "$TARGET_FILE" ]; then
  lines=$(wc -l < "$TARGET_FILE")

  # SKILL.md 超过 100 行不允许再增加
  if echo "$TARGET_FILE" | grep -q "SKILL.md$" 2>/dev/null; then
    if [ "$lines" -gt 100 ]; then
      echo "BLOCKED: SKILL.md 已超过 100 行（当前 $lines 行），不允许再增加。请先合并或拆分。" >&2
      exit 2
    fi
  fi
fi

exit 0