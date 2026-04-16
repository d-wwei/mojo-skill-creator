#!/usr/bin/env bash
# verify-artifact-content.sh — Checks artifact files contain required sections/items.
# Usage: ./scripts/verify-artifact-content.sh <artifact-path> <check-type>
# Check types:
#   domain-research  — ≥5 source entries
#   red-lines        — ≥5 red line items + acceptance criteria section + stance section
#   enforcement-plan — enforcement classification table + ≥30% Do-axis ratio
#   constraint-audit — enforcement ratio present + ≥3 upgrade candidates (or justified fewer)
#   validation       — ≥8 checklist items
# Returns 0 if pass, 1 if fail.

set -euo pipefail

FILE="${1:-}"
CHECK="${2:-}"

if [ -z "$FILE" ] || [ -z "$CHECK" ]; then
    echo "Usage: $0 <artifact-path> <check-type>"
    echo "Types: domain-research | red-lines | enforcement-plan | validation"
    exit 2
fi

if [ ! -f "$FILE" ]; then
    echo "FAIL: File does not exist: $FILE"
    exit 1
fi

FAIL=0

case "$CHECK" in
    domain-research)
        # Count source entries (lines starting with ### or ## that look like source headers,
        # or numbered items with source-like content)
        COUNT=$(grep -cE '^\#{2,3} .*(Source|source|[0-9]+\.)' "$FILE" 2>/dev/null || echo 0)
        # Fallback: count lines with "Name:" or "Key finding:" patterns
        if [ "$COUNT" -lt 5 ]; then
            COUNT=$(grep -ciE '(name:|source:|key finding|implication)' "$FILE" 2>/dev/null || echo 0)
            COUNT=$((COUNT / 2))  # Rough: each source has ~2 matching lines
        fi
        if [ "$COUNT" -lt 5 ]; then
            echo "FAIL: domain-research has ~${COUNT} sources (need ≥5)"
            FAIL=1
        else
            echo "PASS: domain-research has ~${COUNT} sources (need ≥5)"
        fi
        ;;
    red-lines)
        RL_COUNT=$(grep -cE '^- .*\b(No |Never |Must not )' "$FILE" 2>/dev/null || echo 0)
        if [ "$RL_COUNT" -lt 5 ]; then
            echo "FAIL: red-lines has ${RL_COUNT} items (need ≥5)"
            FAIL=1
        else
            echo "PASS: red-lines has ${RL_COUNT} items (need ≥5)"
        fi
        # Check for acceptance criteria section
        if ! grep -qiE '(acceptance|criteria)' "$FILE" 2>/dev/null; then
            echo "FAIL: no Acceptance Criteria section found"
            FAIL=1
        else
            echo "PASS: Acceptance Criteria section found"
        fi
        # Check for stance section
        if ! grep -qiE '(stance)' "$FILE" 2>/dev/null; then
            echo "FAIL: no Stance section found"
            FAIL=1
        else
            echo "PASS: Stance section found"
        fi
        ;;
    enforcement-plan)
        # Must contain a classification table with Think/Do mentions
        if ! grep -qE '(Think|Do).*\|' "$FILE" 2>/dev/null; then
            echo "FAIL: no Think/Do classification table found"
            FAIL=1
        else
            echo "PASS: Think/Do classification table found"
        fi
        # Check ≥30% Do-axis ratio
        TOTAL_ROWS=$(grep -cE '\|.*\|.*\|' "$FILE" 2>/dev/null || echo 0)
        DO_ROWS=$(grep -ciE '\|.*Do.*\|' "$FILE" 2>/dev/null || echo 0)
        if [ "$TOTAL_ROWS" -gt 0 ]; then
            RATIO=$((DO_ROWS * 100 / TOTAL_ROWS))
            if [ "$RATIO" -lt 30 ]; then
                echo "FAIL: Do-axis ratio is ${RATIO}% (need ≥30%). ${DO_ROWS}/${TOTAL_ROWS} rows."
                FAIL=1
            else
                echo "PASS: Do-axis ratio is ${RATIO}% (≥30%). ${DO_ROWS}/${TOTAL_ROWS} rows."
            fi
        fi
        ;;
    constraint-audit)
        # Must contain enforcement ratio
        if ! grep -qiE '(enforcement ratio|enforcement.*[0-9]+%)' "$FILE" 2>/dev/null; then
            echo "FAIL: no enforcement ratio found"
            FAIL=1
        else
            echo "PASS: enforcement ratio found"
        fi
        # Must identify upgrade candidates (≥3 or justified fewer)
        CANDIDATES=$(grep -ciE '(upgrade candidate|highest.stakes|top [0-9])' "$FILE" 2>/dev/null || echo 0)
        if [ "$CANDIDATES" -lt 1 ]; then
            echo "FAIL: no upgrade candidates section found"
            FAIL=1
        else
            echo "PASS: upgrade candidates section found (${CANDIDATES} references)"
        fi
        ;;
    validation)
        ITEMS=$(grep -cE '^\s*-\s*\[[ x]\]' "$FILE" 2>/dev/null || echo 0)
        if [ "$ITEMS" -lt 8 ]; then
            echo "FAIL: validation has ${ITEMS} checklist items (need ≥8)"
            FAIL=1
        else
            echo "PASS: validation has ${ITEMS} checklist items (need ≥8)"
        fi
        ;;
    *)
        echo "Unknown check type: $CHECK"
        exit 2
        ;;
esac

exit $FAIL
