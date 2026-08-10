#!/bin/bash
# OhMySkills 全量 smoke test
# 用法: bash scripts/smoke-test.sh
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0; WARN=0

check() {
  local desc="$1"; shift
  if "$@" 2>/dev/null; then
    echo "  ✓ $desc"; ((PASS++))
  else
    echo "  ✗ FAIL: $desc"; ((FAIL++))
  fi
}

warn() {
  local desc="$1"; shift
  if "$@" 2>/dev/null; then
    echo "  ✓ $desc"; ((PASS++))
  else
    echo "  ⚠ WARN: $desc"; ((WARN++))
  fi
}

echo "=== OhMySkills Smoke Test ==="
echo ""

SKILLS=(oms-meta oms-qa oms-coding oms-be-coding oms-fe-coding oms-review)

for skill in "${SKILLS[@]}"; do
  SD="$ROOT/skills/$skill"
  echo "--- $skill ---"

  check "  SKILL.md exists" test -f "$SD/SKILL.md"

  if [ -f "$SD/SKILL.md" ]; then
    check "  has description" grep -q "^description:" "$SD/SKILL.md"
    check "  has name" grep -q "^name:" "$SD/SKILL.md"
    check "  has Always Read section" grep -q "Always Read" "$SD/SKILL.md"
    check "  has Session Discipline" grep -q "Session Discipline" "$SD/SKILL.md"
    check "  has Common Tasks" grep -q "Common Tasks" "$SD/SKILL.md"
    check "  has Known Gotchas" grep -q "Known Gotchas" "$SD/SKILL.md"
    check "  has Red Flags" grep -q "Red Flags.*STOP" "$SD/SKILL.md"

    SKILL_LINES=$(wc -l < "$SD/SKILL.md")
    warn "  SKILL.md <= 100 lines (actual: $SKILL_LINES)" test "$SKILL_LINES" -le 100
  fi

  # Check Common Tasks referenced local files exist
  if [ -f "$SD/SKILL.md" ]; then
    refs=$(grep '\`[^`]*\.md\`' "$SD/SKILL.md" | sed 's/.*`\([^`]*\.md\)`.*/\1/' || true)
    while IFS= read -r ref; do
      [ -z "$ref" ] && continue
      case "$ref" in
        *\$*|*\.\./*) continue ;;
      esac
      if test -f "$SD/$ref"; then
        echo "  ✓   referenced: $ref"; ((PASS++))
      else
        echo "  ✗ FAIL: referenced file missing: $ref"; ((FAIL++))
      fi
    done <<< "$refs"
  fi

  # Check rules/
  if [ -d "$SD/rules" ]; then
    for f in "$SD/rules"/*.md; do
      [ -f "$f" ] || continue
      echo "  ✓   rules/$(basename "$f") exists"; ((PASS++))
    done
  fi

  # Check workflows/
  if [ -d "$SD/workflows" ]; then
    for f in "$SD/workflows"/*.md; do
      [ -f "$f" ] || continue
      echo "  ✓   workflows/$(basename "$f") exists"; ((PASS++))
    done
  fi

  # Check gotchas.md
  if [ -f "$SD/references/gotchas.md" ]; then
    echo "  ✓   references/gotchas.md exists"; ((PASS++))
  fi

  echo ""
done

# Shells check
echo "--- shells ---"
for s in AGENTS.md CLAUDE.md CODEX.md GEMINI.md; do
  check "  shells/$s exists" test -f "$ROOT/shells/$s"
done
echo ""

# Hooks check
echo "--- hooks ---"
for f in session-start.sh pre-tool-use.sh hooks.json hooks-cursor.json; do
  check "  hooks/$f exists" test -f "$ROOT/hooks/$f"
done
echo ""

# Protocol blocks check
echo "--- protocol-blocks ---"
for f in rationalizations-table.md red-flags-stop.md subagent-contract.md; do
  check "  protocol-blocks/$f exists" test -f "$ROOT/protocol-blocks/$f"
done
echo ""

# Templates check
echo "--- templates ---"
check "  templates/skill/SKILL.md exists" test -f "$ROOT/templates/skill/SKILL.md"
check "  templates/skill/references/gotchas.md exists" test -f "$ROOT/templates/skill/references/gotchas.md"
check "  templates/skill/workflows/fix-bug.md exists" test -f "$ROOT/templates/skill/workflows/fix-bug.md"
echo ""

# ANTI-TEMPLATES check
echo "--- anti-templates ---"
check "  ANTI-TEMPLATES.md exists" test -f "$ROOT/ANTI-TEMPLATES.md"
echo ""

# Cross-reference integrity
echo "--- cross-reference integrity ---"
for f in "$ROOT/skills/oms-review/references"/*.md; do
  bn=$(basename "$f")
  if grep -q '\$oms-review §[0-9]' "$f" 2>/dev/null; then
    echo "  ✗ FAIL: $bn has stale section references"; ((FAIL++))
  else
    echo "  ✓ $bn references are updated"; ((PASS++))
  fi
done
echo ""

# Workflow Task Anchor check
echo "--- workflow task anchors ---"
for f in "$ROOT/skills"/*/workflows/*.md; do
  bn=$(basename "$f")
  if grep -q "Task Anchor" "$f" 2>/dev/null; then
    echo "  ✓ $bn has Task Anchor"
    ((PASS++))
  else
    echo "  ⚠ WARN: $bn missing Task Anchor"
    ((WARN++))
  fi
done
echo ""

# primary: true check
echo "--- primary skill ---"
primary_count=$(grep -rl "primary: true" "$ROOT/skills"/*/SKILL.md 2>/dev/null | wc -l)
if [ "$primary_count" -eq 1 ]; then
  echo "  ✓ exactly 1 primary skill (oms-meta)"
  ((PASS++))
else
  echo "  ⚠ WARN: $primary_count primary skills (expected 1)"
  ((WARN++))
fi
echo ""

echo "=== Result: $PASS passed, $WARN warnings, $FAIL failed ==="

[ "$FAIL" -gt 0 ] && echo "FIX: $FAIL check(s) failed." && exit 1
echo "OK: All checks passed."
exit 0