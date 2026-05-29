# Constraint Enforcement Guide

How to design constraints that agents actually follow. Covers the portable Think + Do model, enforcement strength, and cross-platform mechanisms.

Load this reference when designing red lines (`new` Step 3d) or auditing enforcement (`boost` Phase 1.9). Load a platform adapter only after a target platform is selected.

---

## The Problem: Think-Only Constraints Fail

A red line like "No step completed without its artifact" depends on the agent remembering and choosing to comply. Agents routinely skip cognitive-only constraints under pressure, complexity, or simple inattention.

**The fix**: pair every high-stakes constraint with a structural mechanism that makes non-compliance blocked, detectable, or externally enforced.

---

## Dual-Axis Model

Every constraint has two enforcement dimensions:

| Axis | What It Does | Strength | Weakness |
|------|-------------|----------|----------|
| **Think** | Explains what to do or avoid: red lines, stance, acceptance criteria | Provides reasoning context; works everywhere | Depends on compliance; skippable |
| **Do** | Makes violations blocked, detectable, or externally enforced | Works even when the agent forgets | Needs precise mechanics; may be platform-specific |

**Neither axis alone is sufficient.** Think without Do is skippable guidance. Do without Think is blind enforcement without understanding.

Glossary:
- Portable core: guidance that should work across all target platforms
- Adapter: platform-specific enforcement notes loaded only when needed
- Runtime: the agent environment doing the work now
- Think-axis: reasoning guidance the agent follows
- Do-axis: structural checks or gates that catch violations

---

## Enforcement Strength

Classify every Do mechanism by strength:

| Strength | Meaning | Examples |
|---|---|---|
| Advisory | Reminds the agent, but violation is easy | checklist text, comments |
| Detectable | Violation can be found after the fact | validation scripts, pattern scans, command output review |
| Blocking | Violation prevents workflow completion | artifact gate with required content, CI gate |
| External | Enforced outside the agent session | CI, pre-commit, repository policy |

Do not overclaim. A checklist is advisory unless another gate requires it. Script output is detectable unless wired into a blocking workflow or CI.

---

## Classification Decision

For each red line in a skill, ask:

1. **Is this constraint high-stakes?** Violation causes incorrect output, data loss, or cascading errors.
   - Yes -> assign Think + Do enforcement.
   - No -> Think-axis may be sufficient.

2. **Can this be checked mechanically?** File existence, word count, pattern match, command output, or test result.
   - Yes -> choose a portable Do mechanism below.
   - No -> strengthen Think-axis with specific anti-rationalization guidance.

3. **Is platform-specific enforcement needed?**
   - Yes -> load the relevant adapter from `references/adapters/`.
   - No -> keep the mechanism portable.

---

## Portable Do Mechanisms

### 1. Artifact Gates

**What**: Do not proceed to the next phase until a named file exists and contains required content.

**Use when**: Workflow steps produce research, plans, diagnoses, or validation reports.

**Template**:
```markdown
**Artifact**: Write to `{path}`. Gate: file must contain sections [{list}].
Do not proceed until the artifact exists and passes the gate.
```

**Strength levels**:
- Weak: file exists
- Medium: file exists + required section headings
- Strong: file exists + sections contain minimum content, such as >= N items

Default to medium. Use strong for research quality, red-line count, and final validation.

### 2. Verification Scripts

**What**: Self-contained scripts that produce pass/fail diagnostics.

**Use when**: Quality standards can be measured by word count, item count, reference existence, format, or structural completeness.

**Template**:
```bash
# verify-{check-name}.sh
# Returns 0 for pass, non-zero for fail, with diagnostic output.
```

Scripts are detectable by default. They become blocking only when the workflow or CI refuses completion on failure.

### 3. Required Evidence

**What**: A workflow requires command output, checklist status, or validation notes before completion.

**Use when**: A human needs an audit trail or the check cannot be fully automated.

Evidence is detectable, not automatically blocking, unless paired with an artifact gate.

### 4. Existing External Gates

**What**: Repository-level checks such as CI, pre-commit, or release gates.

**Use when**: The project already has an external mechanism. Do not add dependencies just to enforce a skill rule.

---

## Platform Adapters

Platform-specific mechanisms live outside the portable core:

- Claude Code: `references/adapters/claude-code.md`
- Codex: `references/adapters/codex.md`

Load an adapter only when the user names a target platform, when the current runtime must shape enforcement, or when auditing a platform-specific skill.

Portable skills must not depend on one platform's enforcement as their only Do mechanism. Pair adapter-specific mechanisms with artifact gates, verification scripts, or external checks unless the skill is explicitly single-platform.

---

## Applying to Skill Design

### In `new` Workflow

After designing red lines, classify each:

| Red Line | Stakes | Mechanically Checkable? | Strength | Mechanism |
|----------|--------|--------------------------|----------|-----------|
| (example) | High | Yes — file count | Blocking | Strong artifact gate |
| (example) | Medium | Yes — pattern scan | Detectable | Verification script |
| (example) | Low | No | Advisory | Specific Think-axis wording |

Write the classification to `build/constraint-enforcement-plan.md`. For each Do mechanism, specify the gate, script, evidence requirement, or adapter pointer.

### In `boost` Workflow

Audit existing red lines:

1. List all red lines from `SKILL.md`.
2. For each: Think-only or Think+Do? If Do, what strength and mechanism?
3. Identify mechanisms that belong in the portable core versus a platform adapter.
4. Calculate enforcement ratio: red lines with Do mechanisms / total red lines.
5. Identify top 3 highest-stakes Think-only constraints for upgrade.

Write audit to `diagnosis/constraint-enforcement-audit.md`.

Target enforcement ratio: >= 30% of red lines have Do-axis mechanisms. 100% is not the goal; low-stakes constraints can remain Think-only.
