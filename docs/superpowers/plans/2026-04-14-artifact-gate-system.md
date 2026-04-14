# Artifact Gate System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add step-level artifact gates to mojo-skill-creator's boost and new workflows so agents cannot skip steps or cut corners.

**Architecture:** Four markdown files get surgical edits — 2 new red lines in SKILL.md, artifact tables + gate conditions in both workflow files, and a Research Minimums section in the domain research guide. No new files created; no structural reorganization.

**Tech Stack:** Pure markdown edits. Verification via `wc -w` for token budgets.

---

## File Map

| File | Action | What Changes |
|------|--------|--------------|
| `SKILL.md` | Modify lines 39-40 | Add 2 anti-laziness red lines after existing 7 |
| `references/boost-workflow.md` | Modify lines 30-277 | Add artifact table + exit gate per phase |
| `references/new-workflow.md` | Modify lines 20-306 | Add artifact table + step gate per step |
| `references/domain-research-guide.md` | Modify lines 98-111 | Add Research Minimums section |

---

### Task 1: Add Anti-Laziness Red Lines to SKILL.md

**Files:**
- Modify: `SKILL.md:39` (after last existing red line)

- [ ] **Step 1: Add 2 new red lines**

Insert after line 39 (`- No assumption that end users have pre-installed tools or global packages — distributed skills work out of the box`):

```markdown
- No phase/step completed without its mandatory artifact written to the target skill's diagnosis/ (boost) or build/ (new) directory. Check: artifact file exists at declared path before proceeding to next phase/step
- No domain research step completed with fewer than 5 independent sources studied and documented. Check: research artifact contains ≥ 5 source entries each with name, key finding, and implication for the skill
```

- [ ] **Step 2: Verify word count is within budget**

Run: `wc -w SKILL.md`
Expected: ~550 words (was 499, adding ~50 words). Must be ≤ 2000.

- [ ] **Step 3: Verify red line count is now 9**

Run: `grep -c "^- No " SKILL.md`
Expected: 9 (was 7, added 2)

- [ ] **Step 4: Commit**

```bash
git add SKILL.md
git commit -m "feat: add anti-laziness red lines to SKILL.md

Add 2 new red lines enforcing mandatory artifacts per workflow step
and minimum 5 independent sources for domain research."
```

---

### Task 2: Add Artifact Gates to boost-workflow.md — Phase 1

**Files:**
- Modify: `references/boost-workflow.md:30-135` (Phase 1: Diagnosis section)

- [ ] **Step 1: Add Phase 1 Artifact Table after the Phase 1 heading**

Insert after line 30 (`## Phase 1: Diagnosis`), before `### 1.1 Structural Audit`:

```markdown

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

```

- [ ] **Step 2: Add "Write artifact" reminder to each mandatory sub-phase**

After the `**Output**:` line in each of sections 1.1, 1.2, 1.3, 1.5, 1.7, and 1.8, append:

For **1.1** (after line 46, after `**Output**: List of structural defects with type classification.`):

```markdown
**Artifact**: Write output to `diagnosis/structural-audit.md`.
```

For **1.2** (after line 63, after `**Output**: Current layer (1, 2, or 3) with evidence.`):

```markdown
**Artifact**: Write output to `diagnosis/layer-diagnosis.md`.
```

For **1.3** (after line 83, after `**Output**: Token metrics and compression opportunities.`):

```markdown
**Artifact**: Write output to `diagnosis/token-audit.md`.
```

For **1.5** (after line 101, after `**Output**: Platform compatibility issues list.`):

```markdown
**Artifact**: Write output to `diagnosis/platform-check.md`.
```

For **1.7** (after line 124, after `**Output**: Research summary with expert workflow mapping and gaps.`):

```markdown
**Artifact**: Write output to `diagnosis/domain-research.md`. Must contain ≥ 5 source entries per Research Minimums in `domain-research-guide.md`.
```

For **1.8** (after line 133, after `**Output**: Integrated diagnosis — determines whether Phase 2 prescribes surface fixes or fundamental redesign.`):

```markdown
**Artifact**: Write output to `diagnosis/synthesis.md`. Must reference findings from ALL prior diagnosis artifacts by filename.
```

- [ ] **Step 3: Add Phase 1 Exit Gate before Phase 2**

