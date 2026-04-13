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
- Phase 2.1 → load `anti-patterns-by-domain.md` for red-line design
- Phase 2.3 → load `quality-ladder.md` again for upgrade path
- Phase 1.6 / 2.3 → load `se-kit-integration.md` if self-evolution is relevant

This keeps simultaneous context under 2500 words (boost-workflow + one reference).

---

## Phase 1: Diagnosis

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

### 1.4 Human Observability Audit (Optional)

For analysis/decision-type skills:
- Does the skill produce durable artifacts? (Markdown docs, reports)
- Can a human trace the decision chain after execution?
- Are quality verification results recorded?

**Output**: Observability gap assessment (if applicable).

### 1.6 Self-Evolution Audit (Optional)

Check if the skill would benefit from runtime self-evolution:

1. **Already integrated?** Look for `se-kit/` directory and `se-workspace/` in the skill
2. **If integrated**: Check `se-kit/SKILL.md` version against latest skill-se-kit release. If outdated, flag for upgrade in Phase 2
3. **If not integrated**: Assess whether the skill type benefits from learning (analysis/creative → yes, tool/transformation → usually no)
4. **If integrated and has data**: Review `se-workspace/skill_bank.json` — are accumulated skills being used? Is the experience log growing?

**Output**: Self-evolution status (not integrated / integrated + current / integrated + outdated / integrated + underused) with recommendation.

### 1.5 Cross-Platform Compatibility Check

Scan all skill files for:
- Platform-specific tool names (check against `platform-adaptation.md` mapping table)
- Absolute paths that assume a specific platform
- Features requiring capabilities not available on all target platforms (e.g., sub-agent dispatch)

**Output**: Platform compatibility issues list.

---

## Phase 2: Prescription

Based on diagnosis, generate a targeted improvement plan. Defects are addressed in strict order: Architecture → Mechanical → Content.

### 2.1 Architecture Fixes (if any)

These block everything else. Fix first.

| Common Fix | Action |
|-----------|--------|
| Missing red lines | Design 5-10 constraints using domain anti-patterns (`anti-patterns-by-domain.md`) |
| Missing acceptance criteria | Write 3-5 testable criteria from user perspective |
| Role instead of stance | Rewrite identity statement as cognitive position |
| Missing layer structure | Restructure: thin SKILL.md router + references/ for workflows |
| Token budget violation | Move content from SKILL.md to references/ |

### 2.2 Mechanical Fixes (if any)

Same error × many locations. Fix before content rewrite.

| Common Fix | Action |
|-----------|--------|
| Platform-specific tool names | Replace with semantic verbs throughout |
| Broken cross-references | Fix paths or remove dead references |
| Inconsistent terminology | Find-and-replace to standardize |
| Second-person writing style | Replace "you should" with imperative form |

### 2.3 Content Upgrades (based on knowledge layer)

**Layer 1 → Layer 2 upgrade** (add patterns):

1. Identify the 3-5 most common scenario types the skill handles
2. For each scenario type, document:
   - Structural pattern (what the output typically looks like)
   - Key parameters that distinguish this scenario
   - Common pitfalls specific to this scenario
3. Add scenario detection to the workflow: "Identify which scenario type applies before proceeding"

**Layer 2 → Layer 3 upgrade** (add cases):

1. Build a case asset library (consult `quality-ladder.md` for methodology):
   - Start with 3-5 benchmark cases (hand-crafted, extremely detailed)
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
```

This report serves as the human-auditable artifact for the boost process itself.
