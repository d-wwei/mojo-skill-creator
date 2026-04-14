# Domain Best Practice Research Guide

How to study the real-world discipline your skill maps to, and synthesize findings into skill design inputs. This is the foundation of both the `new` and `boost` workflows.

---

## Why This Step Matters

A skill designed from abstract principles produces generic output. A skill designed from real expert workflows produces output with the depth and specificity that only domain experience can provide.

The research step is NOT optional even when the skill seems straightforward. "I already know this domain" is the most common reason skills end up at Layer 1 (generic). Expert workflows contain decisions and priorities that practitioners rarely articulate — they only surface when you study their actual process, not their advice.

---

## Research Process

### Step 1: Identify the Domain

From the skill's use cases, name the real-world discipline. Examples:
- A writing skill → professional writing / journalism / copywriting
- A design skill → product design / visual design / UX design
- An analysis skill → research methodology / financial analysis / competitive intelligence
- A code review skill → software engineering best practices

### Step 2: Find the Best Practitioners

Search for how the best people and teams in this domain actually work:

1. **Who are the recognized leaders?** (Individuals, companies, teams with proven track records)
2. **What are their published workflows?** (Blog posts, conference talks, books, interviews where they share their actual process — not marketing, but real operational detail)
3. **What frameworks does the industry use?** (Established methodologies, standards, certification bodies)
4. **What do they consider non-negotiable?** (Quality standards that top practitioners never compromise on)

### Step 3: Extract Workflow, Principles, and Standards

From the research, extract three things:

1. **Workflow**: What phases do experts go through? In what order? What are the decision points and checkpoints? Where do they explore vs. commit?
2. **Principles**: What do they believe about quality? What trade-offs do they make? What do they prioritize when resources are constrained?
3. **Standards**: What are their quality bars? What makes output "good enough" vs. "actually good"? What do they reject?

### Step 4: Cross-Disciplinary Scan

Ask: Does the structure of this task exist in another field? If so, what tools did that field build for it?

Examples from practice:
- Design skill → Apple's "Creative Selection" (natural selection analogy — generate many variants, let the best survive)
- Analysis skill → scientific method (hypothesis → experiment → evidence, not conclusion → justification)
- Writing skill → journalism (inverted pyramid, fact-checking protocols)
- Teaching skill → cognitive science (spaced repetition, desirable difficulty, testing effect)

Prioritize fields the skill's author would NOT think to check. Cross-disciplinary connections are most valuable when they're surprising.

---

## Synthesis: Rethink Before Proceeding

After gathering all research, stop and rethink from scratch. Do NOT mechanically slot findings into a template. Instead, ask three questions:

### 1. Workflow: How should this skill's process actually work?

Look at the expert workflows discovered. Does the skill need a fundamentally different structure — not just added steps, but a different logic?

Examples of structural rethinks:
- Experts have an exploration phase before commitment → the skill needs to generate options and let the user choose, not produce one "best guess"
- Experts iterate rapidly with real feedback → the skill needs shorter cycles with verification, not one long pass
- Experts do X before Y (opposite of your initial instinct) → reorder the workflow
- Cross-disciplinary insight reveals the task is actually [different type of problem] → redesign from the correct frame

### 2. Principles: What does quality actually mean in this domain?

Cross-disciplinary insights often reveal that the problem is different from what you assumed. Revisit:
- Is the skill solving the right problem, or a surface-level version of it?
- Do the expert principles contradict any of your initial assumptions?
- Did the cross-disciplinary scan reveal a deeper structure that changes how you think about this task?

### 3. Standards: What should the quality bar actually be?

Expert standards may be higher, lower, or differently shaped than initial expectations:
- Are there quality dimensions you didn't consider? (e.g., Stripe's three layers: Utility + Usability + Beauty — not just "correctness")
- Are there accepted trade-offs in the domain that the skill should encode? (e.g., "speed over polish in early phases, polish over speed in delivery")
- What would a domain expert reject that the skill currently allows?

---

## Output: Research Synthesis

Produce a single document capturing:

1. **Domain leaders studied** and what was learned from each
2. **Revised workflow design** — the skill's workflow structure, informed by expert practice
3. **Quality standards** — what constitutes good output, sourced from expert judgment
4. **Red line candidates** — what experts reject, ready for the red line design step
5. **Stance candidate** — the expert mindset, ready for the stance design step
6. **Open questions** — anything that needs user input before proceeding

This synthesis feeds directly into red line design, acceptance criteria, and skill workflow creation. The workflow designed here becomes the workflow encoded in the skill.

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

## For `boost`: Comparative Analysis

When boosting an existing skill, the synthesis includes a comparison:

1. Map the skill's current steps against expert workflow phases
2. Identify missing phases (e.g., experts have an "exploration" phase that the skill skips)
3. Identify mismatched emphasis (e.g., experts spend 40% of time on research, skill spends 5%)
4. Determine whether the gap requires workflow restructuring or content enhancement

If the gap is structural, the prescription starts with workflow redesign — not with polishing existing content.
