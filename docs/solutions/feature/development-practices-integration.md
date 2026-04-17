# Development Practices Integration

**Date**: 2026-04-17
**Category**: feature
**Tags**: principles, ADR, CHANGELOG, enforcement, token-budget
**Commit**: defbc84

## Problem

MSC had 7 design philosophy principles and 10 red lines — both focused on skill design quality. Missing: engineering discipline rules (dependency management, backward compatibility, decision recording, testing, secrets safety). 13 principles from production experience needed a structured home.

## Root Cause

Design philosophy ("how to design") and engineering practices ("how to develop") are distinct categories. MSC had formalized the first but not the second. Without codified practices, engineering discipline depended on individual memory across sessions.

## Solution

**Thin declaration + distributed enforcement** pattern:
- SKILL.md: 10 one-line principle declarations with P-IDs (always loaded, ~150w)
- `references/development-practices.md`: full rules, ADR template, CHANGELOG spec (on-demand, 879w)
- `new-workflow.md`: 6 "Dev Practice" checkpoints at Steps 1, 2, 3, 5, 6, 8
- `boost-workflow.md`: backward compat + ADR audit in Phase 1.1 and 1.9
- 3 new Red Lines for hard constraints (ADR, backward compat, secrets)
- 2 conditional practices (P9 security layering, P11 anti-duplicate counting) in reference only

Key mechanisms introduced:
- **ADR** (Architecture Decision Records) for architecture decisions and non-decisions
- **Hybrid CHANGELOG** format: narrative header (≤5 lines) + Keep a Changelog categories

## What Worked

- **Compression-before-addition**: new-workflow.md at 1994/2000w, freed 100w through targeted compression before adding 90w of checkpoints. Ended at exactly 2000w.
- **Table format for principles**: reference file at 879w vs estimated 1450-2150w for prose format. Tables compress ~60%.
- **Adversarial review**: caught P-ID traceability gap (F1) and artifact count mismatch (F2) — both fixed before ship.
- **Level A/B classification**: distinguishing MSC-self vs produced-skill scope prevented over-engineering.

## What Didn't Work / Surprises

- **Word count estimate drift**: requirements said "~100w" for SKILL.md section, actual was ~150w. The 100w estimate was arithmetic fiction (11 lines × 15w/line ≠ 100w).
- **new-workflow.md ceiling**: file hit exactly 2000w, zero headroom. Future additions require structural changes (split file or deeper compression).
- **"9 principles" count confusion**: requirements said 9 but P-ID enumeration gave 10 visible items. P4+P5 merge counted as 1 in the abstract but displayed as 1 line.

## Prevention

- Run word count verification BEFORE estimating budget impact in requirements
- When a file is >95% of its word budget, flag it as "at ceiling" in the requirements doc
- Keep P-IDs stable across all documents — define the canonical ID list once and reference it everywhere

## Generalized Pattern

**Thin-declaration + Distributed-enforcement**: For principles/rules that need to be visible (always loaded) but detailed (lots of context), declare them in one line at the router layer and enforce them via checkpoints embedded in the workflow steps where they're relevant. Full details go in a reference file loaded on-demand.
