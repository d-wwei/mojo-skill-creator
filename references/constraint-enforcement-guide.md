# Constraint Enforcement Guide

How to design constraints that agents actually follow. Covers the Think + Do dual-axis model and four structural enforcement mechanisms.

Load this reference when designing red lines (new Step 3b) or auditing enforcement (boost Phase 1.9).

---

## The Problem: Think-Only Constraints Fail

A red line like "No step completed without its artifact" depends on the agent remembering and choosing to comply. Agents routinely skip cognitive-only constraints under pressure, complexity, or simple inattention.

**The fix**: pair every high-stakes constraint with a structural mechanism that enforces compliance without relying on agent memory.

---

## Dual-Axis Model

Every constraint has two enforcement dimensions:

| Axis | What It Does | Strength | Weakness |
|------|-------------|----------|----------|
| **Think** | Tells agent what to do/avoid (red lines, instructions, reminders) | Provides reasoning context; works on all platforms | Depends on compliance; skippable |
| **Do** | Makes non-compliance impossible or detectable (hooks, gates, scripts) | Structural; works even if agent "forgets" | No reasoning context alone; platform-dependent |

**Neither axis alone is sufficient.** Think without Do = skippable guidance. Do without Think = blind enforcement without understanding.

### Classification Decision

For each red line in a skill, ask:

1. **Is this constraint high-stakes?** (Violation causes incorrect output, data loss, or cascading errors)
   - Yes → MUST have Do-axis enforcement
   - No → Think-axis sufficient

2. **Can this be checked mechanically?** (File existence, word count, pattern match, command output)
   - Yes → Choose a Do mechanism below
   - No → Strengthen Think-axis (make instruction more specific, add anti-rationalization table)

3. **Must it work cross-platform?** 
   - Yes → Use artifact gates or verification scripts (portable)
   - No → Hooks are acceptable (platform-specific)

---

## Four Enforcement Mechanisms

### 1. Artifact Gates

**What**: Block progression to step N+1 until step N's output file exists AND contains required content.

**When to use**: Workflow steps that produce documents, research, analysis, or plans.

**Template** (in workflow file):
```markdown
**Artifact**: Write to `{path}`. Gate: file must contain sections [{list}].
Do NOT proceed to Step N+1 until verified.
```

**Strength levels**:
- **Weak**: File exists at path (agent can create empty file to pass)
- **Medium**: File exists + contains required section headings
- **Strong**: File exists + sections contain minimum content (e.g., ≥ N items in a list)

**Design rule**: Default to medium. Use strong for high-stakes gates (research quality, red line count).

**Portability**: Works on all platforms. No hooks needed — instruction-based with checkable criteria.

### 2. Hook Templates

**What**: Platform hooks that intercept tool calls and block/warn based on conditions.

**When to use**: Preventing dangerous actions (editing without research, deleting files, skipping phases).

**Template** (PreToolUse hook):
```
IF agent calls [Edit/Write] on [target pattern]
AND [precondition not met]
THEN block with message: "[what to do first]"
```

**Example**: Block editing a skill's SKILL.md before `build/domain-research.md` exists:
```
Trigger: Edit/Write on */SKILL.md
Condition: build/domain-research.md does not exist
Action: deny — "Complete domain research first (Step 2)"
```

**Portability**: Claude Code hooks, Codex callbacks, Gemini CLI hooks. Not universal — always pair with Think-axis fallback instruction.

**Bundling**: Hook templates go in the skill's `hooks/` directory. End users install per their platform's mechanism.

### 3. Verification Scripts

**What**: Scripts that check output quality after a step completes, producing pass/fail results.

**When to use**: Quality standards that can be measured (word count, item count, pattern presence, structural completeness).

**Template** (shell script):
```bash
# verify-{check-name}.sh
# Returns 0 (pass) or 1 (fail) with diagnostic message
```

**Common checks**:
- Red line count: `grep -c "^- " SKILL.md | awk '{if ($1 >= 5) exit 0; else exit 1}'`
- Token budget: `wc -w < SKILL.md` compared to threshold
- Required sections: grep for section headings
- Cross-reference integrity: verify all referenced files exist

**Portability**: Shell scripts work everywhere. The workflow instructs: "Run `scripts/verify-X.sh` and paste output before proceeding."

**Bundling**: Scripts go in the skill's `scripts/` directory. Self-contained, no external dependencies.

### 4. Sub-Agent Scoping

**What**: When a skill dispatches sub-agents, restrict their tool access to prevent unintended actions.

**When to use**: Skills with review steps, research steps, or any delegated work.

**Template** (in workflow):
```markdown
Dispatch review sub-agent with:
- Allowed tools: Read, Grep, Glob, LSP
- Disallowed: Edit, Write, Bash, Agent
- Purpose: review only, no modifications
```

**Scope patterns**:

| Role | Allowed | Disallowed | Rationale |
|------|---------|-----------|-----------|
| Reviewer | Read, Grep, Glob | Edit, Write, Bash | Can only read, not modify |
| Researcher | Read, Grep, WebSearch, WebFetch | Edit, Write | Can search, not change code |
| Implementer | Read, Grep, Edit, Write, Bash | Agent | Can code, not spawn more agents |

**Portability**: Works on Claude Code (Agent tool prompt), Codex (tool restrictions), Gemini CLI (tool config). Specify restrictions in natural language — the dispatching agent enforces.

---

## Applying to Skill Design

### In `new` Workflow (Step 3b)

After designing red lines in Step 3, classify each:

| Red Line | Stakes | Mechanically Checkable? | Enforcement Axis | Mechanism |
|----------|--------|------------------------|-------------------|-----------|
| (example) | High | Yes — file count | Think + Do | Artifact gate (strong) |
| (example) | Medium | No — subjective | Think only | Anti-rationalization table |

Write the classification to `build/constraint-enforcement-plan.md`.

For each Do-axis constraint, write the specific mechanism (hook template, script, gate condition) into the plan. These get implemented in Step 6 alongside the skill.

### In `boost` Workflow (Phase 1.9)

Audit existing red lines:

1. List all red lines from SKILL.md
2. For each: is there a Do-axis mechanism currently? (hook, gate, script, sub-agent scope)
3. Calculate enforcement ratio: `(red lines with Do) / (total red lines)`
4. Identify top 3 highest-stakes Think-only constraints → prescribe Do mechanisms

Write audit to `diagnosis/constraint-enforcement-audit.md`.

Target enforcement ratio: ≥ 30% of red lines have Do-axis mechanisms. 100% is not the goal — low-stakes constraints work fine as Think-only.

---

## Platform Compatibility Matrix

| Mechanism | Claude Code | Codex | Gemini CLI | OpenClaw |
|-----------|------------|-------|-----------|---------|
| Artifact gates | Yes (instruction) | Yes (instruction) | Yes (instruction) | Yes (instruction) |
| Hook templates | Yes (settings.json) | Partial (callbacks) | Yes (hooks config) | No |
| Verification scripts | Yes (Bash tool) | Yes (shell) | Yes (shell) | Yes (shell) |
| Sub-agent scoping | Yes (Agent tool) | Yes (tool restrictions) | Yes (tool config) | Partial |

**Rule**: Every Do-axis constraint must have at least one mechanism that works on ALL four platforms. Hooks alone are insufficient — always pair with an artifact gate or verification script.