Insert before line 137 (`## Phase 2: Prescription`):

```markdown
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

```

- [ ] **Step 4: Read back Phase 1 section to verify all artifact references are consistent**

Run: `grep -n "diagnosis/" references/boost-workflow.md | head -30`
Expected: All 6 mandatory artifact paths appear in both the table and the individual step sections.

---

### Task 3: Add Artifact Gates to boost-workflow.md — Phase 2

**Files:**
- Modify: `references/boost-workflow.md` (Phase 2: Prescription section, around lines 139-167)

- [ ] **Step 1: Add Phase 2 Artifact Update instructions**

Insert after the Phase 2 introduction paragraph (after line 140, after `Defects are addressed in strict order: Architecture → Mechanical → Content.`):

```markdown

### Phase 2 Artifacts

Phase 2 does not create new files. It appends prescription sections to `diagnosis/synthesis.md`.

| Step | Section Added to synthesis.md | Gate Condition |
|------|-------------------------------|----------------|
| 2.1 | `## Architecture Prescription` | Lists each defect from structural-audit.md with planned fix |
| 2.2 | `## Mechanical Prescription` | Lists each issue from platform-check.md with planned fix |
| 2.3 | `## Content Prescription` | CANNOT be empty — see gate rule below |

**Phase 2.3 Anti-Skip Rule**: Section 2.3 Content Prescription CANNOT be a bare dismissal. If no content upgrades are prescribed, this section must contain ALL of: (a) the specific expert workflow from 1.7 that validates the current skill workflow, (b) an explicit claim that the current knowledge layer is appropriate with evidence from 1.2, (c) a token efficiency assessment from 1.3 confirming no compression opportunities. Omitting this evidence is a red line violation.

```

- [ ] **Step 2: Add artifact write reminder to each sub-section 2.1, 2.2, 2.3**

After the table in section **2.1 Architecture Fixes** (after line 155):

```markdown

**Artifact**: Append `## Architecture Prescription` to `diagnosis/synthesis.md`, listing each defect from `diagnosis/structural-audit.md` with its planned fix.
```

After the table in section **2.2 Mechanical Fixes** (after line 165):

```markdown

**Artifact**: Append `## Mechanical Prescription` to `diagnosis/synthesis.md`, listing each issue from `diagnosis/platform-check.md` with its planned fix.
```

After the existing content in section **2.3 Content Upgrades** (after the Self-evolution upgrade sub-section, around line 215):

```markdown

**Artifact**: Append `## Content Prescription` to `diagnosis/synthesis.md`. This section is subject to the Phase 2.3 Anti-Skip Rule above.
```

- [ ] **Step 3: Add Phase 2 Exit Gate before Phase 3**

Insert before `## Phase 3: Execution` (line 219):

```markdown
### Phase 2 Exit Gate

Before proceeding to Phase 3, verify `diagnosis/synthesis.md` contains ALL three prescription sections:

- [ ] `## Architecture Prescription` — lists defects with planned fixes
- [ ] `## Mechanical Prescription` — lists issues with planned fixes
- [ ] `## Content Prescription` — substantive content (not a bare dismissal). If "no upgrades needed," must include expert workflow validation + layer evidence + token assessment.

Do NOT proceed to Phase 3 until all sections are present and substantive.

---

```

- [ ] **Step 4: Read back to verify Phase 2 artifact references are consistent**

Run: `grep -n "Prescription" references/boost-workflow.md`
Expected: Each prescription section name appears in both the artifact table and the gate checklist.

---

### Task 4: Add Artifact Gates to boost-workflow.md — Phase 3 & 4

**Files:**
- Modify: `references/boost-workflow.md` (Phase 3 & 4 sections, lines 219-277)

- [ ] **Step 1: Add Phase 3 verification artifact instructions**

After the existing "Quality Verification After Each Fix Category" section content (after line 242, after the content upgrade verification bullet), add:

```markdown

**Artifact**: After each fix category, append a verification section to `diagnosis/synthesis.md`:
- After architecture fixes: `## Verification: Architecture` — paste re-run of §1.1 results
- After mechanical fixes: `## Verification: Mechanical` — paste re-run of §1.5 results
- After content upgrades: `## Verification: Content` — paste re-run of §1.2 + §1.3 results. If case assets added, paste specificity test results.

