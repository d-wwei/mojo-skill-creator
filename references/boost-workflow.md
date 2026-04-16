# `boost` — Upgrade an Existing Skill

Complete workflow for diagnosing and improving an existing agent skill. Takes a skill from its current quality level to the next, using structured diagnosis and targeted intervention.

**Distribution principle**: Boosted skills are designed for redistribution. All upgrades must keep the skill self-contained — end users receive a complete package that works without prior setup.

---

## Prerequisites

- Path to existing skill directory (with SKILL.md) and read access to all skill files
- Optional: examples of current output

## Loading Strategy

Load one reference at a time; release before loading next. Target: ≤ 2500 words simultaneous context.

| Phase | Load | Notes |
|-------|------|-------|
| 1.2 | `quality-ladder.md` | Release after diagnosis |
| 1.5 | `platform-adaptation.md` | Release after check |
| 1.6 | `se-kit-integration.md` | Only if self-evolution relevant |
| 1.7–1.8 | (none) | Web search / synthesis only |
| 2.1 | `anti-patterns-by-domain.md` | For red-line design |
| 2.3 | `quality-ladder.md`, then `se-kit-integration.md` | Sequential, not simultaneous |

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
| 1.9 | `diagnosis/constraint-enforcement-audit.md` | Enforcement ratio calculated + top 3 Think-only constraints identified |

### 1.1 Structural Audit

| Check | Pass Criteria | Defect Type |
|-------|--------------|-------------|
| SKILL.md exists with valid frontmatter | `name` and `description` present | Architecture |
| Description has specific trigger phrases | ≥ 3 concrete phrases in third person | Architecture |
| Red lines section exists | ≥ 5 mechanically checkable constraints | Architecture |
| Acceptance criteria section exists | ≥ 3 testable criteria from user perspective | Architecture |
| Stance defined (not role) | Cognitive position, not "You are an expert..." | Architecture |
| Referenced files exist | All paths in SKILL.md point to real files | Mechanical |
| Writing style: imperative form | No "you should" / "you need to" | Mechanical |

**Artifact**: `diagnosis/structural-audit.md` — defect list with type classification.

### 1.2 Knowledge Layer Diagnosis

- **Layer 1 test**: Two different tasks → if outputs share identical structure/rhythm despite different topics → Layer 1.
- **Layer 2 test**: "In the style of [reference]" → if it captures category but misses specific parameters → Layer 2.
- **Layer 3 test**: Output in reference style + deliberate error → if skill auto-detects and corrects → Layer 3.

**Artifact**: `diagnosis/layer-diagnosis.md` — layer number (1/2/3) with test evidence.

### 1.3 Context Efficiency Audit

Count words in SKILL.md body (excl. frontmatter), always-loaded references, and total. Evaluate against thresholds:

| Metric | Healthy | Needs Work |
|--------|---------|-----------|
| SKILL.md body | ≤ 2000 words | > 2000 words |
| Always-loaded total | ≤ 3000 words | > 3000 words |
| Single reference file | ≤ 5000 words | > 5000 words |
| Layer 1 (router) content | ≤ 1000 words | > 1000 words |

**Artifact**: `diagnosis/token-audit.md` — word counts + compression opportunities.

### 1.4 Human Observability Audit (Optional)

For analysis/decision-type skills: check for durable artifacts, traceable decision chains, and recorded verification results.

### 1.5 Cross-Platform Compatibility Check

Scan all skill files for platform-specific tool names, absolute paths, and platform-dependent features (see `platform-adaptation.md` mapping table).

**Artifact**: `diagnosis/platform-check.md` — issues list or "clean."

### 1.6 Self-Evolution Audit (Optional)

Check for `se-kit/` and `se-workspace/` directories. Classify: not integrated / integrated + current / integrated + outdated / integrated + underused. If not integrated, assess benefit (analysis/creative → yes, tool/transformation → usually no). If integrated, check version against latest release and whether `skill_bank.json` is being used. Note: se-kit adds ~3400 words — factor into 1.3 token budget.

