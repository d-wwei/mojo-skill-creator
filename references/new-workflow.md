# `new` — Create a New Skill

Complete workflow for creating a new agent skill from scratch. Produces a cross-platform SKILL.md with supporting resources, following the constraints-first design philosophy.

**Distribution principle**: Skills created through this workflow are designed for distribution to end users. Every decision must account for recipients who have no prior setup — the skill package must be self-contained and work out of the box.

---

## Prerequisites

- Rough idea of what the skill should do (Step 1 refines it)
- Domain knowledge or access to a domain expert
- Target platforms decided (default: all four)

---

## Step Artifacts (Mandatory)

Each step writes its output to the target skill's `build/` directory. All artifacts must exist before declaring the skill complete.

| Step | Artifact | Gate Condition |
|------|----------|----------------|
| 1 | `build/examples.md` | 3-5 concrete examples with input/output/failure cases |
| 2 | `build/domain-research.md` | ≥ 5 source entries (per Research Minimums) + research synthesis |
| 3 | `build/red-lines-and-criteria.md` | ≥ 5 red lines + ≥ 3 acceptance criteria + stance definition |
| 3d | `build/constraint-enforcement-plan.md` | Each red line classified Think/Do + mechanism designs for Do items |
| 4 | `build/token-architecture.md` | Layer budget table + sub-command decisions + token declarations |
| 5 | `build/resource-plan.md` | Planned scripts/, references/, assets/ with justification |
| 6 | (skill files themselves) | SKILL.md + references/ exist per plan |
| 7/7b | (optional — no artifact) | — |
| 8 | `build/validation-checklist.md` | 8-item validation with pass/fail per item |
| 9 | (no artifact — iteration feeds back) | — |
| 10 | `build/eval-scorecard.md` + `build/eval-history.md` | Optional — see `behavioral-eval-guide.md` |

**Step Gate Rule**: Do NOT proceed to Step N+1 until Step N's artifact exists and meets its gate condition.

---

## Step 1: Understand the Skill with Concrete Examples

**Goal**: Build a clear picture of skill usage. Even obvious skills need concrete examples — they surface hidden requirements.

**Dev Practice P12/P13**: Before collecting examples, search existing skills for overlapping coverage. Ground examples in observed user behavior, not assumed needs.

### Actions

1. Collect 3-5 concrete examples of user requests that should trigger this skill
2. For each example, describe:
   - What the user says or provides as input
   - What the ideal output looks like
   - What would make the output bad (failure cases)
3. Identify the trigger phrases — exact words users would say that should activate this skill

### Conclude When

There is a clear sense of: input types, output types, success criteria, and failure modes.

**Artifact**: Write output to `build/examples.md`.

---

## Step 2: Research Domain Best Practices

**Goal**: Study how experts do the task this skill automates — their workflows become the skill's foundation.

**Dev Practice P3**: Extend research scope beyond domain practices to architecture and tool-selection decisions. Every choice needs a research trail.

Follow the complete process in `domain-research-guide.md` (identify domain → find practitioners → extract workflows → cross-disciplinary scan → synthesize).

**The synthesis is the key output.** It feeds into Step 3 (red lines), Step 3c (stance), and Step 6c (workflow).

### Conclude When

A research synthesis document exists with: domain leaders studied, revised workflow design, quality standards, red line candidates, and open questions.

**Artifact**: Write output to `build/domain-research.md`. Must meet Research Minimums in `domain-research-guide.md`.

---

## Step 3: Design Red Lines and Acceptance Criteria

**Goal**: Define the quality floor BEFORE defining the workflow. Source red lines from the domain research in Step 2, not from abstract principles alone.

**Dev Practice P4+P5**: Record significant "decided not to do" decisions alongside design choices. Use ADR format for decisions affecting ≥2 files.

### 3a. Red Lines (5-10 items)

List what the skill MUST NOT produce. Each red line must be mechanically checkable.

**Template**:
```
- [ ] [Specific failure pattern]. Check: [how to detect it].
```

