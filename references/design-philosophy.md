# Design Philosophy

Five principles for designing high-quality agent skills. Each principle is derived from proven practice (ljg-skills methodology) and applies regardless of target platform.

---

## 1. Constraints Before Guidance (红线优先)

### Principle

Define what the skill MUST NOT produce before defining what it should produce. Constraints are mechanically verifiable; positive guidance is ambiguous.

### Design Order

1. **Red lines** — 5-10 unbreakable constraints, each mechanically checkable
2. **Acceptance criteria** — 3-5 testable quality standards from user's perspective
3. **Workflow** — Step-by-step process with clear input/output per step
4. **Toolbox** — Optional enhancements the agent selects based on context

### Why This Order

Telling an agent "don't do X" is more effective than "do Y well" because:
- "Avoid passive voice stacking" is checkable → scan sentence by sentence
- "Write with good style" is not checkable → depends on undefined judgment

### Example

Bad constraint: "Maintain high quality output"
Good constraint: "No sentence may contain more than one subordinate clause. Violation check: count clause-opening conjunctions per sentence."

---

## 2. Acceptance Criteria Upfront (验收前置)

### Principle

Every skill MUST include a `## Acceptance` section with 3-5 testable criteria written from the user's perspective.

### What Makes a Good Criterion

- Testable by a specific action (not subjective judgment)
- Written from the user/reader perspective, not the creator perspective
- Failing the criterion is detectable without domain expertise

### Examples

Good:
- "A non-expert can retell the core idea in their own words after one read"
- "Removing any single paragraph breaks the logical chain"
- "No paragraph triggers a desire to skip while reading"

Bad:
- "Content quality is high" (not testable)
- "Comprehensive coverage" (unrelated to actual quality)
- "User is satisfied" (too subjective)

---

## 3. Stance Over Role (姿态替代角色)

### Principle

Do not write "You are an expert XXX." Define a cognitive position — where the agent stands relative to the problem — not an identity to imitate.

### Why

Identity ("senior investment analyst") produces imitation: "What would an analyst say?"
Stance ("You don't weigh — you read faces. Not 'how much is it worth' but 'does this machine spin'") produces cognitive calibration: a precise angle of attack.

Stance is one order of magnitude more precise than role.

### Examples

| Bad (Role) | Good (Stance) |
|-----------|--------------|
| "You are an experienced writing coach" | "A person thinking out loud, who happens to be overheard. Not teaching, not presenting, not chatting. Show your wrong turns first, then the direction." |
| "You are a senior investment analyst" | "You don't weigh — you read faces. Not 'how much is it worth' but 'does this machine spin'." |
| "You are a relationship counselor" | "Your job is not to give advice. It is to help the user see what they cannot see themselves." |

### How to Design a Stance

1. Ask: "What is the ONE cognitive position this skill takes on its domain?"
2. Express it as a relationship to the problem (not a job title)
3. Include what the stance explicitly excludes ("Not teaching, not chatting")

---

## 4. Domain Anti-Pattern Libraries (反模式驱动)

### Principle

For each domain the skill operates in, maintain a checklist of known failure patterns. Each item must be mechanically verifiable.

Anti-pattern libraries are more effective than best-practice lists because:
- Anti-patterns are finite and enumerable; "best practices" are infinite
- Checking "did I avoid X?" is binary; checking "did I achieve excellence?" is gradient
- Removing known failure modes reliably improves quality; adding aspirational goals may not

### Usage in Skills

Reference the domain-specific anti-pattern library from `anti-patterns-by-domain.md` in the skill's red-line section. The agent scans output against each item before delivery.

---

## 5. Atomic + Composable (原子化 + 可组合)

### Principle

Each skill does exactly one thing. Complex tasks are achieved by composing skills, not by building monolithic skills.

### Composition Patterns

**Pipeline**: Skill A's output feeds Skill B's input.
```
analyze-paper → generate-card    # Read paper → produce visual card
```

**Parallel**: Multiple independent instances run concurrently.
```
User gives 3 papers
 ├─ Agent 1: analyze(paper1) → card(result1)
 ├─ Agent 2: analyze(paper2) → card(result2)
 └─ Agent 3: analyze(paper3) → card(result3)
→ Summary report
```

**Unified Acquisition Layer**: All content-input skills share the same acquisition pattern:
- URL → fetch page content
- File path → read file
- Pasted text → use directly
- Name/concept → search web

Build the acquisition step into every content-input skill to reduce user cognitive load.

### Decomposition Test

If a skill description contains "and" connecting two distinct capabilities, it should be two skills:
- "Analyze papers AND generate visual cards" → two skills + one workflow
- "Analyze papers with deep reading AND citation tracing" → one skill (single coherent capability)