### 1.7 Domain Best Practice Research

**Highest-leverage step.** Follow `domain-research-guide.md` completely — identify domain experts, study workflows, compare against skill's current workflow, cross-disciplinary scan.

**Artifact**: `diagnosis/domain-research.md` — ≥ 5 source entries + expert-vs-skill workflow mapping per Research Minimums in `domain-research-guide.md`.

### 1.8 Research Synthesis

Synthesize all findings (1.1–1.7) before prescribing. Follow `domain-research-guide.md` § "Synthesis: Rethink Before Proceeding." Answer: (1) Does the workflow need structural redesign? (2) Are the skill's principles still valid? (3) What does the quality bar look like (1.2 + 1.7)?

**Artifact**: `diagnosis/synthesis.md` — must reference ALL prior diagnosis artifacts by filename. Determines surface fixes vs. fundamental redesign.

### 1.9 Constraint Enforcement Audit

Classify each red line by enforcement axis. Follow `constraint-enforcement-guide.md` § "In boost Workflow."

1. List all red lines from SKILL.md
2. For each: Think-only or Think+Do? If Do, what mechanism?
3. Calculate enforcement ratio
4. Identify top 3 highest-stakes Think-only constraints for upgrade

**Artifact**: Write to `diagnosis/constraint-enforcement-audit.md`.

### Phase 1 Exit Gate

Before proceeding to Phase 2, verify ALL mandatory artifacts exist in `diagnosis/`:

- [ ] `diagnosis/structural-audit.md` — contains 7-item check table
- [ ] `diagnosis/layer-diagnosis.md` — states layer with evidence
- [ ] `diagnosis/token-audit.md` — contains word count metrics
- [ ] `diagnosis/platform-check.md` — lists issues or confirms clean
- [ ] `diagnosis/domain-research.md` — contains ≥ 5 sources + workflow mapping
- [ ] `diagnosis/constraint-enforcement-audit.md` — enforcement ratio + top 3 upgrade candidates
- [ ] `diagnosis/synthesis.md` — cross-references all artifacts, answers 3 rethinking questions

Do NOT proceed to Phase 2 until every checkbox above can be checked. Missing artifacts = incomplete diagnosis.

---

## Phase 2: Prescription

Generate targeted improvement plan from Phase 1.8 synthesis. Strict order: Architecture → Mechanical → Content.

### Phase 2 Artifacts

Phase 2 does not create new files. It appends prescription sections to `diagnosis/synthesis.md`.

| Step | Section Added to synthesis.md | Gate Condition |
|------|-------------------------------|----------------|
| 2.1 | `## Architecture Prescription` | Lists each defect from structural-audit.md with planned fix |
| 2.2 | `## Mechanical Prescription` | Lists each issue from platform-check.md with planned fix |
| 2.3 | `## Content Prescription` | CANNOT be empty — see gate rule below |

**Phase 2.3 Anti-Skip Rule**: Section 2.3 CANNOT be a bare dismissal. If "no upgrades needed," must include: (a) expert workflow from 1.7 validating current workflow, (b) layer appropriateness claim with 1.2 evidence, (c) token assessment from 1.3. Omitting = red line violation.

### 2.1 Architecture Fixes (if any)

These block everything else. Fix first.

| Common Fix | Action |
|-----------|--------|
| Missing red lines | Design 5-10 constraints using domain anti-patterns (`anti-patterns-by-domain.md`) |
| Missing acceptance criteria | Write 3-5 testable criteria from user perspective |
| Role instead of stance | Rewrite identity statement as cognitive position |
| Missing layer structure | Restructure: thin SKILL.md router + references/ for workflows |
| Token budget violation | Move content from SKILL.md to references/ |

**Artifact**: Append `## Architecture Prescription` to `diagnosis/synthesis.md`.

