#!/usr/bin/env bash
# verify-token-budget.sh — Enforces word count limits on produced skill files.
# Usage: ./scripts/verify-token-budget.sh <skill-directory>
# Returns 0 if all files within budget, 1 if any exceed limits.

set -euo pipefail

SKILL_DIR="${1:-.}"
FAIL=0

skill_body_words() {
    awk '
        NR == 1 && $0 == "---" { in_frontmatter = 1; next }
        in_frontmatter && $0 == "---" { in_frontmatter = 0; next }
        !in_frontmatter { print }
    ' "$1" | wc -w | tr -d ' '
}

# Check SKILL.md body (excluding frontmatter) — limit: 2000 words
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    BODY_WORDS=$(skill_body_words "$SKILL_DIR/SKILL.md")
    if [ "$BODY_WORDS" -gt 2000 ]; then
        echo "FAIL: SKILL.md body is ${BODY_WORDS}w (limit: 2000w)"
        FAIL=1
    else
        echo "PASS: SKILL.md body is ${BODY_WORDS}w (limit: 2000w)"
    fi
else
    echo "WARN: No SKILL.md found in $SKILL_DIR"
fi

# Check each references/**/*.md — limit: 2000 words per file
if [ -d "$SKILL_DIR/references" ]; then
    while IFS= read -r f; do
        WORDS=$(wc -w < "$f" | tr -d ' ')
        REL="${f#"$SKILL_DIR"/}"
        if [ "$WORDS" -gt 2000 ]; then
            echo "FAIL: ${REL} is ${WORDS}w (limit: 2000w)"
            FAIL=1
        else
            echo "PASS: ${REL} is ${WORDS}w (limit: 2000w)"
        fi
    done < <(find "$SKILL_DIR/references" -type f -name '*.md' | sort)
fi

exit $FAIL
