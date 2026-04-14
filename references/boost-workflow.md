# `boost` — Upgrade an Existing Skill

Complete workflow for diagnosing and improving an existing agent skill. Takes a skill from its current quality level to the next, using structured diagnosis and targeted intervention.

**Distribution principle**: Boosted skills are designed for redistribution. All upgrades must keep the skill self-contained — end users receive a complete package that works without prior setup.

---

## Prerequisites

- Path to the existing skill directory (containing SKILL.md)
- Access to read all skill files (SKILL.md, references/, scripts/, assets/)
- Optional: examples of the skill's current output (helps diagnosis)

## Loading Strategy

Load Layer 3 references one at a time per phase, not all at once:
- Phase 1.2 → load `quality-ladder.md`, release after diagnosis
- Phase 1.5 → load `platform-adaptation.md`, release after check
- Phase 1.6 → load `se-kit-integration.md` if self-evolution is relevant, release after
- Phase 1.7 → no reference needed (uses web search / file reading for domain research)
- Phase 1.8 → no reference needed (synthesis of all prior findings)
- Phase 2.1 → load `anti-patterns-by-domain.md` for red-line design
- Phase 2.3 → load `quality-ladder.md` for upgrade path, release, then load `se-kit-integration.md` if needed

Always release one reference before loading the next. This keeps simultaneous context under 2500 words (boost-workflow + one reference at a time).

---

## Phase 1: Diagnosis

### Phase 1 Artifacts (Mandatory)

Each diagnosis step writes its findings to the target skill's `diagnosis/` directory. All artifacts must exist before proceeding to Phase 2.

| Step | Artifact | Gate Condition |
|------|----------|----------------|
| 1.1 | `diagnosis/structural-audit.md` | 7-item check table with pass/fail per item |
| 1.2 | `diagnosis/layer-diagnosis.md` | Layer number (1/2/3) with test evidence |
| 1.3 | `diagnosis/token-audit.md` | Word counts: SKILL.md body, always-loaded total, each reference |
| 1.4 | (optional — no artifact) | — |
| 1.5 | `diagnosis/platform-check.md` | Platform-specific terms found, or "none found" with search method |
| 1.6 | (optional — no artifact) | — |
| 1.7 | `diagnosis/domain-research.md` | ≥ 5 source entries + expert-vs-skill workflow mapping table |
| 1.8 | `diagnosis/synthesis.md` | Cross-references ALL prior artifacts. Answers 3 rethinking questions with evidence. |

### 1.1 Structural Audit

Read the skill's full directory and check:

| Check | Pass Criteria | Defect Type |
|-------|--------------|-------------|
| SKILL.md exists with valid frontmatter | `name` and `description` present | Architecture |
| Description has specific trigger phrases | ≥ 3 concrete phrases in third person | Architecture |
| Red lines section exists | ≥ 5 mechanically checkable constraints | Architecture |
| Acceptance criteria section exists | ≥ 3 testable criteria from user perspective | Architecture |
| Stance defined (not role) | Cognitive position, not "You are an expert..." | Architecture |
| Referenced files exist | All paths in SKILL.md point to real files | Mechanical |
| Writing style: imperative form | No "you should" / "you need to" | Mechanical |

**Output**: List of structural defects with type classification.
**Artifact**: Write output to `diagnosis/structural-audit.md`.

### 1.2 Knowledge Layer Diagnosis

Determine which layer the skill currently operates at.

**Layer 1 Test (Principles)**:
Give the skill two very different tasks within its domain. Compare outputs.
- If outputs differ only in surface content (topic words, colors) but share identical structure, rhythm, and patterns → **Layer 1**

**Layer 2 Test (Patterns)**:
Ask the skill to work "in the style of [specific reference]."
- If it captures the general category but misses specific parameters (exact values, characteristic details) → **Layer 2**

**Layer 3 Test (Cases)**:
Produce output in a reference style, then introduce a deliberate error.
- If the skill auto-detects and corrects → **Layer 3**

**Output**: Current layer (1, 2, or 3) with evidence.
**Artifact**: Write output to `diagnosis/layer-diagnosis.md`.

### 1.3 Context Efficiency Audit

Measure the skill's token footprint:

1. Count words in SKILL.md body (excluding frontmatter)
2. Identify which references get loaded on every invocation
3. Calculate total always-loaded token cost

**Thresholds**:

| Metric | Healthy | Needs Work |
|--------|---------|-----------|
| SKILL.md body | ≤ 2000 words | > 2000 words |
| Always-loaded total | ≤ 3000 words | > 3000 words |
| Single reference file | ≤ 5000 words | > 5000 words |
| Layer 1 (router) content | ≤ 500 words | > 500 words |

**Output**: Token metrics and compression opportunities.
**Artifact**: Write output to `diagnosis/token-audit.md`.

### 1.4 Human Observability Audit (Optional)

For analysis/decision-type skills:
- Does the skill produce durable artifacts? (Markdown docs, reports)
- Can a human trace the decision chain after execution?
- Are quality verification results recorded?

**Output**: Observability gap assessment (if applicable).

### 1.5 Cross-Platform Compatibility Check

Scan all skill files for:
- Platform-specific tool names (check against `platform-adaptation.md` mapping table)
- Absolute paths that assume a specific platform
- Features requiring capabilities not available on all target platforms (e.g., sub-agent dispatch)

**Output**: Platform compatibility issues list.
**Artifact**: Write output to `diagnosis/platform-check.md`.

### 1.6 Self-Evolution Audit (Optional)

Check if the skill would benefit from runtime self-evolution:

1. **Already integrated?** Look for `se-kit/` directory and `se-workspace/` in the skill
2. **If integrated**: Check `se-kit/SKILL.md` version against latest skill-se-kit release. If outdated, flag for upgrade in Phase 2
3. **If not integrated**: Assess whether the skill type benefits from learning (analysis/creative → yes, tool/transformation → usually no)
4. **If integrated and has data**: Review `se-workspace/skill_bank.json` — are accumulated skills being used? Is the experience log growing?
5. **Token budget check**: For skills targeting platforms without sub-agent support, the se-kit protocol adds ~3400 words to main session context. Factor this into the context efficiency assessment (Phase 1.3). If total always-loaded context would exceed 5000 words, weigh whether self-evolution is worth the cost.

**Output**: Self-evolution status (not integrated / integrated + current / integrated + outdated / integrated + underused) with recommendation.

### 1.7 Domain Best Practice Research

**This is the highest-leverage diagnostic step.** Follow `domain-research-guide.md` for the complete process. Key actions for boost context:

1. Identify the domain and find current best practitioners
2. Study their workflows, principles, and quality standards
3. **Compare** the skill's current workflow against expert workflow — map steps, find missing phases, identify emphasis mismatches
4. Cross-disciplinary scan for structural insights

**Output**: Research summary with expert workflow mapping and gaps.
**Artifact**: Write output to `diagnosis/domain-research.md`. Must contain ≥ 5 source entries per Research Minimums in `domain-research-guide.md`.

### 1.8 Research Synthesis

After all diagnostic steps (1.1–1.7), synthesize before prescribing. Follow the "Synthesis: Rethink Before Proceeding" section in `domain-research-guide.md`, plus:

1. **Does the skill's workflow need structural redesign?** If the gap between current workflow and expert workflow is structural (missing phases, wrong sequence), content polish won't fix it.
2. **Are the skill's principles still valid?** Cross-disciplinary insights may reveal the approach is misframed.
3. **What does the quality bar actually look like?** Combine knowledge layer diagnosis (1.2) with expert standards (1.7).

**Output**: Integrated diagnosis — determines whether Phase 2 prescribes surface fixes or fundamental redesign.
**Artifact**: Write output to `diagnosis/synthesis.md`. Must reference findings from ALL prior diagnosis artifacts by filename.

### Phase 1 Exit Gate

Before proceeding to Phase 2, verify ALL mandatory artifacts exist in `diagnosis/`:

- [ ] `diagnosis/structural-audit.md` — contains 7-item check table
- [ ] `diagnosis/layer-diagnosis.md` — states layer with evidence
- [ ] `diagnosis/token-audit.md` — contains word count metrics
- [ ] `diagnosis/platform-check.md` — lists issues or confirms clean
- [ ] `diagnosis/domain-research.md` — contains ≥ 5 sources + workflow mapping
- [ ] `diagnosis/synthesis.md` — cross-references all artifacts, answers 3 rethinking questions

Do NOT proceed to Phase 2 until every checkbox above can be checked. Missing artifacts = incomplete diagnosis.

---

## Phase 2: Prescription

