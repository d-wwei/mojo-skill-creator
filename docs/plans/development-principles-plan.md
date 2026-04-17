---
title: "Development Principles Integration Plan"
scope: standard
status: approved
created: 2026-04-17
updated: 2026-04-17
source_requirements: docs/brainstorms/development-principles-requirements.md
task_count: 6
complexity: medium
---

# Development Principles Integration Plan

## Problem Frame

MSC lacks engineering practice principles. 13 user-proposed principles need to be encoded as a "Development Practices" section in SKILL.md (9 universal) + Red Lines expansion (3 hard constraints) + a new reference file with full details, ADR template, and CHANGELOG spec + enforcement checkpoints in both workflows.

## Decision Log

### Decision: Principles in table format, not prose
**Rationale**: Reference file budget is 2000w. 11 principles in prose (~150w each = 1650w) plus ADR (~300w) plus CHANGELOG (~200w) = 2150w (over budget). Table format (~40w/principle = 440w) keeps total under 1000w.
**Alternatives rejected**: Prose per principle (over budget); split into two reference files (unnecessary complexity given table format fits).

### Decision: Compress new-workflow.md before adding checkpoints
**Rationale**: File is at 1994/2000w. Must release ~100w before adding ~90w of checkpoints. Compression targets: Step 10 description (~30w savings), Step 7/7b optional markers (~25w), Step 6b body structure list (~20w), Step 1 redundant phrasing (~25w).
**Alternatives rejected**: Move checkpoints to reference file only (loses enforcement at point-of-use); split workflow into two files (architectural change out of scope).

### Decision: ADR-0001 is explicitly retroactive
**Rationale**: The first ADR records the decision to adopt ADRs. This is inherently bootstrapping. Making it explicit avoids confusion.
**Alternatives rejected**: Skip ADR-0001 and start from ADR-0002 (loses the most important decision record — why we adopted this practice).

### Negative Decision: Do NOT add verification scripts in this iteration
**Rationale**: P7 (linter) and P8 (CHANGELOG format) enforcement scripts would be new Do-axis mechanisms. Adding them requires designing the script interface, testing, and updating verification infrastructure. This is a separate feature (see Roadmap Priority 4: Evidence file mechanism). Think-axis enforcement via workflow checkpoints is sufficient for now.

## File Manifest

| Category | Path | Action |
|----------|------|--------|
| Modify | `SKILL.md` | Add "Development Practices" section + 3 Red Lines + update References table |
| Create | `references/development-practices.md` | New reference: principle rules + ADR template + CHANGELOG spec |
| Modify | `references/new-workflow.md` | Compress ~100w + add 6 enforcement checkpoints |
| Modify | `references/boost-workflow.md` | Add backward compat diff check to 1.1 + ADR audit to 1.9 |
| Modify | `CHANGELOG.md` | Upgrade to hybrid format (add narrative header to latest entry) |
| Create | `docs/adr/ADR-0001.md` | Seed ADR: "Adopt Development Practices + ADR mechanism" |

6 files total (4 modify, 2 create). Under 8-file threshold.

## Task List

| Task ID | Description | Files | Complexity | Dependencies | Acceptance Criteria |
|---------|-------------|-------|-----------|-------------|---------------------|
| T1 | Create `references/development-practices.md` with principle rules table, ADR template/lifecycle, CHANGELOG hybrid format spec, conditional P9/P11 section | `references/development-practices.md` | medium | — | AC-3 |
| T2 | Add "Development Practices" section to SKILL.md (9 principles, ≤20w/line) + 3 new Red Lines (ADR, backward compat, secrets) + update References table pointer | `SKILL.md` | small | T1 | AC-1, AC-2, AC-6, AC-9 |
| T3 | Compress new-workflow.md (~100w) then add 6 single-line enforcement checkpoints at Steps 1, 2, 3, 5, 6, 8 | `references/new-workflow.md` | medium | T1 | AC-4 |
| T4 | Add backward compat diff check to boost Phase 1.1 + extend ADR audit in Phase 1.9 | `references/boost-workflow.md` | small | T1 | AC-5 |
| T5 | Create ADR-0001 (retroactive: adopt Development Practices + ADR mechanism) | `docs/adr/ADR-0001.md` | trivial | — | AC-7 |
| T6 | Upgrade CHANGELOG.md latest entry to hybrid format (narrative header + KaC) | `CHANGELOG.md` | trivial | — | AC-8 |

## Test Plan

| AC | Scenario | Given / When / Then | Verification |
|----|----------|---------------------|-------------|
| AC-1 | SKILL.md has Development Practices | Given SKILL.md / When grep "Development Practices" / Then section exists with 9 principle lines tagged [A]/[B]/[AB] | Grep + line count |
| AC-2 | Red Lines expanded | Given SKILL.md / When count red line items / Then ≥13 items, including "ADR", "backward compat", "secrets/密钥" | Grep count |
| AC-3 | Reference file complete | Given development-practices.md / When check sections / Then contains: "ADR" template, "CHANGELOG" spec, conditional P9/P11, and word count ≤2000 | Section scan + verify-token-budget.sh |
| AC-4 | Workflow checkpoints | Given new-workflow.md / When grep "Dev Practice" / Then ≥5 matches at different steps | Grep count |
| AC-5 | Boost diagnostics | Given boost-workflow.md / When grep "backward compat\|ADR" in Phase 1 / Then ≥2 matches | Grep |
| AC-6 | Token budget | Given all files / When run verify-token-budget.sh / Then all PASS, SKILL.md ≤1000w | Script output |
| AC-7 | ADR-0001 exists | Given docs/adr/ / When read ADR-0001.md / Then Status=Accepted, Context mentions "retroactive" | File content check |
| AC-8 | CHANGELOG hybrid | Given CHANGELOG.md / When read latest entry / Then has narrative header (≤5 lines) before KaC categories | Manual inspection |
| AC-9 | Principles unchanged | Given SKILL.md / When diff Core Design Principles section / Then no changes to existing 7 principles | Git diff |

## Dependency Graph

```
T1 ──→ T2
T1 ──→ T3
T1 ──→ T4
T5 (independent)
T6 (independent)
```

T5 and T6 can run in parallel with T1. T2, T3, T4 depend on T1 (they reference the new file). T2, T3, T4 are independent of each other.
