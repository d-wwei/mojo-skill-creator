# Artifact Gate System — Anti-Laziness Design Spec

## Problem

Agents executing mojo-skill-creator's `boost` and `new` workflows cut corners:
1. Complete architecture fixes (Phase 2.1) then skip content upgrades (Phase 2.3)
2. Perform shallow research — should study 12 sources, only study 3
3. Claim "research found no significant gaps" to justify skipping content work
4. Self-fill Boost Report verification checkboxes without running actual checks

Root cause: workflows describe steps narratively with no enforcement. No mandatory artifacts, no gates, no minimum research thresholds.

## Solution: Step-Level Artifact Gates

Every step produces a **mandatory named artifact** (written to a file). The next step must **reference the previous artifact**. The final report must **cite all artifacts** — any missing artifact makes the report incomplete.

**Directory convention**: `diagnosis/` (boost) and `build/` (new) are created inside the **target skill's** root directory — the skill being boosted or created, not inside mojo-skill-creator itself.

Three layers of reinforcement:
1. **SKILL.md red lines** (always loaded) — 2 new anti-laziness constraints
2. **Workflow artifact tables** (loaded per sub-command) — exact artifact path + gate condition per step
3. **Research minimums** (in domain-research-guide.md) — quantitative floor for research quality

## Changes

### 1. SKILL.md — 2 New Red Lines

Add after existing 7 red lines:

```markdown
- No phase/step completed without its mandatory artifact written to the target skill's diagnosis/ (boost) or build/ (new) directory. Check: artifact file exists at declared path before proceeding to next phase/step
- No domain research step completed with fewer than 5 independent sources studied and documented. Check: research artifact contains ≥ 5 source entries each with name, key finding, and implication for the skill
```

Token cost: ~50 words added to always-loaded SKILL.md.

### 2. boost-workflow.md — Artifact Gates

#### Phase 1: Diagnosis Artifacts

| Step | Mandatory Artifact | Gate Condition |
|------|--------------------|----------------|
| 1.1 Structural Audit | `diagnosis/structural-audit.md` | File contains 7-item check table with pass/fail per item |
| 1.2 Knowledge Layer | `diagnosis/layer-diagnosis.md` | File states layer number (1/2/3) with evidence for the test that determined it |
| 1.3 Context Efficiency | `diagnosis/token-audit.md` | File contains word counts for SKILL.md body, always-loaded total, each reference file |
| 1.4 Observability | (optional — no artifact required) | — |
| 1.5 Platform Check | `diagnosis/platform-check.md` | File lists platform-specific terms found (or explicitly "none found" with search method described) |
| 1.6 Self-Evolution | (optional — no artifact required) | — |
| 1.7 Domain Research | `diagnosis/domain-research.md` | File contains ≥ 5 source entries (see Research Minimums below) AND an expert-vs-skill workflow mapping table |
| 1.8 Synthesis | `diagnosis/synthesis.md` | File references findings from ALL prior diagnosis artifacts by filename. Answers 3 rethinking questions with evidence. |

**Phase 1 Exit Gate**: ALL mandatory artifacts listed above must exist in `diagnosis/`. `synthesis.md` must contain cross-references to each prior artifact's key findings. Do NOT proceed to Phase 2 until this gate passes.

#### Phase 2: Prescription Artifact Updates

Phase 2 does not create new files — it appends sections to `diagnosis/synthesis.md`:

| Step | Section Added to synthesis.md | Gate Condition |
|------|-------------------------------|----------------|
| 2.1 Architecture Fixes | `## Architecture Prescription` | Lists each defect from structural-audit.md with planned fix |
| 2.2 Mechanical Fixes | `## Mechanical Prescription` | Lists each issue from platform-check.md with planned fix |
| 2.3 Content Upgrades | `## Content Prescription` | CANNOT be empty. If no content upgrades are prescribed, this section must contain: (a) the specific expert workflow from 1.7 that validates the current skill workflow, (b) an explicit claim that the current knowledge layer is appropriate with evidence, (c) a token efficiency assessment confirming no compression opportunities. A bare "no upgrades needed" without this evidence is a red line violation. |

**Phase 2 Exit Gate**: `synthesis.md` has all three prescription sections. Section 2.3 is substantive (not a bare dismissal). Do NOT proceed to Phase 3 until this gate passes.

#### Phase 3: Execution Verification

After executing each fix category, append verification results to `diagnosis/synthesis.md`:

| After | Verification Appended |
|-------|-----------------------|
| Architecture fixes | `## Verification: Architecture` — re-run §1.1, paste results |
| Mechanical fixes | `## Verification: Mechanical` — re-run §1.5, paste results |
| Content upgrades | `## Verification: Content` — re-run §1.2 + §1.3, paste results. If case assets added, paste specificity test results. |

