#!/usr/bin/env bash
# verify-behavior-fixtures.sh — Checks platform-behavior snapshot fixtures.
# Usage: ./scripts/verify-behavior-fixtures.sh [skill-directory]

set -euo pipefail

SKILL_DIR="${1:-.}"
FIXTURE_DIR="$SKILL_DIR/docs/specs/fixtures/codex-portable-enforcement"
FAIL=0

require_file() {
    if [ ! -f "$1" ]; then
        echo "FAIL: missing fixture: $1"
        FAIL=1
    fi
}

require_pattern() {
    local file="$1"
    local pattern="$2"
    local desc="$3"
    if ! grep -Eiq "$pattern" "$file"; then
        echo "FAIL: $desc"
        echo "  file: $file"
        FAIL=1
    fi
}

reject_pattern() {
    local file="$1"
    local pattern="$2"
    local desc="$3"
    if grep -Eiq "$pattern" "$file"; then
        echo "FAIL: $desc"
        echo "  file: $file"
        FAIL=1
    fi
}

CODEX="$FIXTURE_DIR/codex-new-expected.md"
CLAUDE="$FIXTURE_DIR/claude-code-new-expected.md"
PORTABLE="$FIXTURE_DIR/portable-boost-expected.md"

require_file "$CODEX"
require_file "$CLAUDE"
require_file "$PORTABLE"

if [ "$FAIL" -eq 0 ]; then
    require_pattern "$CODEX" "Codex-targeted" "Codex fixture must name Codex-targeted behavior"
    require_pattern "$CODEX" "artifact gates?.*validation scripts?|validation scripts?.*artifact gates?" "Codex fixture must prefer artifact/script enforcement"
    require_pattern "$CODEX" "Avoid requiring Claude Code hooks" "Codex fixture must explicitly reject required Claude hooks"
    require_pattern "$CODEX" "~/.codex/skills/.*~/.agents/skills/|~/.agents/skills/.*~/.codex/skills/" "Codex fixture must document both Codex skill roots"
    reject_pattern "$CODEX" "(must|required|requires)[^.\n]*(PreToolUse|Claude Code hooks?|hook installation)" "Codex fixture must not require Claude hook enforcement"

    require_pattern "$CLAUDE" "Claude Code-targeted" "Claude fixture must name Claude Code-targeted behavior"
    require_pattern "$CLAUDE" "optional blocking enforcement" "Claude fixture must keep hooks optional"
    require_pattern "$CLAUDE" "PreToolUse" "Claude fixture must preserve hook terminology"
    require_pattern "$CLAUDE" "fallback" "Claude fixture must require portable fallback guidance"

    require_pattern "$PORTABLE" "Portable core defects" "Portable fixture must distinguish portable core defects"
    require_pattern "$PORTABLE" "Adapter recommendations" "Portable fixture must distinguish adapter recommendations"
    require_pattern "$PORTABLE" "should not mark a portable skill incomplete only because it lacks Claude Code hooks" "Portable fixture must not require Claude hooks"
fi

if [ "$FAIL" -eq 0 ]; then
    echo "PASS: Behavior fixtures match expected platform boundaries"
fi

exit "$FAIL"
