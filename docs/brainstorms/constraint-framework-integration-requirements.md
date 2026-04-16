---
title: Unified Constraint Framework Integration
scope: Standard
status: approved
date: 2026-04-15
tier: 2
---

# Unified Constraint Framework Integration

## Problem Statement

Skills created by Mojo Skill Creator contain constraints (red lines, workflow steps, artifact gates) that agents routinely skip. Root cause: all enforcement is on the Think axis (cognitive instructions that depend on agent compliance). The Do axis (structural enforcement that makes non-compliance impossible or detectable) is almost entirely absent. The same problem applies to the Mojo Skill Creator itself — agents using MSC skip its own steps.

## Dual-Task Structure

| | Task 1: MSC as Consumer | Task 2: MSC as Producer |
|---|---|---|
| Target | Mojo Skill Creator itself | Skills produced by MSC |
| Goal | Agents follow MSC's workflow | Produced skills enforce their own constraints |
| Approach | Apply constraint framework to MSC | Build constraint analysis into MSC's creation methodology |

Execution order: Task 2 (build methodology) → dogfood analysis of MSC → Task 1 (implement on MSC).

## Constraints

- Must not break existing new/boost workflows — additive changes only
- Must stay within token budgets (SKILL.md ≤ 500w router, references ≤ 2000w each)
- Do-axis mechanisms must degrade gracefully on platforms without hook support (cognitive fallback always exists)
- Distribution-first principle still applies — enforcement assets (hooks, scripts) must be bundled in skill packages

## Approach: Dogfood Route

### Phase 1: Build the methodology (Task 2)

1. New reference file: `references/constraint-enforcement-guide.md`
   - L0-L6 × Think/Do matrix adapted for skill authors (not the full Cognitive Kernel — only what's relevant to skill design)
   - Four enforcement mechanism types with templates: hooks, artifact gates, verification scripts, sub-agent scoping
   - Platform compatibility matrix (which mechanisms work where)
   - Decision framework: for each red line, how to choose the right enforcement mechanism

2. Modify `references/new-workflow.md`
   - Add step between current Step 3 (Red Lines) and Step 4 (Token Architecture): "Step 3b: Constraint Enforcement Design"
   - For each red line from Step 3, classify as Think-enforceable or Do-enforceable
   - For Do-enforceable constraints, design the mechanism (hook template, gate condition, verification script)
   - New artifact: `build/constraint-enforcement-plan.md`

3. Modify `references/boost-workflow.md`
   - Add diagnostic step 1.X: "Constraint Enforcement Audit"
   - Audit each red line: Think-only or Think+Do?
   - Calculate enforcement ratio (% of red lines with Do-axis mechanisms)
   - Identify highest-leverage gaps
   - New artifact: `diagnosis/constraint-enforcement-audit.md`
   - Add prescription guidance in Phase 2 for upgrading cognitive-only constraints

4. Modify `references/design-philosophy.md`
   - Add Principle 7: "Dual-Axis Constraints (Think + Do)"
   - Show the Think/Do distinction with concrete examples
   - Classify existing principles by axis

5. Modify `SKILL.md`
   - Add red line: "No red line in a produced skill that can be structurally enforced is left as cognitive-only without justification"
   - Update acceptance criteria to include enforcement coverage
   - Add pointer to constraint-enforcement-guide.md in References table

### Phase 2: Dogfood — Analyze MSC itself (Task 1 prep)

Apply the methodology from Phase 1 to analyze what constraint layers MSC itself needs. Output: `docs/solutions/msc-constraint-analysis.md`

### Phase 3: Implement on MSC itself (Task 1)

Based on Phase 2 analysis:
- Add `hooks/` directory with enforcement hooks for MSC's own workflow
- Add `scripts/` directory with verification scripts
- Strengthen existing artifact gates (check content, not just file existence)

## Acceptance Criteria

1. `constraint-enforcement-guide.md` exists, ≤ 2000 words, covers hook/gate/script/sub-agent mechanisms with templates
2. new-workflow contains "Constraint Enforcement Design" step with artifact gate (`build/constraint-enforcement-plan.md`)
3. boost-workflow contains "Constraint Enforcement Audit" diagnostic step with artifact gate (`diagnosis/constraint-enforcement-audit.md`)
4. design-philosophy.md contains Principle 7 with Think/Do distinction
5. MSC self-analysis document exists (`docs/solutions/msc-constraint-analysis.md`)
6. MSC has ≥ 3 structural (Do-axis) enforcement mechanisms implemented
7. All changes stay within token budgets (SKILL.md ≤ 500w, each reference ≤ 2000w)

## Token Budget Reality (Verified)

| File | Current | Budget | Action Needed |
|------|---------|--------|---------------|
| SKILL.md | 563w | ≤ 500w | Compress ~80w to make room for new red line + acceptance |
| new-workflow.md | 2127w | ≤ 2000w | Compress ~200w; new step is pointer only (~60w) |
| boost-workflow.md | 2626w | ≤ 2000w | Compress ~700w; new step is pointer only (~60w) |
| design-philosophy.md | 911w | no hard cap | Add Principle 7 (~150w) → ~1060w. Fine. |
| constraint-enforcement-guide.md | NEW | ≤ 2000w | Carries all substance; workflow files point here |

**Strategy**: New constraint enforcement steps in workflow files are THIN POINTERS to `constraint-enforcement-guide.md`. All methodology substance lives in the guide. This avoids inflating already-over-budget files. Compression of existing content is a prerequisite, not optional.

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Compression loses important content | Medium | High | Identify redundancy and prose→table conversions first; preserve all gates and artifacts |
| Hook templates not portable across platforms | Medium | Medium | Always include cognitive fallback; platform matrix in guide |
| Over-engineering — constraint analysis step slows down skill creation | Low | Medium | Lightweight scope skips the step; Standard/Deep scope runs it |

## Dependencies

- Unified constraint framework document (`unified-constraint-framework.md`) — available ✓
- Current MSC codebase — available ✓
- No external dependencies