**Phase 3 Exit Gate**: All applicable verification sections exist in `synthesis.md` with actual check outputs (not "should pass").

#### Phase 4: Boost Report Gate

The Boost Report template gains a new mandatory section:

```markdown
### Artifact Manifest
| Artifact | Path | Status |
|----------|------|--------|
| Structural Audit | diagnosis/structural-audit.md | Present |
| Layer Diagnosis | diagnosis/layer-diagnosis.md | Present |
| Token Audit | diagnosis/token-audit.md | Present |
| Platform Check | diagnosis/platform-check.md | Present |
| Domain Research | diagnosis/domain-research.md | Present (N sources) |
| Synthesis | diagnosis/synthesis.md | Present (sections: ...) |
```

**Report Gate**: Every mandatory artifact must be listed with "Present" status. Missing artifacts = report is incomplete = boost is not done.

### 3. new-workflow.md — Artifact Gates

| Step | Mandatory Artifact | Gate Condition |
|------|--------------------|----------------|
| Step 1: Examples | `build/examples.md` | Contains 3-5 concrete examples with input/output/failure cases |
| Step 2: Research | `build/domain-research.md` | Contains ≥ 5 source entries (same format as boost) + research synthesis |
| Step 3: Red Lines | `build/red-lines-and-criteria.md` | Contains ≥ 5 red lines + ≥ 3 acceptance criteria + stance definition |
| Step 4: Token Arch | `build/token-architecture.md` | Contains layer budget table + sub-command decisions + token declarations |
| Step 5: Resources | `build/resource-plan.md` | Lists planned scripts/, references/, assets/ with justification per item |
| Step 6: Create | (the skill files themselves are the artifact) | SKILL.md + references/ exist per plan |
| Step 7: Observability | (optional — no artifact required) | — |
| Step 7b: Self-Evolution | (optional — no artifact required) | — |
| Step 8: Validation | `build/validation-checklist.md` | 8-item validation checklist with pass/fail per item |
| Step 9: Iterate | (no separate artifact — iteration feeds back to prior steps) | — |

**Step Gate Rule**: Do NOT proceed to Step N+1 until Step N's artifact exists and meets its gate condition.

**Final Gate**: Before declaring a new skill complete, all artifacts in `build/` must exist. The skill's SKILL.md must trace its red lines, stance, and workflow structure back to the research synthesis in `build/domain-research.md`.

### 4. domain-research-guide.md — Research Minimums

Add a new section:

```markdown
## Research Minimums

These thresholds are mechanically checkable (red line in SKILL.md).

**Source count**: ≥ 5 independent sources. "Independent" means different authors, organizations, or projects. Five links from the same blog do not count as 5 sources.

**Source record format** (per source):

| Field | Required | Purpose |
|-------|----------|---------|
| Source name + URL/reference | Yes | Traceability |
| Key finding (1-2 sentences) | Yes | What this source reveals about expert practice |
| Implication for this skill (1 sentence) | Yes | How this finding should influence the skill's design |

**Expert workflow mapping**: At least one source must provide a detailed enough workflow to produce a step-by-step comparison table:

| Expert Phase | Skill Step | Gap |
|-------------|-----------|-----|
| ... | ... | ... |

**"No significant gap" claim**: If concluding that the skill's workflow already matches expert practice, the research artifact must cite the specific expert workflow that validates this conclusion, with the mapping table showing alignment. A bare assertion of "no gaps found" without this evidence violates the research minimum red line.
```

## Token Budget Impact

| File | Before (words) | After (words) | Delta |
|------|----------------|---------------|-------|
| SKILL.md | ~500 | ~550 | +50 |
| boost-workflow.md | ~1850 | ~2150 | +300 |
| new-workflow.md | ~1800 | ~2050 | +250 |
| domain-research-guide.md | ~930 | ~1080 | +150 |

All files remain within the ≤ 2000 word guideline (SKILL.md) or close to it (workflows approach 2100-2150, acceptable per "适当放宽" constraint).

## Verification Plan

1. **Mechanical check**: After implementation, count words in each modified file. Confirm within budget.
2. **Structural check**: Read each modified file and verify artifact tables, gate conditions, and research minimums are present and consistent across files.
3. **Integration test**: Use the boosted mojo-skill-creator to boost a real skill. Observe whether the agent:
   - Creates diagnosis/ directory and writes artifacts per step
   - Cannot skip Phase 2.3 content upgrades
   - Produces domain research with ≥ 5 sources
   - Generates a Boost Report with artifact manifest
