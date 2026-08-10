#!/bin/bash
# Test trigger — 验证 skill description 的语义命中率
# 用法: bash scripts/test-trigger.sh [skill-name]
# 从 Common Tasks 自动生成真实用户提示词，模拟命中测试
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_SKILL="${1:-}"

echo "=== OhMySkills Trigger Test ==="
echo ""

# 从每个 SKILL.md 提取 description 和 Common Tasks
for skill_dir in "$ROOT"/skills/oms-*/; do
  skill_name=$(basename "$skill_dir")
  [ -n "$TARGET_SKILL" ] && [ "$skill_name" != "$TARGET_SKILL" ] && continue

  echo "--- $skill_name ---"

  skill_md="$skill_dir/SKILL.md"
  if [ ! -f "$skill_md" ]; then
    echo "  ⚠ SKILL.md not found"
    continue
  fi

  # 提取 description
  desc=$(grep -A1 "^description:" "$skill_md" | tail -1 | sed 's/^ *> *//; s/^ *//; s/ *$//' 2>/dev/null || true)
  echo "  Description: ${desc:0:80}..."

  # 从 Common Tasks 提取任务关键词
  tasks=$(grep -E "^\| .*\|.*\|.*\|" "$skill_md" | grep -v "任务\|Task\|------" | awk -F'|' '{print $2}' | sed 's/^ *//; s/ *$//' || true)

  echo "  Trigger phrases from Common Tasks:"
  while IFS= read -r task; do
    [ -z "$task" ] && continue
    echo "    • \"$task\" → 应命中 $skill_name"
  done <<< "$tasks"

  echo ""
done

echo "=== 说明 ==="
echo "以上是每个 skill 的 description 和 Common Tasks 列出的任务类型。"
echo "在真实使用中，用以下方式手动测试命中率："
echo ""
echo "  prompt = \"请修一下这个空指针异常\" → 期望命中 oms-coding"
echo "  prompt = \"帮我审查这个 PR\" → 期望命中 oms-review"
echo "  prompt = \"加一个新接口 /api/users\" → 期望命中 oms-coding + oms-be-coding"
echo ""
echo "如果连续 3 次同一个 prompt 都没命中目标 skill，需要优化 description 的关键词覆盖。"