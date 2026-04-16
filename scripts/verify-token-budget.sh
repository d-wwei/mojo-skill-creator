#!/usr/bin/env bash
# verify-token-budget.sh — Enforces word count limits on produced skill files.
# Usage: ./scripts/verify-token-budget.sh <skill-directory>
# Returns 0 if all files within budget, 1 if any exceed limits.

set -euo pipefail

SKILL_DIR="${1:-.}"
FAIL=0

# Check SKILL.md body (excluding frontmatter) — limit: 2000 words
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    BODY_WORDS=$(sed '/^---$/,/^---$/d' "$SKILL_DIR/SKILL.md" | wc -w | tr -d ' ')
    if [ "$BODY_WORDS" -gt 2000 ]; then
        echo "FAIL: SKILL.md body is ${BODY_WORDS}w (limit: 2000w)"
        FAIL=1
    else
        echo "PASS: SKILL.md body is ${BODY_WORDS}w (limit: 2000w)"
    fi
else
    echo "WARN: No SKILL.md found in $SKILL_DIR"
fi

# Check each references/*.md — limit: 2000 words per file
if [ -d "$SKILL_DIR/references" ]; then
    for f in "$SKILL_DIR/references"/*.md; do
        [ -f "$f" ] || continue
        WORDS=$(wc -w < "$f" | tr -d ' ')
        BASENAME=$(basename "$f")
        if [ "$WORDS" -gt 2000 ]; then
            echo "FAIL: references/$BASENAME is ${WORDS}w (limit: 2000w)"
            FAIL=1
        else
            echo "PASS: references/$BASENAME is ${WORDS}w (limit: 2000w)"
        fi
    done
fi

exit $FAIL