### Phase 3 Exit Gate

All applicable verification sections must exist in `diagnosis/synthesis.md` with actual command/check outputs. "Should pass" or "looks good" without pasted evidence is a red line violation.

```

- [ ] **Step 2: Add Artifact Manifest to Phase 4 Boost Report template**

In the Phase 4 Boost Report template (after the `### Verification` checklist section, around line 273), add a new section before the closing of the template:

```markdown

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

- [ ] **Step 3: Add Report Gate after the template**

After the boost report template closing, after line 276 (`This report serves as the human-auditable artifact for the boost process itself.`):

```markdown

**Report Gate**: The Artifact Manifest must list ALL mandatory artifacts with "Present" status. If any artifact is "Missing", the report is incomplete and the boost is not done. Do not declare completion until the manifest is fully populated.
```

- [ ] **Step 4: Verify full file word count**

Run: `wc -w references/boost-workflow.md`
Expected: ~2150 words (was 1849, adding ~300). Should remain close to 2000 threshold (acceptable per relaxed constraint).

- [ ] **Step 5: Commit boost-workflow changes**

```bash
git add references/boost-workflow.md
git commit -m "feat: add artifact gates to boost workflow

Add mandatory artifact tables, exit gates per phase, Phase 2.3
anti-skip rule, verification artifact requirements, and artifact
manifest in Boost Report. ~300 words added."
```

---

### Task 5: Add Artifact Gates to new-workflow.md

**Files:**
- Modify: `references/new-workflow.md:20-306` (Steps 1-9)

- [ ] **Step 1: Add Artifact Gate Table after Prerequisites section**

Insert after line 16 (after the `---` separator following Prerequisites), before `## Step 1`:

```markdown

## Step Artifacts (Mandatory)

Each step writes its output to the target skill's `build/` directory. All artifacts must exist before declaring the skill complete.

| Step | Artifact | Gate Condition |
|------|----------|----------------|
| 1 | `build/examples.md` | 3-5 concrete examples with input/output/failure cases |
| 2 | `build/domain-research.md` | ≥ 5 source entries (per Research Minimums) + research synthesis |
| 3 | `build/red-lines-and-criteria.md` | ≥ 5 red lines + ≥ 3 acceptance criteria + stance definition |
| 4 | `build/token-architecture.md` | Layer budget table + sub-command decisions + token declarations |
| 5 | `build/resource-plan.md` | Planned scripts/, references/, assets/ with justification |
| 6 | (skill files themselves) | SKILL.md + references/ exist per plan |
| 7/7b | (optional — no artifact) | — |
| 8 | `build/validation-checklist.md` | 8-item validation with pass/fail per item |
| 9 | (no artifact — iteration feeds back) | — |

**Step Gate Rule**: Do NOT proceed to Step N+1 until Step N's artifact exists and meets its gate condition.

---

```

- [ ] **Step 2: Add artifact reminders to each mandatory step**

After `### Conclude When` in **Step 1** (after line 36, after `There is a clear sense of: input types, output types, success criteria, and failure modes.`):

```markdown

**Artifact**: Write output to `build/examples.md`.
```

After `### Conclude When` in **Step 2** (after line 60, after `A research synthesis document exists with: domain leaders studied, revised workflow design, quality standards, red line candidates, and open questions.`):

```markdown

**Artifact**: Write output to `build/domain-research.md`. Must meet Research Minimums in `domain-research-guide.md`.
```

After the Stance template in **Step 3** (after line 96, after `Consult design-philosophy.md § Stance Over Role for examples.`):

```markdown

**Artifact**: Write red lines, acceptance criteria, and stance to `build/red-lines-and-criteria.md`.
```

After the Token Budget Declaration section in **Step 4** (after line 125):

```markdown

**Artifact**: Write layer budget and decisions to `build/token-architecture.md`.
```

After the Resource Audit section in **Step 5** (after line 143):

```markdown

**Artifact**: Write resource plan to `build/resource-plan.md`.
```

After Step 8's validation list (after line 293, after the last validation check item):

```markdown

**Artifact**: Write validation results to `build/validation-checklist.md`.
```

- [ ] **Step 3: Add Final Gate before Step 9**

Insert before `## Step 9: Iterate` (around line 295):

