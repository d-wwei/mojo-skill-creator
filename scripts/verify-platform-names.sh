#!/usr/bin/env bash
# verify-platform-names.sh — Detects platform-specific tool names used as instructions.
# Usage: ./scripts/verify-platform-names.sh <skill-directory>
# Returns 0 if clean, 1 if platform-specific tool names found in instructions.

set -euo pipefail

SKILL_DIR="${1:-.}"
FAIL=0

# Platform-specific tool names that should be semantic verbs instead.
# Pattern: word boundary + tool name + word boundary, in instruction context.
# Excludes: prose references ("the Bash tool"), filenames, code examples.
TOOL_NAMES="\\b(Bash|Edit|Write|Read|Grep|Glob|WebFetch|WebSearch|Agent|NotebookEdit)\\b"

# Files to scan: SKILL.md and references/
FILES=()
[ -f "$SKILL_DIR/SKILL.md" ] && FILES+=("$SKILL_DIR/SKILL.md")
if [ -d "$SKILL_DIR/references" ]; then
    for f in "$SKILL_DIR/references"/*.md; do
        [ -f "$f" ] && FILES+=("$f")
    done
fi

if [ ${#FILES[@]} -eq 0 ]; then
    echo "WARN: No skill files found in $SKILL_DIR"
    exit 0
fi

# Scan for tool names used as imperative instructions.
# Heuristic: line starts with or contains "Use X", "Run X", "Call X", or "X tool"
for f in "${FILES[@]}"; do
    BASENAME=$(basename "$f")
    HITS=$(grep -nE "(Use |Run |Call |Invoke )$TOOL_NAMES|$TOOL_NAMES tool" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
        echo "FAIL: $BASENAME contains platform-specific tool references:"
        echo "$HITS" | head -5
        FAIL=1
    fi
done

if [ $FAIL -eq 0 ]; then
    echo "PASS: No platform-specific tool names found in instructions"
fi

exit $FAIL
