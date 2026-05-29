#!/usr/bin/env bash
# verify-platform-names.sh — Detects platform-specific tool names used as portable instructions.
# Usage: ./scripts/verify-platform-names.sh [--verbose] <skill-directory>
# Returns 0 if clean, 1 if platform-specific tool names appear in portable instructions.

set -euo pipefail

VERBOSE=0
if [ "${1:-}" = "--verbose" ]; then
    VERBOSE=1
    shift
fi

SKILL_DIR="${1:-.}"
FAIL=0

TOOL_NAMES="(Bash|Edit|Write|Read|Grep|Glob|WebFetch|WebSearch|Agent|NotebookEdit|PreToolUse|run_shell_command|read_file|write_file|grep_search|glob|google_web_search|web_fetch|spawn_agent|TaskCreate|write_todos|replace)"
IMPERATIVE="\\b(use|run|call|invoke|via|using|dispatch|launch)[[:space:]]+(the[[:space:]]+)?${TOOL_NAMES}\\b|\\b(must|should|always)[[:space:]]+use[[:space:]]+(the[[:space:]]+)?${TOOL_NAMES}\\b|\\b${TOOL_NAMES}\\b[[:space:]]+tool"

FILES=()
[ -f "$SKILL_DIR/SKILL.md" ] && FILES+=("$SKILL_DIR/SKILL.md")
if [ -d "$SKILL_DIR/references" ]; then
    while IFS= read -r f; do
        FILES+=("$f")
    done < <(find "$SKILL_DIR/references" -type f -name '*.md' | sort)
fi

if [ ${#FILES[@]} -eq 0 ]; then
    echo "WARN: No skill files found in $SKILL_DIR"
    exit 0
fi

relpath() {
    local file="$1"
    case "$file" in
        "$SKILL_DIR"/*) printf '%s\n' "${file#"$SKILL_DIR"/}" ;;
        *) printf '%s\n' "$file" ;;
    esac
}

is_adapter() {
    local rel="$1"
    case "$rel" in
        references/adapters/*) return 0 ;;
        *) return 1 ;;
    esac
}

is_mapping_file() {
    [ "$1" = "references/platform-adaptation.md" ]
}

is_mapping_allowed_line() {
    local line="$1"
    case "$line" in
        \|*) return 0 ;;
        *"**Do**:"*|*"**Don't**:"*|Do:*|Don\'t:*) return 0 ;;
        *"Platform-Specific Notes"*|*"Semantic Action"*|*"Capability"*) return 0 ;;
        *) return 1 ;;
    esac
}

scan_file() {
    local file="$1"
    local rel
    rel="$(relpath "$file")"
    local adapter=0
    local mapping=0
    if is_adapter "$rel"; then
        adapter=1
    elif is_mapping_file "$rel"; then
        mapping=1
    fi

    local in_code=0
    local hits=""
    local lineno=0

    while IFS= read -r line || [ -n "$line" ]; do
        lineno=$((lineno + 1))
        if [[ "$line" =~ ^[[:space:]]*\`\`\` ]]; then
            in_code=$((1 - in_code))
            continue
        fi

        local allowed=0
        if [ "$adapter" -eq 1 ]; then
            allowed=1
        elif [ "$mapping" -eq 1 ]; then
            if [ "$in_code" -eq 1 ] || is_mapping_allowed_line "$line"; then
                allowed=1
            fi
        fi

        if echo "$line" | grep -Eiq "$IMPERATIVE"; then
            if [ "$allowed" -eq 1 ]; then
                [ "$VERBOSE" -eq 1 ] && echo "adapter-allowed: $rel:$lineno:$line"
            else
                hits="${hits}${lineno}:${line}"$'\n'
            fi
        elif [ "$VERBOSE" -eq 1 ] && echo "$line" | grep -Eiq "\\b${TOOL_NAMES}\\b"; then
            if [ "$allowed" -eq 1 ]; then
                echo "adapter-allowed: $rel:$lineno:$line"
            else
                echo "example-ignored: $rel:$lineno:$line"
            fi
        fi
    done < "$file"

    if [ -n "$hits" ]; then
        echo "FAIL: $rel contains platform-specific portable instructions:"
        printf '%s' "$hits" | head -5
        FAIL=1
    fi
}

for f in "${FILES[@]}"; do
    scan_file "$f"
done

if [ $FAIL -eq 0 ]; then
    echo "PASS: No platform-specific tool names found in portable instructions"
fi

exit $FAIL
