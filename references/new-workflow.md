# `new` — Create a New Skill

Complete workflow for creating a new agent skill from scratch. Produces a cross-platform SKILL.md with supporting resources, following the constraints-first design philosophy.

---

## Prerequisites

Before starting, have ready:
- A clear idea of what the skill should do (even rough is fine — Step 1 will refine it)
- Knowledge of the target domain (or access to someone who has it)
- Decision on target platforms (default: all four — Claude Code, Codex, Gemini CLI, OpenClaw)

---

## Step 1: Understand the Skill with Concrete Examples

**Goal**: Build a clear picture of how the skill will be used in practice.

Do NOT skip this step. Even when the skill seems obvious, concrete examples surface hidden requirements.

### Actions

1. Collect 3-5 concrete examples of user requests that should trigger this skill
2. For each example, describe:
   - What the user says or provides as input
   - What the ideal output looks like
   - What would make the output bad (failure cases)
3. Identify the trigger phrases — exact words users would say that should activate this skill

### Conclude When

There is a clear sense of: input types, output types, success criteria, and failure modes.

---

## Step 2: Design Red Lines and Acceptance Criteria

**Goal**: Define the quality floor BEFORE defining the workflow.

This is the most important step. Red lines and acceptance criteria are the skill's immune system.

### 2a. Red Lines (5-10 items)

List what the skill MUST NOT produce. Each red line must be mechanically checkable.

**Template**:
```
- [ ] [Specific failure pattern]. Check: [how to detect it].
```

**Sources for red lines**:
- Domain anti-patterns (consult `anti-patterns-by-domain.md` for the relevant domain)
- Known failure modes from Step 1's failure cases
- Platform constraints (consult `platform-adaptation.md` if relevant)

### 2b. Acceptance Criteria (3-5 items)

List testable quality standards from the user's perspective.

**Quality test**: For each criterion, ask: "Can someone verify this without domain expertise?" If no, make it more concrete.

### 2c. Stance (not role)

Define the cognitive position, not an identity.

**Template**: "[What the skill does, expressed as a relationship to the problem]. [What it explicitly does NOT do]."

Consult `design-philosophy.md` § Stance Over Role for examples.

---

## Step 3: Plan the Skill's Token Architecture

**Goal**: Design the 4-layer structure before writing any content.

### Layer Budget Planning

| Layer | Content | Target |
|-------|---------|--------|
| 0: Metadata | name + description (frontmatter) | ≤ 100 words |
| 1: Router | SKILL.md body — core principles, routing, pointers | ≤ 500 words |
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

---

## Step 4: Plan Reusable Resources

**Goal**: Identify what scripts, references, and assets the skill needs.

For each concrete example from Step 1, ask:
1. What would need to be rewritten from scratch every time? → `scripts/`
2. What reference knowledge would the agent need? → `references/`
3. What files would be used in the output (templates, images)? → `assets/`

### Resource Audit

After listing resources, check:
- Does each resource justify its existence? (Will it be used in ≥ 2 scenarios?)
- Is any resource duplicating knowledge that already exists in the agent's base capabilities?
- Can any resource be a script (executed, not loaded) instead of a reference (loaded into context)?

---

## Step 5: Create the Skill

### 5a. Directory Structure

```
skill-name/
├── SKILL.md                    # Layer 1: Router
├── references/                 # Layer 2-3: Workflows and deep references
│   ├── primary-workflow.md
│   └── (additional references)
├── scripts/                    # Optional: executable tools
└── assets/                     # Optional: output templates
```

Create only the directories actually needed. An empty `scripts/` wastes attention.

### 5b. Write SKILL.md (Layer 1 Router)

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

**Body structure** (target ≤ 500 words):

```markdown
# Skill Name

[1-2 sentence purpose statement]

## Stance
[Cognitive position from Step 2c]

## Red Lines
[5-10 items from Step 2a — these are ALWAYS loaded, so they go in Layer 1]

## Acceptance
[3-5 criteria from Step 2b]

## Workflow
[Sub-command routing OR direct workflow reference]
- For `command-a`: follow `references/command-a-workflow.md` (~N words)
- For `command-b`: follow `references/command-b-workflow.md` (~N words)

## References
- `references/file.md` (~N words) — [when to load]
```

**Writing style**: Imperative/infinitive form. "Read the input" not "You should read the input."

### 5c. Write Workflow References (Layer 2)

Each workflow file is self-contained for its path. Target ≤ 2000 words.

Include:
- Step-by-step process with clear input/output per step
- Which red lines to check at which step
- Pointers to Layer 3 references when deeper knowledge is needed

### 5d. Write Deep References (Layer 3)

Only if needed. These are loaded on-demand by the agent, never automatically.

---

## Step 6: Human Observability (Optional)

**Decision point**: Does this skill's execution process need to be auditable by humans?

### When to Add

| Skill Output Type | Recommendation |
|-------------------|---------------|
| Analysis / decisions | Recommended — decision trail must be traceable |
| Creative / generative | Optional — process transparency aids iteration |
| Tool / transformation | Usually not needed — input→output is transparent |

### Artifact Template

If observability is needed, add to the workflow:

```markdown
## Artifact Output

After completing the workflow, write a summary document to `docs/{skill-name}/{date}-{topic}.md`:

- **Task Understanding**: What was the input and intent
- **Key Decisions**: What was chosen and why, what was rejected
- **Process Log**: Steps taken with evidence
- **Quality Verification**: Which red lines were checked, results
- **Deliverable**: Final output with usage notes
```

---

## Step 7: Cross-Platform Validation

Before declaring the skill complete, verify:

1. **No platform-specific tool names** in SKILL.md or workflow references
2. **All referenced files exist** at the declared paths
3. **Frontmatter** has `name` and `description` fields
4. **SKILL.md word count** ≤ target (500 for router, 2000 for single-file skills)
5. **Red lines are mechanically checkable** — each has a detection method
6. **Acceptance criteria are testable** — each can be verified by a specific action
7. **Stance is defined** — not a role/identity
8. **Symlink test**: Skill can be symlinked into any platform's discovery path and loaded

---

## Step 8: Iterate

After first use, observe:
- Did the agent trigger the skill on the right requests? (If not, refine description)
- Did the agent follow the workflow effectively? (If not, clarify instructions)
- Did the output pass the red lines? (If not, strengthen constraints)
- Was the token budget respected? (If not, move content to deeper layers)

Feed observations back into Steps 2-5. Each iteration should either tighten a red line, clarify a workflow step, or compress a token-heavy section.
