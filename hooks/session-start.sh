#!/bin/bash
# SessionStart hook — 在 startup / clear / compact 事件后自动重注 SKILL.md
# 用法：由 harness 在 session-start 事件时调用
# 输出：JSON 格式的 additionalContext 供 harness 注入

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# 定位 primary: true 的 SKILL.md（多 skill 项目必须有且仅有一个 primary）
skill_md=$(grep -rl 'primary: true' "$ROOT/skills"/*/SKILL.md 2>/dev/null | head -1)

if [ -z "$skill_md" ]; then
  # 没有 primary 标记，取 oms-meta（默认元 skill）
  skill_md="$ROOT/skills/oms-meta/SKILL.md"
fi

if [ ! -f "$skill_md" ]; then
  echo '{"error": "no SKILL.md found"}'
  exit 1
fi

# 读 SKILL.md 内容
content=$(cat "$skill_md" | jq -Rs .)

# 按 harness 输出不同字段名
HARNESS="${HARNESS:-unknown}"

case "$HARNESS" in
  claude-code)
    echo "{\"hookSpecificOutput\": $content}"
    ;;
  cursor)
    echo "{\"additional_context\": $content}"
    ;;
  *)
    echo "{\"additionalContext\": $content}"
    ;;
esac