---
title: Unified Constraint Framework Integration Plan
scope: Standard
status: approved
date: 2026-04-15
source: docs/brainstorms/constraint-framework-integration-requirements.md
task_count: 7
complexity: medium
tier: 2
---

# Unified Constraint Framework Integration Plan

## Problem Frame

Mojo Skill Creator (MSC) and the skills it produces rely entirely on cognitive constraints (Think axis) that agents routinely skip. Need to add structural enforcement (Do axis) both to MSC itself and to its skill production methodology.

## Decision Log

| Decision | Rationale | Rejected Alternative |
|----------|-----------|---------------------|
| Dogfood route: build methodology first, then apply to self | Validates methodology before shipping it; MSC becomes first test case | Parallel implementation (risky: might build enforcement that doesn't match methodology) |
| New steps as thin pointers to guide (~60w each) | All three workflow files already over budget; substance lives in guide | Inline full methodology in workflow files (would blow budget) |
| Constraint-enforcement-guide as Layer 3 reference | Loaded on-demand only when designing constraints; doesn't inflate always-loaded cost | Layer 2 always-loaded (too expensive at ~2000w) |
| Compress existing files first, then add content | Ensures budget compliance at every step | Add first, compress later (risks over-budget intermediate state) |

## File Manifest

### Files to Create

| File | Purpose |
|------|---------|
| `references/constraint-enforcement-guide.md` | Constraint layer analysis method + enforcement mechanism templates (≤2000w) |
| `docs/solutions/msc-constraint-analysis.md` | Dogfood: MSC self-analysis using the methodology |

### Files to Modify

| File | Current | Target | Change |
|------|---------|--------|--------|
| `references/design-philosophy.md` | 911w | ~1060w | Add Principle 7: Dual-Axis Constraints |
| `references/new-workflow.md` | 2127w | ~1870w | Compress ~315w + add Step 3b (~60w) |
| `references/boost-workflow.md` | 2626w | ~1960w | Compress ~730w + add diagnostic step (~60w) |
| `SKILL.md` | 563w | ~530w | Compress ~42w + add 1 red line + update acceptance |

### No Test Files

This is a methodology/documentation project — no code tests. Verification is via word count checks, structural audits, and the dogfood analysis document.

## Task Decomposition

### T1: Create constraint-enforcement-guide.md

**Description**: Write the core methodology document — constraint layer analysis framework adapted for skill authors, four enforcement mechanism types (hooks, artifact gates, verification scripts, sub-agent scoping), platform compatibility matrix, and decision framework for choosing mechanisms.

**Files**: CREATE `references/constraint-enforcement-guide.md`
**Complexity**: medium
**Dependencies**: none
**Acceptance criteria**: AC1 (guide exists, ≤2000w, covers 4 mechanisms)

### T2: Add Principle 7 to design-philosophy.md

**Description**: Add "Dual-Axis Constraints (Think + Do)" as the 7th design principle. Explain the Think/Do distinction with concrete examples. Show how to classify constraints by axis. ~150 words.

**Files**: MODIFY `references/design-philosophy.md`
**Complexity**: small
**Dependencies**: none
**Acceptance criteria**: AC4 (principle exists with Think/Do distinction)

### T3: Compress and modify new-workflow.md

**Description**: First compress ~315w from identified sections (Step 2 intro, Step 3 templates, Step 6b structure, Step 7/7b optional sections, Prerequisites). Then add Step 3b: "Constraint Enforcement Design" as thin pointer to constraint-enforcement-guide.md (~60w). New artifact gate: `build/constraint-enforcement-plan.md`.

**Files**: MODIFY `references/new-workflow.md`
**Complexity**: medium
**Dependencies**: T1 (guide must exist to reference)
**Acceptance criteria**: AC2 (step exists with artifact gate), AC7 (budget)

### T4: Compress and modify boost-workflow.md

**Description**: Compress ~730w from identified sections (Loading Strategy prose→table, Phase 1.1-1.7 verbose descriptions, Phase 2.3 redundant prose, Phase 3 verification blocks). Then add diagnostic step "1.9: Constraint Enforcement Audit" as thin pointer to constraint-enforcement-guide.md (~60w). New artifact gate: `diagnosis/constraint-enforcement-audit.md`.

**Files**: MODIFY `references/boost-workflow.md`
**Complexity**: medium
**Dependencies**: T1 (guide must exist to reference)
**Acceptance criteria**: AC3 (step exists with artifact gate), AC7 (budget)

### T5: Compress and modify SKILL.md

**Description**: Compress ~42w from description, stance, red lines, acceptance. Add new red line: "No red line in a produced skill that can be structurally enforced is left cognitive-only without documented justification. Check: constraint-enforcement-plan.md classifies each red line's enforcement axis." Update acceptance criteria. Add constraint-enforcement-guide.md to References table.

**Files**: MODIFY `SKILL.md`
**Complexity**: small
**Dependencies**: T1, T2 (guide and principle must exist to reference)
**Acceptance criteria**: AC7 (budget)

### T6: MSC self-analysis (dogfood)

**Description**: Apply the constraint-enforcement-guide.md methodology to analyze Mojo Skill Creator itself. For each of MSC's own red lines, classify as Think-only or Think+Do. Identify highest-leverage gaps for Do-axis enforcement. Output: specific recommendations for T7.

**Files**: CREATE `docs/solutions/msc-constraint-analysis.md`
**Complexity**: medium
**Dependencies**: T1 (methodology needed)
**Acceptance criteria**: AC5 (analysis document exists)

### T7: Implement Do-axis mechanisms on MSC

**Description**: Based on T6 analysis, implement ≥3 structural enforcement mechanisms for MSC itself. Candidates: (a) artifact gate content verification (not just file existence — check sections), (b) hook template for blocking step progression without artifacts, (c) verification script for red line count in produced skills.

**Files**: MODIFY workflow files as needed; may CREATE `scripts/` or `hooks/` assets
**Complexity**: medium
**Dependencies**: T6 (analysis needed before implementation)
**Acceptance criteria**: AC6 (≥3 Do-axis mechanisms)

## Dependency Graph

```
T1 (guide) ──────┬──→ T3 (new-workflow)
                  ├──→ T4 (boost-workflow)
                  ├──→ T5 (SKILL.md) ←── T2 (principle 7)
                  └──→ T6 (dogfood) ──→ T7 (implement)

T2 (principle 7)  ──→ T5 (SKILL.md)
```

Parallelizable: T1 + T2 (no shared dependencies)
Parallelizable: T3 + T4 (after T1 completes)

## Test Plan

| AC# | Scenario | Verification |
|-----|----------|-------------|
| AC1 | constraint-enforcement-guide.md exists and is complete | `wc -w` ≤ 2000; contains sections: hook, gate, script, sub-agent |
| AC2 | new-workflow has constraint step | Grep for "Constraint Enforcement Design"; grep for `build/constraint-enforcement-plan.md` |
| AC3 | boost-workflow has audit step | Grep for "Constraint Enforcement Audit"; grep for `diagnosis/constraint-enforcement-audit.md` |
| AC4 | design-philosophy has Principle 7 | Grep for "Dual-Axis" or "Think.*Do" in file |
| AC5 | MSC self-analysis exists | File exists at `docs/solutions/msc-constraint-analysis.md` |
| AC6 | MSC has ≥3 Do-axis mechanisms | Count structural mechanisms in self-analysis document |
| AC7 | Token budgets respected | `wc -w` on SKILL.md ≤ 530w; new-workflow ≤ 2000w; boost-workflow ≤ 2000w |
