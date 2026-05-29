#!/usr/bin/env bash
# test-verify-scripts.sh — Tests for the 3 verification scripts.
# Usage: ./scripts/test-verify-scripts.sh
# Creates temporary fixtures in /tmp/msc-test-$$/, runs all tests, cleans up.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/msc-test.XXXXXX")"
FAILURES=0
PASSES=0

# --- Helpers ---
assert_pass() {
    local desc="$1"; shift
    if "$@" > /dev/null 2>&1; then
        echo "  PASS: $desc"
        PASSES=$((PASSES + 1))
    else
        echo "  FAIL: $desc"
        FAILURES=$((FAILURES + 1))
    fi
}

assert_fail() {
    local desc="$1"; shift
    if "$@" > /dev/null 2>&1; then
        echo "  FAIL (expected failure): $desc"
        FAILURES=$((FAILURES + 1))
    else
        echo "  PASS (expected failure): $desc"
        PASSES=$((PASSES + 1))
    fi
}

cleanup() {
    if [ -n "${TEST_DIR:-}" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}
trap cleanup EXIT

mkdir -p "$TEST_DIR"

# ============================================================
# 1. verify-token-budget.sh
# ============================================================
echo ""
echo "=== verify-token-budget.sh ==="

BUDGET_SCRIPT="$SCRIPT_DIR/verify-token-budget.sh"

# --- 1a: SKILL.md body <= 2000 words -> PASS ---
FIXTURE="$TEST_DIR/budget-pass-skill"
mkdir -p "$FIXTURE"
{
    echo "---"
    echo "title: Test Skill"
    echo "---"
    # Generate exactly 500 words of body text
    python3 -c "print(' '.join(['word'] * 500))"
} > "$FIXTURE/SKILL.md"
assert_pass "SKILL.md body <= 2000w passes" "$BUDGET_SCRIPT" "$FIXTURE"

# --- 1b: SKILL.md body > 2000 words -> FAIL ---
FIXTURE="$TEST_DIR/budget-fail-skill"
mkdir -p "$FIXTURE"
{
    echo "---"
    echo "title: Test Skill"
    echo "---"
    # Generate 2500 words of body text
    python3 -c "print(' '.join(['word'] * 2500))"
} > "$FIXTURE/SKILL.md"
assert_fail "SKILL.md body > 2000w fails" "$BUDGET_SCRIPT" "$FIXTURE"

# --- 1c: references/ file <= 2000 words -> PASS ---
FIXTURE="$TEST_DIR/budget-pass-ref"
mkdir -p "$FIXTURE/references"
echo "---" > "$FIXTURE/SKILL.md"
echo "---" >> "$FIXTURE/SKILL.md"
echo "minimal" >> "$FIXTURE/SKILL.md"
python3 -c "print(' '.join(['refword'] * 500))" > "$FIXTURE/references/guide.md"
assert_pass "references/ file <= 2000w passes" "$BUDGET_SCRIPT" "$FIXTURE"

# --- 1d: references/ file > 2000 words -> FAIL ---
FIXTURE="$TEST_DIR/budget-fail-ref"
mkdir -p "$FIXTURE/references"
echo "---" > "$FIXTURE/SKILL.md"
echo "---" >> "$FIXTURE/SKILL.md"
echo "minimal" >> "$FIXTURE/SKILL.md"
python3 -c "print(' '.join(['refword'] * 2500))" > "$FIXTURE/references/guide.md"
assert_fail "references/ file > 2000w fails" "$BUDGET_SCRIPT" "$FIXTURE"

# --- 1e: nested references/ file > 2000 words -> FAIL ---
FIXTURE="$TEST_DIR/budget-fail-nested-ref"
mkdir -p "$FIXTURE/references/adapters"
echo "---" > "$FIXTURE/SKILL.md"
echo "---" >> "$FIXTURE/SKILL.md"
echo "minimal" >> "$FIXTURE/SKILL.md"
python3 -c "print(' '.join(['adapterword'] * 2500))" > "$FIXTURE/references/adapters/codex.md"
assert_fail "nested references/ file > 2000w fails" "$BUDGET_SCRIPT" "$FIXTURE"

# --- 1f: SKILL.md body with markdown separators > 2000 words -> FAIL ---
FIXTURE="$TEST_DIR/budget-fail-skill-separators"
mkdir -p "$FIXTURE"
{
    echo "---"
    echo "title: Test Skill"
    echo "---"
    python3 -c "print(' '.join(['before'] * 1500))"
    echo "---"
    python3 -c "print(' '.join(['after'] * 800))"
    echo "---"
} > "$FIXTURE/SKILL.md"
assert_fail "SKILL.md body > 2000w with markdown separators fails" "$BUDGET_SCRIPT" "$FIXTURE"

# ============================================================
# 2. verify-platform-names.sh
# ============================================================
echo ""
echo "=== verify-platform-names.sh ==="

PLATFORM_SCRIPT="$SCRIPT_DIR/verify-platform-names.sh"

# --- 2a: SKILL.md with no platform names -> PASS ---
FIXTURE="$TEST_DIR/platform-pass"
mkdir -p "$FIXTURE"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Search the codebase for matching patterns.
Execute the command to verify results.
Open the file and inspect its contents.
SKILLEOF
assert_pass "SKILL.md with no platform names passes" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2b: SKILL.md with "Use Bash to run" -> FAIL ---
FIXTURE="$TEST_DIR/platform-fail"
mkdir -p "$FIXTURE"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Use Bash to run the linting command.
Then Use Read to check the output file.
SKILLEOF
assert_fail "SKILL.md with 'Use Bash to run' fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2c: SKILL.md with "Run Grep" -> FAIL ---
FIXTURE="$TEST_DIR/platform-fail-grep"
mkdir -p "$FIXTURE"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Run Grep to find matching patterns in the project.
SKILLEOF
assert_fail "SKILL.md with 'Run Grep' fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2d: SKILL.md with "Edit tool" -> FAIL ---
FIXTURE="$TEST_DIR/platform-fail-tool"
mkdir -p "$FIXTURE"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Apply changes with the Edit tool to update files.
SKILLEOF
assert_fail "SKILL.md with 'Edit tool' fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2e: portable workflow reference with "Run Grep" -> FAIL ---
FIXTURE="$TEST_DIR/platform-fail-workflow"
mkdir -p "$FIXTURE/references"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Use semantic instructions.
SKILLEOF
cat > "$FIXTURE/references/workflow.md" << 'SKILLEOF'
# Workflow

Run Grep before editing shared interfaces.
SKILLEOF
assert_fail "portable workflow with 'Run Grep' fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2f: adapter file with platform names -> PASS ---
FIXTURE="$TEST_DIR/platform-adapter-pass"
mkdir -p "$FIXTURE/references/adapters"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Search the codebase with semantic verbs.
SKILLEOF
cat > "$FIXTURE/references/adapters/claude-code.md" << 'SKILLEOF'
# Adapter

PreToolUse hooks may block Edit, Write, Bash, or Agent access.
Use Bash only in this platform adapter example.
SKILLEOF
assert_pass "adapter file with platform names passes" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2g: platform mapping table with platform names -> PASS ---
FIXTURE="$TEST_DIR/platform-mapping-pass"
mkdir -p "$FIXTURE/references"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Execute the validation script.
SKILLEOF
cat > "$FIXTURE/references/platform-adaptation.md" << 'SKILLEOF'
# Platform Adaptation

| Action | Claude Code |
|---|---|
| Read a file | Read |
| Run command | Bash |

Don't: Use the Read tool in portable workflow text.
SKILLEOF
assert_pass "platform mapping table passes" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2h: unmarked imperative tool guidance in core reference -> FAIL ---
FIXTURE="$TEST_DIR/platform-core-fail"
mkdir -p "$FIXTURE/references"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Search the codebase with semantic verbs.
SKILLEOF
cat > "$FIXTURE/references/design-philosophy.md" << 'SKILLEOF'
# Design

Use Bash to enforce the rule.
SKILLEOF
assert_fail "core reference with imperative tool guidance fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2i: unmarked imperative tool guidance in platform-adaptation -> FAIL ---
FIXTURE="$TEST_DIR/platform-mapping-unmarked-fail"
mkdir -p "$FIXTURE/references"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Execute commands semantically.
SKILLEOF
cat > "$FIXTURE/references/platform-adaptation.md" << 'SKILLEOF'
# Platform Adaptation

Every portable workflow should use Bash for validation.
SKILLEOF
assert_fail "unmarked mapping prose with platform tool guidance fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# --- 2j: lowercase/modal and non-Claude tool names in portable files -> FAIL ---
FIXTURE="$TEST_DIR/platform-lowercase-modal-fail"
mkdir -p "$FIXTURE/references"
cat > "$FIXTURE/SKILL.md" << 'SKILLEOF'
# My Skill

Agents must use run_shell_command to verify results.
SKILLEOF
assert_fail "lowercase/modal non-Claude tool guidance fails" "$PLATFORM_SCRIPT" "$FIXTURE"

# ============================================================
# 3. verify-artifact-content.sh
# ============================================================
echo ""
echo "=== verify-artifact-content.sh ==="

ARTIFACT_SCRIPT="$SCRIPT_DIR/verify-artifact-content.sh"

# --- 3a: domain-research with >= 5 sources -> PASS ---
FIXTURE="$TEST_DIR/domain-research-pass.md"
cat > "$FIXTURE" << 'EOF'
# Domain Research

## Source 1. Official Documentation
Name: Official Docs
Key finding: comprehensive coverage

## Source 2. Community Guide
Name: Community Guide
Key finding: practical patterns

## Source 3. Academic Paper
Name: Research Paper
Key finding: theoretical foundation

## Source 4. Industry Report
Name: Industry Report
Key finding: market trends

## Source 5. Expert Blog
Name: Expert Blog
Key finding: real-world lessons

## Source 6. Conference Talk
Name: Conference Talk
Key finding: advanced techniques
EOF
assert_pass "domain-research with >= 5 sources passes" "$ARTIFACT_SCRIPT" "$FIXTURE" "domain-research"

# --- 3b: domain-research with 2 sources -> FAIL ---
# The script first counts ## headers matching "Source|source|N." pattern.
# If < 5, it falls back to counting "name:|source:|key finding|implication" lines / 2.
# We provide 2 source headers (first grep finds 2, exits 0) -> count=2 < 5 -> FAIL.
FIXTURE="$TEST_DIR/domain-research-fail.md"
cat > "$FIXTURE" << 'EOF'
# Domain Research

## Source 1. First reference
Name: First Ref
Key finding: something

## Source 2. Second reference
Name: Second Ref
Key finding: something else
EOF
assert_fail "domain-research with ~2 sources fails" "$ARTIFACT_SCRIPT" "$FIXTURE" "domain-research"

# --- 3c: enforcement-plan with Think/Do table at >= 30% ratio -> PASS ---
FIXTURE="$TEST_DIR/enforcement-plan-pass.md"
cat > "$FIXTURE" << 'EOF'
# Enforcement Plan

## Classification Table

| Rule | Axis | Mechanism |
|------|------|-----------|
| Check inputs | Do | pre-check gate |
| Validate output | Do | post-check |
| Analyze structure | Think | mental model |
| Verify format | Do | automated scan |
| Review context | Think | reasoning step |

Do-axis rules enforce concrete actions.
EOF
assert_pass "enforcement-plan with >= 30% Do ratio passes" "$ARTIFACT_SCRIPT" "$FIXTURE" "enforcement-plan"

# --- 3d: enforcement-plan with low Do ratio -> FAIL ---
# Script counts TOTAL_ROWS and DO_ROWS via grep -c. Note: grep -c returns exit 1
# when count is 0, which triggers a "|| echo 0" bug producing "0\n0" instead of 0.
# To avoid this, we include 1 Do row among many Think rows so DO_ROWS > 0 (exit 0)
# but the ratio stays well below 30%. With 1 Do row in 12 total table rows: 8%.
FIXTURE="$TEST_DIR/enforcement-plan-fail.md"
cat > "$FIXTURE" << 'EOF'
# Enforcement Plan

## Classification Table

| Rule | Axis | Mechanism |
|------|------|-----------|
| Check inputs | Do | pre-check gate |
| Think about structure | Think | mental model |
| Think about context | Think | reasoning step |
| Think about options | Think | evaluation |
| Think about quality | Think | assessment |
| Think about scope | Think | evaluation |
| Think about risk | Think | assessment |
| Think about timeline | Think | planning |
| Think about impact | Think | estimation |
| Think about cost | Think | budgeting |
EOF
assert_fail "enforcement-plan with low Do ratio fails" "$ARTIFACT_SCRIPT" "$FIXTURE" "enforcement-plan"

# --- 3e: constraint-audit with ratio + candidates -> PASS ---
FIXTURE="$TEST_DIR/constraint-audit-pass.md"
cat > "$FIXTURE" << 'EOF'
# Constraint Audit

## Enforcement Ratio
Enforcement ratio: 65% (13 of 20 rules have enforcement mechanisms)

## Upgrade Candidates
Top 3 highest-stakes rules without enforcement:
1. Input validation — upgrade candidate: add pre-check gate
2. Output format — upgrade candidate: add format validator
3. Error handling — upgrade candidate: add error boundary
EOF
assert_pass "constraint-audit with ratio + candidates passes" "$ARTIFACT_SCRIPT" "$FIXTURE" "constraint-audit"

# --- 3f: constraint-audit without ratio -> FAIL ---
# Script greps for "enforcement ratio|enforcement.*[0-9]+%" and
# "upgrade candidate|highest.stakes|top [0-9]". We must avoid ALL of these
# keywords in the failing fixture text.
FIXTURE="$TEST_DIR/constraint-audit-fail.md"
cat > "$FIXTURE" << 'EOF'
# Audit Results

## Analysis
Some analysis text here.
No relevant findings.
EOF
assert_fail "constraint-audit without ratio fails" "$ARTIFACT_SCRIPT" "$FIXTURE" "constraint-audit"

# --- 3g: red-lines with >= 5 items + acceptance + stance -> PASS ---
FIXTURE="$TEST_DIR/red-lines-pass.md"
cat > "$FIXTURE" << 'EOF'
# Red Lines

## Hard Limits
- No hallucinated data in outputs
- Never skip validation step
- Must not exceed token budget
- No platform-specific tool names in instructions
- Never omit source attribution
- Must not produce empty artifacts

## Acceptance Criteria
Each red line has a binary test.

## Stance
Strict enforcement, no exceptions.
EOF
assert_pass "red-lines with >= 5 items + acceptance + stance passes" "$ARTIFACT_SCRIPT" "$FIXTURE" "red-lines"

# --- 3h: red-lines with too few items -> FAIL ---
FIXTURE="$TEST_DIR/red-lines-fail.md"
cat > "$FIXTURE" << 'EOF'
# Red Lines

## Hard Limits
- No hallucinated data
- Never skip validation

## Notes
Some notes.
EOF
assert_fail "red-lines with < 5 items fails" "$ARTIFACT_SCRIPT" "$FIXTURE" "red-lines"

# --- 3i: validation with >= 8 checklist items -> PASS ---
FIXTURE="$TEST_DIR/validation-pass.md"
cat > "$FIXTURE" << 'EOF'
# Validation Checklist

- [ ] Token budget within limits
- [ ] No platform-specific names
- [x] Domain research has >= 5 sources
- [ ] Red lines defined
- [x] Enforcement plan has Do-axis rules
- [ ] Constraint audit complete
- [ ] All artifacts produced
- [x] Cross-platform compatible
- [ ] References within word limit
EOF
assert_pass "validation with >= 8 checklist items passes" "$ARTIFACT_SCRIPT" "$FIXTURE" "validation"

# --- 3j: validation with < 8 checklist items -> FAIL ---
FIXTURE="$TEST_DIR/validation-fail.md"
cat > "$FIXTURE" << 'EOF'
# Validation Checklist

- [ ] Token budget check
- [x] Platform names check
- [ ] Sources check
EOF
assert_fail "validation with < 8 checklist items fails" "$ARTIFACT_SCRIPT" "$FIXTURE" "validation"

# ============================================================
# 4. verify-secrets-safe.sh
# ============================================================
echo ""
echo "=== verify-secrets-safe.sh ==="

SECRETS_SCRIPT="$SCRIPT_DIR/verify-secrets-safe.sh"

FIXTURE="$TEST_DIR/secrets-pass"
mkdir -p "$FIXTURE"
cat > "$FIXTURE/notes.md" << 'EOF'
# Notes

This mentions API_KEY as a placeholder, not a real credential.
EOF
assert_pass "placeholder-only secrets scan passes" "$SECRETS_SCRIPT" "$FIXTURE"

FIXTURE="$TEST_DIR/secrets-fail"
mkdir -p "$FIXTURE"
{
    echo "# Notes"
    echo ""
    printf 'token: sk-%s%s\n' "abcdefghijklmnopqrstuvwxyz" "123456"
} > "$FIXTURE/notes.md"
assert_fail "high-confidence secret pattern fails" "$SECRETS_SCRIPT" "$FIXTURE"

# ============================================================
# 5. verify-behavior-fixtures.sh
# ============================================================
echo ""
echo "=== verify-behavior-fixtures.sh ==="

BEHAVIOR_SCRIPT="$SCRIPT_DIR/verify-behavior-fixtures.sh"

FIXTURE="$TEST_DIR/behavior-pass"
mkdir -p "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement"
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/codex-new-expected.md" << 'EOF'
# Codex-Targeted New Skill Expected Guidance

For a Codex-targeted skill, prefer artifact gates and validation scripts.
Avoid requiring Claude Code hooks, PreToolUse, or hook installation.
Use ~/.codex/skills/ for Codex-specific installs and ~/.agents/skills/ for shared installs.
EOF
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/claude-code-new-expected.md" << 'EOF'
# Claude Code-Targeted New Skill Expected Guidance

For a Claude Code-targeted skill, PreToolUse hooks are optional blocking enforcement.
Keep artifact/script fallback guidance.
EOF
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/portable-boost-expected.md" << 'EOF'
# Portable Boost Expected Guidance

Portable core defects are separate from Adapter recommendations.
The report should not mark a portable skill incomplete only because it lacks Claude Code hooks.
EOF
assert_pass "behavior fixtures with expected boundaries pass" "$BEHAVIOR_SCRIPT" "$FIXTURE"

FIXTURE="$TEST_DIR/behavior-fail"
mkdir -p "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement"
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/codex-new-expected.md" << 'EOF'
# Codex-Targeted New Skill Expected Guidance

Codex-targeted skills must require PreToolUse hook installation.
Use ~/.codex/skills/ and ~/.agents/skills/.
EOF
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/claude-code-new-expected.md" << 'EOF'
# Claude Code-Targeted New Skill Expected Guidance

PreToolUse hooks are optional blocking enforcement with fallback.
EOF
cat > "$FIXTURE/docs/specs/fixtures/codex-portable-enforcement/portable-boost-expected.md" << 'EOF'
# Portable Boost Expected Guidance

Portable core defects are separate from Adapter recommendations.
The report should not mark a portable skill incomplete only because it lacks Claude Code hooks.
EOF
assert_fail "behavior fixtures requiring Codex hooks fail" "$BEHAVIOR_SCRIPT" "$FIXTURE"

# ============================================================
# Summary
# ============================================================
TOTAL=$((PASSES + FAILURES))
echo ""
echo "=== Results ==="
echo "Total: $TOTAL  |  Passed: $PASSES  |  Failed: $FAILURES"
echo ""

if [ "$FAILURES" -gt 0 ]; then
    echo "SOME TESTS FAILED"
    exit 1
else
    echo "ALL TESTS PASSED"
    exit 0
fi
