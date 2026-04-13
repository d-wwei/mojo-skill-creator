# Quality Ladder

How to diagnose a skill's current quality level and systematically raise it.

The core methodology: **before improving a skill, study how the best humans do the task the skill automates.** Expert workflows become the skill's workflow. Expert standards become the skill's red lines. This is not abstract theory — it's the actual process that produced measurable quality improvements in practice (e.g., 66-brand design system: specificity test pass rate from ~20% to ~85%).

---

## Three Knowledge Layers

Every skill operates at one of three knowledge layers. Diagnosis determines where the skill is today; the upgrade path shows how to reach the next layer.

### Layer 1: Principles

**Human analogy**: Textbook knowledge. "Contrast should be sufficient." "Spacing should be consistent."

**Skill behavior**: Produces correct but generic output. All projects look like the same template. Changing the input topic changes the words but not the structure, rhythm, or character.

**Diagnostic test**: Give the skill two completely different tasks within its domain (e.g., "minimalist Japanese tea brand website" vs "cyberpunk game dashboard"). If the outputs differ mainly in color and copy — while structure, spacing, font choices, and shadow styles are nearly identical — the skill is at Layer 1.

### Layer 2: Patterns

**Human analogy**: Mid-career practitioner knowledge. "SaaS landing pages follow hero → features → pricing → CTA." "Financial products need tabular numerals."

**Skill behavior**: Recognizes scenario types and applies appropriate patterns. Stable quality, but outputs lack distinctiveness — you cannot tell them apart from any competent AI output.

**Diagnostic test**: Ask the skill to produce output "in the style of [specific reference]." If it captures the general category (e.g., "dark mode") but misses specific parameters (exact colors, specific font weights, characteristic spacing ratios), it is at Layer 2.

### Layer 3: Cases

**Human analogy**: Senior expert knowledge. "Linear uses Inter weight 510 as their signature weight — not 500, not 600." "Notion's text color is #37352f, not black, because their entire palette is warm-gray."

**Skill behavior**: Output has clear identity. The skill can detect errors: "This is wrong because the real [reference] would never do this."

**Diagnostic test**: Produce output in a specific reference style, then deliberately introduce an error. If the skill auto-detects and corrects it, it is at Layer 3.

---

## Domain Best Practice Research (The Foundation)

Every quality upgrade starts here. Before touching the skill's content, answer:

1. **What task does this skill automate?** Name the real-world discipline.
2. **Who does this best?** Find 3-5 recognized leaders (people, companies, teams).
3. **What is their workflow?** Not their marketing — their actual operational process. Look for:
   - Conference talks where practitioners describe their real process
   - Blog posts with "how we actually do X" specifics
   - Books by practitioners (not consultants)
   - Interviews where they share failures and lessons
4. **What are their quality standards?** What do they reject? What's non-negotiable?
5. **What would they think of this skill's output?** The gap between "what experts produce" and "what this skill produces" is the upgrade target.

### Example: Improving a Design Skill

Research found: Apple uses "Creative Selection" (500 prototypes for one package), Linear treats design as "search, not production", Stripe uses three-layer quality (Utility + Usability + Beauty), Airbnb does physical side-by-side audits.

This led to: adding an exploration phase before commitment, generating multiple directions for comparison (not one "best guess"), and a three-layer quality check at delivery. None of these came from abstract design principles — they came from studying what the best teams actually do.

---

## Case Asset Library

The key mechanism for reaching Layer 3. Organize reference knowledge in three tiers:

### Three-Tier Structure

| Tier | Count | Depth | Purpose |
|------|-------|-------|---------|
| **Benchmark** | 5-10 | Extreme, hand-crafted | Format reference, quality ruler |
| **Working** | 20-30 | Deep, researched | Style exploration, inspiration |
| **Baseline** | 50+ | Basic parameters correct | Breadth coverage, quick matching |

### Four Dimensions Per Case

Each case in the library should cover:

1. **Parameters** — Concrete values (colors, fonts, spacing, specific numbers)
2. **Operation guide** — "To produce output in this style, do X then Y"
3. **Quality floor** — "Output in this style MUST NOT have these properties"
4. **Intuition check** — Visual or concrete reference for "does this feel right?"

Missing any dimension creates blind spots:
- Parameters without quality floor → correct values in wrong contexts
- Quality floor without operation guide → knows what's wrong but not how to fix it
- Text descriptions without intuition check → "warm minimalism" means 100 things to 100 agents

### Specificity Test

Every case entry must pass this test:

> Remove the case name. Can someone still identify which case this describes?

If the entry could apply to any case in the domain, it is generic knowledge, not case knowledge. Rewrite until the entry is uniquely identifiable.

---

## Constraint Tightening Gradient

Match constraint strictness to workflow phase:

```
Early phases (exploration):   Loose constraints — creative discovery
Middle phases (systematize):  Turning point — introduce structure rules
Late phases (delivery):       Strict constraints — full checklist, no exceptions
```

**Why this matters**: Many skills apply the same constraint level throughout:
- All-strict → safe but boring, no creative exploration
- All-loose → creative but unreliable, inconsistent quality

Design skills with explicit phase markers and escalating constraint levels.

---

## Defect-Layer Repair Order

When upgrading a skill (boost workflow), fix defects in this exact order:

### 1. Architecture Defects (fix first)

Structural problems affecting the entire skill. Examples:
- Missing sections (no red lines, no acceptance criteria)
- Wrong layer structure (everything in SKILL.md, nothing in references)
- Token budget violation (SKILL.md > 3000 words)

**Method**: Manual, precise edits. Small count, high impact.

### 2. Mechanical Defects (fix second)

Same error pattern repeated across multiple locations. Examples:
- Platform-specific tool names throughout instructions
- Inconsistent terminology across sections
- Broken cross-references

**Method**: Script-based batch repair or find-and-replace. Must fix BEFORE content rewrite, or the batch fix overwrites handcrafted improvements.

### 3. Content Defects (fix last)

Each section needs independent research and rewriting. Examples:
- Generic instructions that could apply to any skill
- Missing domain-specific knowledge
- Layer 1 content that needs Layer 2/3 depth

**Method**: Section-by-section rewrite with quality verification after each batch. Most time-consuming — do only after architecture and mechanical defects are resolved.

---

## Context Efficiency Audit

When boosting a skill, measure its token footprint:

### Measurement

1. Count words in SKILL.md body (excluding frontmatter)
2. Identify which reference files get loaded on every invocation vs on-demand
3. Calculate total "always-loaded" token cost

### Thresholds

| Layer | Target | Action if exceeded |
|-------|--------|-------------------|
| SKILL.md body | ≤ 2000 words | Move content to references/ |
| Always-loaded total | ≤ 3000 words | Split into conditional loading |
| Single reference file | ≤ 5000 words | Split or add search patterns |

### Compression Techniques

- Move detailed content to references, keep only pointers in SKILL.md
- Replace lookup tables with executable scripts that return only the needed result
- Use conditional sections (load only for specific sub-commands or phases)
- Replace prose explanations with structured tables (same information, fewer tokens)
- Externalize examples to separate files, load only when agent needs them