### 2.2 Mechanical Fixes (if any)

| Common Fix | Action |
|-----------|--------|
| Platform-specific tool names | Replace with semantic verbs throughout |
| Broken cross-references | Fix paths or remove dead references |
| Inconsistent terminology | Find-and-replace to standardize |
| Second-person writing style | Replace "you should" with imperative form |

**Artifact**: Append `## Mechanical Prescription` to `diagnosis/synthesis.md`.

### 2.3 Content Upgrades (based on knowledge layer + domain research)

**Workflow Redesign** (if 1.7 revealed structural gaps):

1. Map expert phases → skill steps; add missing phases
2. Adjust phase emphasis to match expert time allocation
3. Incorporate expert quality standards as new red lines
4. Update stance to reflect expert mindset

**Layer 1 → Layer 2 upgrade** (add patterns):

Identify 3-5 scenario types. For each: structural pattern, key parameters, common pitfalls (informed by 1.7 expert practice). Add scenario detection step to workflow.

**Layer 2 → Layer 3 upgrade** (add cases):

Build case asset library per `quality-ladder.md` methodology: 3-5 benchmark cases from 1.7 domain leaders + 10-15 working-level cases. Each case: parameters, operation guide, quality floor, intuition check. Apply specificity test. Integrate: "Match input to closest case before generating."

**Context Efficiency upgrade**: Move conditional content from SKILL.md to references/. Replace prose with tables. Externalize lookup tables > 500 words as scripts.

**Observability upgrade** (if recommended): Define artifact template, add generation step to delivery phase, specify output path.

**Self-evolution upgrade** (if recommended from Phase 1.6): Not integrated → follow `se-kit-integration.md`. Outdated → replace `se-kit/` with latest release (data preserved). Underused → strengthen SKILL.md instructions.

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

| After | Re-run | Expected | Append to synthesis.md |
|-------|--------|----------|----------------------|
| Architecture fixes | §1.1 structural audit | All checks pass | `## Verification: Architecture` |
| Mechanical fixes | §1.5 platform check + cross-refs | No issues | `## Verification: Mechanical` |
| Content upgrades | §1.2 layer diagnosis + §1.3 token audit | Layer advanced, metrics hold/improve | `## Verification: Content` |

If case assets added, include specificity test results in content verification.

**Structural verification** (run after all fixes):
- `scripts/verify-token-budget.sh <skill-dir>` — word count limits
- `scripts/verify-platform-names.sh <skill-dir>` — platform-specific names
- `scripts/verify-artifact-content.sh <path> <type>` — artifact content quality
- `scripts/verify-artifact-content.sh diagnosis/constraint-enforcement-audit.md constraint-audit` — enforcement audit quality

### Phase 3 Exit Gate

All verification sections must exist in `diagnosis/synthesis.md` with actual command/script outputs. "Should pass" without pasted evidence is a red line violation.

---

## Phase 4: Boost Report

Generate a summary covering: diagnosis summary (defects, layer before→after, token footprint, platform issues, domain research gaps), changes made, remaining opportunities, and verification checklist (structural audit, layer, token budget, cross-platform, red lines ≥ 5, acceptance criteria ≥ 3).

### Artifact Manifest

| Artifact | Path | Status |
|----------|------|--------|
| Structural Audit | diagnosis/structural-audit.md | [Present/Missing] |
| Layer Diagnosis | diagnosis/layer-diagnosis.md | [Present/Missing] |
| Token Audit | diagnosis/token-audit.md | [Present/Missing] |
| Platform Check | diagnosis/platform-check.md | [Present/Missing] |
| Domain Research | diagnosis/domain-research.md | [Present/Missing] |
| Constraint Enforcement Audit | diagnosis/constraint-enforcement-audit.md | [Present/Missing] |
| Synthesis | diagnosis/synthesis.md | [Present/Missing] |

**Report Gate**: ALL mandatory artifacts must show "Present." Missing artifacts = boost not done.
