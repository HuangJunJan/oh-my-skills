#!/bin/bash
# oms-coding smoke test — 结构完整性自检
# 用法: bash skills/oms-coding/scripts/smoke-test.sh
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

check() {
  local desc="$1"; shift
  if "$@"; then
    echo "  ✓ $desc"
    ((PASS++))
  else
    echo "  ✗ $desc"
    ((FAIL++))
  fi
}

echo "=== oms-coding smoke test ==="
echo ""

# SKILL.md 检查
SKILL_MD="$SKILL_DIR/SKILL.md"
check "SKILL.md exists" test -f "$SKILL_MD"

echo "--- SKILL.md structure ---"
check "  has Always Read" grep -q "Always Read" "$SKILL_MD"
check "  has Common Tasks" grep -q "Common Tasks" "$SKILL_MD"
check "  has Known Gotchas" grep -q "Known Gotchas" "$SKILL_MD"
check "  has Red Flags" grep -q "Red Flags.*STOP" "$SKILL_MD"
check "  has Session Discipline" grep -q "Session Discipline" "$SKILL_MD"

SKILL_LINES=$(wc -l < "$SKILL_MD")
check "  SKILL.md <= 80 lines (actual: $SKILL_LINES)" test "$SKILL_LINES" -le 80

echo "--- rules/ files ---"
for f in code-quality.md sensitive.md debugging.md fix-strategy.md verification.md workflow.md; do
  check "  rules/$f exists" test -f "$SKILL_DIR/rules/$f"
done

echo "--- workflows/ files ---"
for f in fix-bug.md add-feature.md; do
  check "  workflows/$f exists" test -f "$SKILL_DIR/workflows/$f"
done

echo "--- Common Tasks references exist ---"
while IFS= read -r line; do
  file=$(echo "$line" | sed -n 's/.*`\([^`]*\.md\)`.*/\1/p')
  if [ -n "$file" ] && [ "$file" != "domain rules" ]; then
    for f in $file; do
      check "  referenced: $f" test -f "$SKILL_DIR/$f"
    done
  fi
done < <(grep '`.*\.md`' "$SKILL_MD")

echo ""
echo "=== Result: $PASS passed, $FAIL failed ==="
exit $FAIL