Based on the integrated diagnosis from Phase 1.8, generate a targeted improvement plan. If the synthesis concluded that a structural redesign is needed, the prescription starts there — not with surface fixes.

Defects are addressed in strict order: Architecture → Mechanical → Content.

### Phase 2 Artifacts

Phase 2 does not create new files. It appends prescription sections to `diagnosis/synthesis.md`.

| Step | Section Added to synthesis.md | Gate Condition |
|------|-------------------------------|----------------|
| 2.1 | `## Architecture Prescription` | Lists each defect from structural-audit.md with planned fix |
| 2.2 | `## Mechanical Prescription` | Lists each issue from platform-check.md with planned fix |
| 2.3 | `## Content Prescription` | CANNOT be empty — see gate rule below |

**Phase 2.3 Anti-Skip Rule**: Section 2.3 Content Prescription CANNOT be a bare dismissal. If no content upgrades are prescribed, this section must contain ALL of: (a) the specific expert workflow from 1.7 that validates the current skill workflow, (b) an explicit claim that the current knowledge layer is appropriate with evidence from 1.2, (c) a token efficiency assessment from 1.3 confirming no compression opportunities. Omitting this evidence is a red line violation.

### 2.1 Architecture Fixes (if any)

These block everything else. Fix first.

| Common Fix | Action |
|-----------|--------|
| Missing red lines | Design 5-10 constraints using domain anti-patterns (`anti-patterns-by-domain.md`) |
| Missing acceptance criteria | Write 3-5 testable criteria from user perspective |
| Role instead of stance | Rewrite identity statement as cognitive position |
| Missing layer structure | Restructure: thin SKILL.md router + references/ for workflows |
| Token budget violation | Move content from SKILL.md to references/ |

**Artifact**: Append `## Architecture Prescription` to `diagnosis/synthesis.md`, listing each defect from `diagnosis/structural-audit.md` with its planned fix.

### 2.2 Mechanical Fixes (if any)

Same error × many locations. Fix before content rewrite.

| Common Fix | Action |
|-----------|--------|
| Platform-specific tool names | Replace with semantic verbs throughout |
| Broken cross-references | Fix paths or remove dead references |
| Inconsistent terminology | Find-and-replace to standardize |
| Second-person writing style | Replace "you should" with imperative form |

**Artifact**: Append `## Mechanical Prescription` to `diagnosis/synthesis.md`, listing each issue from `diagnosis/platform-check.md` with its planned fix.

### 2.3 Content Upgrades (based on knowledge layer + domain research)

**Workflow Redesign** (from Phase 1.7 research):

If the domain research revealed a significant gap between the skill's workflow and expert workflow, the workflow itself needs restructuring — not just content polishing. This is the highest-impact upgrade:

1. Map the expert workflow phases to the skill's workflow steps
2. Add missing phases (e.g., experts have "exploration before commitment" — add it)
3. Adjust phase emphasis (e.g., experts spend most time on research — increase the skill's research step)
4. Incorporate expert quality standards as new red lines
5. Update the skill's stance to reflect the expert mindset discovered in research

**Layer 1 → Layer 2 upgrade** (add patterns):

1. Identify the 3-5 most common scenario types the skill handles
2. For each scenario type, document (informed by expert practice from Phase 1.7):
   - Structural pattern (what the output typically looks like)
   - Key parameters that distinguish this scenario
   - Common pitfalls specific to this scenario (especially those mentioned by domain experts)
3. Add scenario detection to the workflow: "Identify which scenario type applies before proceeding"

**Layer 2 → Layer 3 upgrade** (add cases):

1. Build a case asset library (consult `quality-ladder.md` for methodology):
   - Start with 3-5 benchmark cases from the domain leaders identified in Phase 1.7
   - Add 10-15 working-level cases (well-researched)
2. Each case must cover four dimensions: parameters, operation guide, quality floor, intuition check
3. Apply the specificity test: remove the case name — can someone still identify it?
4. Integrate cases into the workflow: "Match input to the closest reference case before generating"

**Context Efficiency upgrade**:

1. Identify content in SKILL.md body that is only needed for specific sub-commands or scenarios
2. Move conditional content to references/ with clear loading triggers
3. Replace prose explanations with tables where information density allows
4. Externalize lookup tables as scripts if they exceed 500 words

**Observability upgrade** (if recommended):

1. Define artifact template for the skill's output type
2. Add artifact generation step to the workflow's delivery phase
3. Specify output path convention

**Self-evolution upgrade** (if recommended from Phase 1.6):

- Not integrated + skill type benefits → integrate following `se-kit-integration.md`
- Integrated + outdated → replace `se-kit/` contents with latest skill-se-kit release files. Per-skill data in `se-workspace/` is preserved (schemas are backward-compatible)
- Integrated + underused → check if the self-evolution instructions in SKILL.md are clear enough for the agent to follow; strengthen if needed

**Artifact**: Append `## Content Prescription` to `diagnosis/synthesis.md`. This section is subject to the Phase 2.3 Anti-Skip Rule above.

### Phase 2 Exit Gate

Before proceeding to Phase 3, verify `diagnosis/synthesis.md` contains ALL three prescription sections:

- [ ] `## Architecture Prescription` — lists defects with planned fixes
- [ ] `## Mechanical Prescription` — lists issues with planned fixes
- [ ] `## Content Prescription` — substantive content (not a bare dismissal). If "no upgrades needed," must include expert workflow validation + layer evidence + token assessment.

Do NOT proceed to Phase 3 until all sections are present and substantive.

---

## Phase 3: Execution

### Repair Order (MANDATORY)

```
1. Architecture fixes    → Manual, precise edits
2. Mechanical fixes      → Batch/script operations
3. Content upgrades      → Section-by-section rewrite with quality verification
```

**Never reverse this order.** Mechanical batch fixes can overwrite hand-crafted content upgrades. Architecture defects invalidate downstream work.

### Quality Verification After Each Fix Category

After architecture fixes:
- Re-run structural audit (§1.1) — all checks should pass

After mechanical fixes:
- Re-run cross-platform check (§1.5) — no platform-specific terms
- Verify all cross-references resolve

After content upgrades:
- Re-run knowledge layer diagnosis (§1.2) — layer should have advanced
- Re-run context efficiency audit (§1.3) — metrics should improve or hold steady
- If case assets were added, run specificity test on each

**Artifact**: After each fix category, append a verification section to `diagnosis/synthesis.md`:
- After architecture fixes: `## Verification: Architecture` — paste re-run of §1.1 results
- After mechanical fixes: `## Verification: Mechanical` — paste re-run of §1.5 results
- After content upgrades: `## Verification: Content` — paste re-run of §1.2 + §1.3 results. If case assets added, paste specificity test results.

### Phase 3 Exit Gate

All applicable verification sections must exist in `diagnosis/synthesis.md` with actual command/check outputs. "Should pass" or "looks good" without pasted evidence is a red line violation.

---

## Phase 4: Boost Report

After completing all fixes, generate a summary:

```markdown
## Boost Report: [skill-name]

### Diagnosis Summary
- Structural defects found: [N] (architecture: [n], mechanical: [n])
- Knowledge layer: [before] → [after]
- Token footprint: [before words] → [after words]
- Platform compatibility issues: [N]
- Domain research: [domain leaders studied, key workflow gaps found]

### Changes Made
1. [Category]: [what changed and why]
2. ...

### Remaining Opportunities
- [What could be improved in a future boost cycle]

### Verification
- [ ] Structural audit: all pass
- [ ] Knowledge layer: advanced to [N]
- [ ] Token budget: within thresholds
- [ ] Cross-platform: clean
- [ ] Red lines: ≥ 5, all mechanically checkable
- [ ] Acceptance criteria: ≥ 3, all testable

### Artifact Manifest

Every mandatory artifact must be listed with "Present" status. Missing artifacts = report incomplete = boost not done.

| Artifact | Path | Status |
|----------|------|--------|
| Structural Audit | diagnosis/structural-audit.md | [Present/Missing] |
| Layer Diagnosis | diagnosis/layer-diagnosis.md | [Present/Missing] |
| Token Audit | diagnosis/token-audit.md | [Present/Missing] |
| Platform Check | diagnosis/platform-check.md | [Present/Missing] |
| Domain Research | diagnosis/domain-research.md | [Present/Missing] (N sources) |
| Synthesis | diagnosis/synthesis.md | [Present/Missing] (sections: list all) |
```

This report serves as the human-auditable artifact for the boost process itself.

**Report Gate**: The Artifact Manifest must list ALL mandatory artifacts with "Present" status. If any artifact is "Missing", the report is incomplete and the boost is not done. Do not declare completion until the manifest is fully populated.
