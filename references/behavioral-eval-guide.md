# Behavioral Eval & Surgical Fix (Optional)

Quantified evaluation of skill behavior via simulated tasks, followed by targeted fixes for specific failures. Uses subagent execution + audit-style scoring to measure how well the skill performs in practice — not just whether it's structurally correct.

**This is not `boost`.** Boost is a full strategic upgrade (9 diagnostics, 4 phases). This is surgical: find what's broken, fix only that, verify, move on.

---

## When to Add

| Skill Output Type | Recommendation |
|-------------------|---------------|
| Analysis / decisions | Recommended — output quality is hard to judge by inspection |
| Creative / generative | Recommended — subtle quality differences compound |
| Tool / transformation | Usually not needed — input→output is deterministic and testable via scripts |

**Prerequisites**: Step 8 passed (skill structurally complete). Step 1's examples available as test scenario seeds.

---

## Phase 1: Design Test Scenarios

Derive 3-5 test scenarios from Step 1's concrete examples. Each scenario must cover a different difficulty level.

### Scenario Template

```markdown
## Scenario: [name]
- **Difficulty**: simple | boundary | adversarial
- **Input prompt**: [exact text to give the agent]
- **Quality dimensions**: [which red lines and acceptance criteria apply]
- **Known failure modes**: [what bad output looks like for this scenario]
```

### Scenario Mix

| Type | Purpose | Example |
|------|---------|---------|
| Simple (1-2) | Baseline — does the skill work at all? | Straightforward request matching a Step 1 example |
| Boundary (1-2) | Edge cases — does quality hold under pressure? | Ambiguous input, missing context, unusual domain |
| Adversarial (1) | Stress test — does the skill resist common failure modes? | Request that tempts the agent to violate a red line |

**Artifact**: `build/eval-scenarios.md`

---

## Phase 2: Execute via Subagent

For each scenario, spawn a subagent with the skill installed and capture its output.

### Execution Methods (choose one)

**CLI method** (simplest):
```bash
cat <<'EOF' | claude --print --system-prompt "$(cat SKILL.md)"
[scenario input prompt]
EOF
> build/eval-outputs/scenario-1.md
```

**API method** (most control):
```python
# Inject SKILL.md content as system prompt
# Send scenario input as user message
# Capture assistant response to file
```

**Manual method** (fallback):
Run each scenario in a fresh agent session with the skill installed. Copy output to `build/eval-outputs/`.

### Rules

- One fresh session per scenario — no cross-contamination
- Capture full output including any artifacts the skill produces
- Record execution metadata: which method, model, timestamp

**Outputs**: `build/eval-outputs/scenario-{N}.md` for each scenario

---

## Phase 3: Score

### Extract Expectations

From the skill's own SKILL.md, convert red lines and acceptance criteria into scorable expectations:

| Source | Severity | Weight |
|--------|----------|--------|
| Each red line | CRITICAL | 3.0 |
| Each acceptance criterion | HIGH | 2.0 |
| Each quality dimension from scenario | MEDIUM | 1.0 |

### Score Each Output

For each scenario output, evaluate every expectation:

```markdown
| Expectation | Severity | Result | Notes |
|-------------|----------|--------|-------|
| No role assignment | CRITICAL | PASS | — |
| Acceptance: ≥5 red lines | HIGH | FAIL | Only 3 red lines produced |
| ... | ... | ... | ... |
```

### Composite Score

```
earned = SUM(weight × result_multiplier) for each expectation
possible = SUM(weight)
score = (earned / possible) × 100

Result multipliers: PASS=1.0, WARN=0.5, FAIL=0.0
```

**CRITICAL blocker**: Any CRITICAL FAIL caps the score at C (< 70%) regardless of raw percentage.

**Grade bands**: A ≥ 90% | B ≥ 75% | C ≥ 60% | D ≥ 40% | F < 40%

**Artifact**: `build/eval-scorecard.md` — all scores, all scenarios, composite grade.

---

## Phase 4: Surgical Fix

**Entry condition**: Score < target (default: B grade, ≥ 75%) or any CRITICAL FAIL.

For each FAIL item, in priority order (CRITICAL first, then HIGH, then MEDIUM):

### Fix Protocol

1. **Identify**: Which skill file and which section caused this failure?
2. **Transform to goal**: "Scenario 2 violated red line X" → "Modify [file:section] so that [specific check] passes on scenario 2 input"
3. **Surgical change**: Edit only the lines that trace directly to this FAIL
4. **Verify**: Re-run the failing scenario — does this specific FAIL become PASS?
5. **Regression**: Re-run all other scenarios — did anything break?

### Surgical Discipline

- Every changed line must trace to a specific FAIL item
- Do not improve adjacent code, comments, or formatting
- Do not refactor things that are not broken
- Match existing style, even if you would do it differently
- If your change creates orphans (unused imports, dead references), clean only YOUR orphans
- If you notice unrelated issues, note them — do not fix them

### One Fix At a Time

Do NOT batch multiple fixes. The sequence is: one FAIL → one fix → verify → regression → next FAIL. This isolates the effect of each change and prevents entangled regressions.

---

## Phase 5: Re-score & Terminate

After all FAIL items in a round are addressed, re-run Phase 2 and Phase 3 on all scenarios.

### Termination Rules

| Rule | Condition | Action |
|------|-----------|--------|
| **SUCCESS** | Score ≥ target AND no CRITICAL FAIL | Exit. Skill passes behavioral eval. |
| **PLATEAU** | 3 consecutive rounds with < 5% score improvement | Exit. Recommend `boost` for structural redesign. |
| **MAX_ROUNDS** | 5 rounds completed | Exit. Remaining issues likely need workflow-level changes, not surgical fixes. |

### History Tracking

Append each round's results to `build/eval-history.md`:

```markdown
| Round | Score | Grade | CRITICAL FAILs | Changes Made |
|-------|-------|-------|---------------|-------------|
| 0 (baseline) | 62% | C | 1 | — |
| 1 | 78% | B | 0 | Fixed red line enforcement in workflow step 3 |
| 2 | 85% | B | 0 | Clarified stance section |
```

### Upgrade Trigger

If termination is PLATEAU or MAX_ROUNDS, the remaining failures are likely **structural** (workflow design, stance definition, domain knowledge gaps) rather than **surface-level** (unclear instruction, missing check). These require `boost`'s full diagnostic and redesign capability, not more surgical fixes.

**Artifact**: `build/eval-history.md` — round-by-round scores and termination reason.