**Sources for red lines** (in priority order):
1. Expert quality standards from Step 2 (most valuable — comes from practitioners who've seen thousands of failure modes)
2. Domain anti-patterns (consult `anti-patterns-by-domain.md` for the relevant domain)
3. Known failure modes from Step 1's failure cases
4. Platform constraints (consult `platform-adaptation.md` if relevant)

### 3b. Acceptance Criteria (3-5 items)

List testable quality standards from the user's perspective, informed by Step 2's quality bars. **Test**: "Can someone verify this without domain expertise?" If no, make it more concrete.

### 3c. Stance (not role)

Cognitive position reflecting the expert mindset from Step 2. **Template**: "[Relationship to the problem]. [What it does NOT do]." See `design-philosophy.md` § Stance Over Role.

**Artifact**: Write red lines, acceptance criteria, and stance to `build/red-lines-and-criteria.md`.

### 3d. Constraint Enforcement Design

For each red line from 3a, classify its enforcement axis. Follow `constraint-enforcement-guide.md`.

1. High-stakes + mechanically checkable → assign a Do mechanism (artifact gate, hook, verification script, or sub-agent scope)
2. Low-stakes or not mechanically checkable → Think-axis sufficient
3. For each Do mechanism, write the specific template (hook rule, gate condition, or script)

**Artifact**: Write classification table and mechanism designs to `build/constraint-enforcement-plan.md`.

---

## Step 4: Plan the Skill's Token Architecture

**Goal**: Design the 4-layer structure before writing any content.

### Layer Budget Planning

| Layer | Content | Target |
|-------|---------|--------|
| 0: Metadata | name + description (frontmatter) | ≤ 100 words |
| 1: Router | SKILL.md body — core principles, routing, pointers | ≤ 1000 words |
| 2: Workflow | Primary workflow instructions (in references/) | ≤ 2000 words per file |
| 3: Reference | Deep reference material (in references/) | Loaded on-demand only |

### Decisions to Make

1. Does this skill need sub-commands? If yes, each sub-command gets its own Layer 2 file
2. What content is always needed vs. situationally needed? Always-needed → Layer 1-2. Situational → Layer 3
3. Are there lookup tables or decision trees? If large, externalize to scripts

### Token Budget Declaration

In SKILL.md, annotate each reference pointer with estimated token cost:
```markdown
- `references/workflow.md` (~1500 words) — primary workflow
- `references/advanced.md` (~2000 words) — loaded only for complex cases
```

**Artifact**: Write layer budget and decisions to `build/token-architecture.md`.

---

## Step 5: Plan Reusable Resources

**Goal**: Identify what scripts, references, and assets the skill needs.

**Dev Practice P1**: Audit each planned resource — justify every dependency. Prefer single-file solutions over packages.

For each concrete example from Step 1, ask:
1. What would need to be rewritten from scratch every time? → `scripts/`
2. What reference knowledge would the agent need? → `references/`
3. What files would be used in the output (templates, images)? → `assets/`

### Resource Audit

After listing resources, check:
- Does each resource justify its existence? (Will it be used in ≥ 2 scenarios?)
- Is any resource duplicating knowledge that already exists in the agent's base capabilities?
- Can any resource be a script (executed, not loaded) instead of a reference (loaded into context)?

**Artifact**: Write resource plan to `build/resource-plan.md`.

---

## Step 6: Create the Skill

**Dev Practice P6**: If upgrading an existing skill, check backward compatibility — published command formats and config structures must not break.

### 6a. Directory Structure

```
skill-name/
├── SKILL.md         # Router (Layer 1)
├── references/      # Workflows + deep refs (Layer 2-3)
├── scripts/         # Optional
└── assets/          # Optional
```

Create only directories actually needed.

### 6b. Write SKILL.md (Layer 1 Router)

**Frontmatter**:
```yaml
---
name: skill-name
description: This skill should be used when the user asks to "phrase 1", "phrase 2", "phrase 3". Provides [one-line capability summary].
---
```

- Description uses third person ("This skill should be used when...")
- Include 3-5 specific trigger phrases from Step 1
- One-line capability summary after trigger phrases

**Body structure** (target ≤ 1000 words): `# Name` → `## Stance` → `## Red Lines` (always loaded) → `## Acceptance` → `## Workflow` (sub-command routing + reference pointers with word counts) → `## References`.

**Writing style**: Imperative form. "Read the input" not "You should read the input."

### 6c. Write Workflow References (Layer 2)

Each workflow file is self-contained for its path. Target ≤ 2000 words.

The workflow structure should mirror the expert workflow discovered in Step 2. Do not invent a workflow from abstract principles — encode what the best practitioners actually do.

Include:
- Step-by-step process with clear input/output per step (mapped from expert workflow phases)
- Which red lines to check at which step
- Pointers to Layer 3 references when deeper knowledge is needed

### 6d. Write Deep References (Layer 3)

Only if needed. These are loaded on-demand by the agent, never automatically.

---

## Step 7: Human Observability (Optional)

**Decision point**: Does execution need to be human-auditable?

### When to Add

| Skill Output Type | Recommendation |
|-------------------|---------------|
| Analysis / decisions | Recommended — decision trail must be traceable |
| Creative / generative | Optional — process transparency aids iteration |
| Tool / transformation | Usually not needed — input→output is transparent |

### Artifact Template

If needed, add to the workflow: write summary to `docs/{skill-name}/{date}-{topic}.md` covering: task understanding, key decisions (chosen + rejected), process evidence, red line verification results, deliverable with usage notes.

---

## Step 7b: Self-Evolution Integration (Optional)

**Decision point**: Should this skill learn and improve from its own usage over time?

Consult `se-kit-integration.md` for the full integration guide.

### When to Add

| Skill Type | SE-Kit? | Rationale |
|-----------|---------|-----------|
| Analysis / decision | Recommended | Accumulates domain experience |
| Creative / generative | Recommended | Learns style preferences |
| Tool / transformation | Usually not | Behavior is fixed |

### What It Does

Bundles skill-se-kit (~48KB) in `se-kit/`. Sub-agent extracts feedback and updates skill bank per task. Pure enhancement — works without it; end users install nothing.

---

## Step 8: Cross-Platform Validation

**Dev Practice P7/P8**: Verify project linter passes clean (if CI configured). Check CHANGELOG exists in hybrid format (narrative + KaC).

Before declaring the skill complete, verify:

1. **No platform-specific tool names** in SKILL.md or workflow references
2. **All referenced files exist** at the declared paths
3. **Frontmatter** has `name` and `description` fields
4. **SKILL.md word count** ≤ target (1000 for router, 2000 for single-file skills)
5. **Red lines are mechanically checkable** — each has a detection method
6. **Acceptance criteria are testable** — each can be verified by a specific action
7. **Stance is defined** — not a role/identity
8. **Symlink test**: Skill can be symlinked into any platform's discovery path and loaded

**Structural verification** (run and paste output before proceeding):
- `scripts/verify-token-budget.sh <skill-dir>` — checks word count limits
- `scripts/verify-platform-names.sh <skill-dir>` — checks for platform-specific tool names
- `scripts/verify-artifact-content.sh <skill-dir>/build/domain-research.md domain-research` — checks source count
- `scripts/verify-artifact-content.sh <skill-dir>/build/red-lines-and-criteria.md red-lines` — checks red line count + sections

**Artifact**: Write validation results (including script output) to `build/validation-checklist.md`.

### Completion Gate

Before declaring the new skill complete, verify ALL mandatory artifacts exist in `build/`:

- [ ] `build/examples.md` — 3-5 examples with input/output/failure
- [ ] `build/domain-research.md` — ≥ 5 sources + synthesis
- [ ] `build/red-lines-and-criteria.md` — ≥ 5 red lines + ≥ 3 criteria + stance
- [ ] `build/constraint-enforcement-plan.md` — each red line classified Think/Do + Do mechanism designs
- [ ] `build/token-architecture.md` — layer budget + declarations
- [ ] `build/resource-plan.md` — resource list with justifications
- [ ] `build/validation-checklist.md` — 8-item checklist, all pass
- [ ] Skill's SKILL.md traces its red lines, stance, and workflow back to `build/domain-research.md`

Missing artifacts = skill is not complete. Do not proceed until this gate passes.

---

## Step 9: Iterate

After first use, observe:
- Agent triggers on right requests? Refine description if not
- Agent follows workflow? Clarify instructions if not
- Output passes red lines? Strengthen constraints if not
- Token budget respected? Move content to deeper layers if not

Feed observations back into Steps 2-5.

---

## Step 10: Behavioral Eval & Surgical Fix (Optional)

**Decision point**: Does output quality require testing beyond scripts? If yes, follow `behavioral-eval-guide.md` — design scenarios, subagent execution, scoring, surgical fix, re-score.
