---
title: MSC Constraint Enforcement Self-Analysis
date: 2026-04-15
method: constraint-enforcement-guide.md § "In boost Workflow"
---

# Mojo Skill Creator — Constraint Enforcement Analysis

## Root Cause / Problem

Skills produced by Mojo Skill Creator have constraints that agents routinely skip. Root cause: all enforcement was on the Think axis (cognitive instructions) with no Do axis (structural enforcement). The same problem applied to MSC itself.

## Prevention

1. Every new skill must include `build/constraint-enforcement-plan.md` classifying each red line as Think or Do axis (Step 3d gate)
2. Every boosted skill gets a constraint enforcement audit (Phase 1.9 gate)
3. MSC itself now has 3 verification scripts enforcing its own red lines structurally
4. Design Principle 7 (Dual-Axis Constraints) makes Think+Do thinking a first-class design concern

## Red Line Classification

| # | Red Line | Stakes | Mechanically Checkable? | Current Axis | Do Mechanism |
|---|----------|--------|------------------------|-------------|-------------|
| R1 | No platform-specific tool names | High | Yes — grep for tool name patterns | Think only | **Gap**: Add verification script to scan produced skill for platform-specific names |
| R2 | No "You are an expert..." role assignments | Medium | Yes — grep pattern | Think only | Acceptable: medium stakes, grep-checkable at review |
| R3 | No SKILL.md body > 2000w without decomposition | High | Yes — `wc -w` | Think only | **Gap**: Add verification script (`wc -w` check) |
| R4 | No subjective acceptance criteria | Medium | Partial — heuristic scan for vague words | Think only | Acceptable: hard to fully automate |
| R5 | No uncheckable red lines | Medium | Meta — requires human judgment | Think only | Acceptable: inherently cognitive |
| R6 | No workflow file > 2000w without phase-gating | High | Yes — `wc -w` | Think only | **Gap**: Add verification script (`wc -w` per file) |
| R7 | No assumption of pre-installed tools | Medium | Partial — scan for install/setup commands | Think only | Acceptable: requires contextual judgment |
| R8 | No step completes without artifact | High | Yes — file existence check | Think + Do | **Already enforced**: artifact gate tables in both workflows |
| R9 | No domain research with < 5 sources | High | Yes — count source entries | Think + Do | **Already enforced**: Research Minimums gate in domain-research-guide.md |
| R10 | No high-stakes red line left cognitive-only | High | Yes — constraint plan artifact | Think + Do | **Already enforced**: `build/constraint-enforcement-plan.md` gate |

## Enforcement Ratio

- **Think + Do**: R8, R9, R10 = 3/10 = **30%**
- **Think only (gaps)**: R1, R3, R6 = 3 high-stakes items without Do enforcement
- **Think only (acceptable)**: R2, R4, R5, R7 = 4 items where cognitive is appropriate

## Top 3 Upgrade Candidates (highest stakes, easiest to automate)

### 1. R3 + R6: Token budget enforcement (combined)

**Problem**: Word count limits (2000w for SKILL.md body, 2000w per workflow file) are purely cognitive — agent can write oversized files without detection.

**Mechanism**: Verification script that checks word counts of all produced files.

```bash
# scripts/verify-token-budget.sh
# Checks SKILL.md body ≤ 2000w and each references/*.md ≤ 2000w
```

**Trigger**: Run after Step 6 (Create the Skill) in new-workflow, and after Phase 3 (Execution) in boost-workflow.

### 2. R1: Platform-specific tool name detection

**Problem**: Skill may contain "Bash", "Edit", "Read" etc. as tool instructions instead of semantic verbs. Purely cognitive constraint.

**Mechanism**: Verification script that greps for known platform-specific tool names in SKILL.md and references/.

```bash
# scripts/verify-platform-names.sh  
# Greps for: Bash, Edit, Write, Read, Grep, Glob, Agent, WebFetch (as tool invocations, not prose references)
```

**Trigger**: Run during Step 8 (Cross-Platform Validation) in new-workflow, and Phase 1.5 in boost-workflow.

### 3. Artifact gate content verification (strengthen existing R8)

**Problem**: Current artifact gates check file existence but not content quality. Agent can create a near-empty file to pass the gate.

**Mechanism**: Strengthen artifact gates from "weak" (file exists) to "medium" (file contains required sections with minimum content).

**Implementation**: Update gate conditions in workflow files to specify required section headings and minimum item counts. Example: `build/domain-research.md` must contain ≥5 `### Source` sections.

## Recommended Do-Axis Mechanisms for MSC

Based on the analysis above, MSC should implement these 3 structural mechanisms:

1. **`scripts/verify-token-budget.sh`** — Enforces R3 + R6 via word count checks
2. **`scripts/verify-platform-names.sh`** — Enforces R1 via pattern scanning
3. **Strengthened artifact gate conditions** — Enforces R8 at medium strength (section headings + minimum content)

These 3 mechanisms raise MSC's enforcement ratio from 30% (3/10) to 60% (6/10 red lines with Do-axis enforcement).
