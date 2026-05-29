#!/usr/bin/env bash
# verify-secrets-safe.sh — Conservative scan for high-confidence secrets.
# Usage: ./scripts/verify-secrets-safe.sh [directory]

set -euo pipefail

ROOT="${1:-.}"
FAIL=0
HIT_FILE="$(mktemp "${TMPDIR:-/tmp}/msc-secret-hit.XXXXXX")"
trap 'rm -f "$HIT_FILE"' EXIT

PATTERN='(AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|DSA|EC|PRIVATE) KEY-----|sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{20,}|Bearer[[:space:]]+[A-Za-z0-9._-]{20,})'

while IFS= read -r file; do
    if grep -InE "$PATTERN" "$file" >"$HIT_FILE" 2>/dev/null; then
        echo "FAIL: possible secret in $file"
        cat "$HIT_FILE"
        FAIL=1
    fi
done < <(find "$ROOT" \
    -path "$ROOT/.git" -prune -o \
    -path "$ROOT/se-workspace" -prune -o \
    -type f \
    ! -name '*.png' ! -name '*.jpg' ! -name '*.jpeg' ! -name '*.gif' ! -name '*.pdf' \
    -print)

if [ "$FAIL" -eq 0 ]; then
    echo "PASS: No high-confidence secrets found"
fi

exit "$FAIL"