```markdown

### Completion Gate

Before declaring the new skill complete, verify ALL mandatory artifacts exist in `build/`:

- [ ] `build/examples.md` — 3-5 examples with input/output/failure
- [ ] `build/domain-research.md` — ≥ 5 sources + synthesis
- [ ] `build/red-lines-and-criteria.md` — ≥ 5 red lines + ≥ 3 criteria + stance
- [ ] `build/token-architecture.md` — layer budget + declarations
- [ ] `build/resource-plan.md` — resource list with justifications
- [ ] `build/validation-checklist.md` — 8-item checklist, all pass
- [ ] Skill's SKILL.md traces its red lines, stance, and workflow back to `build/domain-research.md`

Missing artifacts = skill is not complete. Do not proceed to iteration until this gate passes.

---

```

- [ ] **Step 4: Verify word count**

Run: `wc -w references/new-workflow.md`
Expected: ~2050 words (was 1799, adding ~250).

- [ ] **Step 5: Commit**

```bash
git add references/new-workflow.md
git commit -m "feat: add artifact gates to new workflow

Add mandatory artifact table, per-step artifact reminders,
step gate rule, and completion gate. ~250 words added."
```

---

### Task 6: Add Research Minimums to domain-research-guide.md

**Files:**
- Modify: `references/domain-research-guide.md:98-111` (end of file)

- [ ] **Step 1: Add Research Minimums section**

Insert before the `## For boost: Comparative Analysis` section (before line 101, before `## For \`boost\`: Comparative Analysis`):

```markdown
## Research Minimums

These thresholds are mechanically checkable (enforced by red line in SKILL.md).

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

---

```

- [ ] **Step 2: Verify word count**

Run: `wc -w references/domain-research-guide.md`
Expected: ~1080 words (was 931, adding ~150). Well within 2000 limit.

- [ ] **Step 3: Verify the Research Minimums section references are consistent with SKILL.md red line**

Run: `grep "5 independent sources" SKILL.md references/domain-research-guide.md`
Expected: Both files mention the "5 independent sources" threshold.

- [ ] **Step 4: Commit**

```bash
git add references/domain-research-guide.md
git commit -m "feat: add Research Minimums to domain research guide

Add quantitative floor for research quality: ≥5 independent sources,
structured source record format, workflow mapping table requirement,
and evidence requirement for 'no gap' claims. ~150 words added."
```

---

### Task 7: Cross-File Consistency Verification

**Files:**
- Read: All 4 modified files

- [ ] **Step 1: Verify artifact path consistency across files**

Run:
```bash
echo "=== SKILL.md red lines ===" && grep "diagnosis/\|build/" SKILL.md
echo "=== boost-workflow artifact paths ===" && grep "diagnosis/" references/boost-workflow.md | sort -u
echo "=== new-workflow artifact paths ===" && grep "build/" references/new-workflow.md | sort -u
```

Expected: Paths in SKILL.md red lines match the paths declared in the workflow artifact tables.

- [ ] **Step 2: Verify all word counts are within budget**

Run:
```bash
wc -w SKILL.md references/boost-workflow.md references/new-workflow.md references/domain-research-guide.md
```

Expected:
- SKILL.md: ~550 (limit: 2000)
- boost-workflow.md: ~2150 (limit: relaxed ~2200)
- new-workflow.md: ~2050 (limit: relaxed ~2200)
- domain-research-guide.md: ~1080 (limit: 2000)

- [ ] **Step 3: Verify "5 sources" threshold appears consistently**

Run:
```bash
grep -n "5.*source\|5.*independent\|≥ 5" SKILL.md references/boost-workflow.md references/new-workflow.md references/domain-research-guide.md
```

Expected: The threshold appears in SKILL.md (red line), boost-workflow.md (1.7 artifact table), new-workflow.md (Step 2 artifact table), and domain-research-guide.md (Research Minimums).

- [ ] **Step 4: Final commit with all verification passing**

If any inconsistencies found in Steps 1-3, fix them first. Then:

```bash
git add -A
git commit -m "chore: verify cross-file consistency for artifact gate system

All artifact paths, word counts, and research thresholds verified
consistent across SKILL.md, boost-workflow.md, new-workflow.md,
and domain-research-guide.md."
```
