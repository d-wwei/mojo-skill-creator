[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

A methodology for building AI agent skills that are actually good — not just structurally correct.

## The Problem

Most AI agent skills validate fine. Clean frontmatter, proper directories, correct triggers. But the output is flat. Two different tasks produce two sets of words stretched over the same skeleton — same depth, same rhythm, same lack of character.

The gap isn't technical. It's methodological. Existing skill creators teach you how to package a skill. None of them teach you how to design one that produces output a domain expert would recognize as competent.

## The Core Idea

Before writing a single red line or workflow step, **go study how the best humans do the task your skill automates.**

This is not a metaphor. It's the literal first step:

1. Name the real-world discipline your skill maps to
2. Find the recognized leaders — people, companies, teams with proven track records
3. Study their actual workflows — conference talks, published processes, interviews where they share operational detail (not marketing)
4. Extract their quality standards — what do they reject? What's non-negotiable?
5. Scan across disciplines — does the same problem structure exist elsewhere?

Expert workflows become the skill's workflow. Expert standards become the skill's red lines. Expert mindset becomes the skill's stance.

### How This Played Out in Practice

When improving a frontend design skill, this research step uncovered: Apple's "Creative Selection" (500 prototypes for one package design), Linear's "design is search, not a production pipeline", Stripe's three-layer quality standard (Utility + Usability + Beauty), and Airbnb's physical side-by-side audits.

None of these insights came from design principles or AI prompt engineering. They came from studying what the best teams actually do. The result: a 6-phase workflow with an exploration stage before commitment, multiple directions for comparison instead of one "best guess", and a constraint tightening gradient — loose during exploration, strict at delivery.

That skill's specificity test pass rate went from ~20% to ~85%. The methodology works because it imports real expertise, not abstract rules.

## Two Mechanisms Built on Research

Domain research provides the raw material. Two mechanisms turn it into skill quality:

### Locking the Floor: Constraint-Driven Design

From [ljg-skills](https://github.com/lijigang/ljg-skills) — 14 skills that consistently produce output with character.

**Tell the agent what NOT to do.** "No sentence may contain more than one subordinate clause" is checkable. "Write clearly" is not. Red lines sourced from expert quality standards (discovered during research) are more effective than red lines invented from abstract principles.

In practice:
- **Red lines before workflows.** 5-10 unbreakable constraints, each with a mechanical check method, defined before writing any content.
- **Stance over role.** A cognitive position ("not teaching, not presenting — show your wrong turns first, then the direction") instead of an identity ("you are an expert").
- **Acceptance criteria upfront.** 3-5 testable conditions for "done", informed by the quality bars experts actually use.

### Raising the Ceiling: Knowledge Layer Diagnosis

From real-world skill improvement practice on a 66-brand design system.

Skills operate at one of three layers:

| Layer | Output Looks Like | Upgrade Path |
|-------|------------------|-------------|
| **Principles** | Correct but generic — all projects share the same template | Add scenario-specific patterns |
| **Patterns** | Recognizes scenarios, stable quality, but no identity | Build case asset library from domain leaders |
| **Cases** | Clear identity, can detect and correct errors | Maintain and deepen benchmark references |

The upgrade path at each layer is different. Applying Layer 3 techniques to a Layer 1 skill wastes effort. Diagnosis first, then targeted intervention.

## Two Commands

**`new`** — 9 steps. The critical addition: Step 2 is Domain Best Practice Research, which feeds everything downstream.

```
1. Understand use cases → 2. Research domain best practices ★ →
3. Design red lines + acceptance criteria (from research) →
4. Plan token architecture → 5. Plan resources → 6. Create the skill →
7. Human observability (optional) → 8. Cross-platform validation → 9. Iterate
```

**`boost`** — 4 phases. Phase 1.7 is Domain Best Practice Research, comparing the skill's current workflow against expert workflow.

```
Phase 1: Diagnose (structure + knowledge layer + efficiency + domain research ★)
Phase 2: Prescribe (architecture → mechanical → content, strict order)
Phase 3: Execute (repair in order, verify after each category)
Phase 4: Report (human-auditable boost summary)
```

## Engineering

The methodology is the core. The engineering keeps it practical:

- **Cross-platform.** Claude Code, Codex, Gemini CLI, OpenClaw. Semantic verbs, no platform tool names.
- **Token-efficient.** 4-layer architecture — this skill's own SKILL.md is 478 words. Only one workflow loads per invocation.
- **Distribution-ready.** Self-contained packages. End users symlink and use. No global installs.
- **Optionally self-evolving.** Bundle [skill-se-kit](https://github.com/d-wwei/skill-se-kit) (~48KB) for runtime learning via sub-agent.

## Quick Start

```bash
git clone https://github.com/d-wwei/mojo-skill-creator.git
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Or: ~/.agents/skills/ for Codex/Gemini
```

Then: "Create a new skill" or "Boost this skill."

## Project Structure

```
mojo-skill-creator/
├── SKILL.md                          # 478-word router
├── references/
│   ├── new-workflow.md               # 9-step creation (Step 2 = domain research)
│   ├── boost-workflow.md             # 4-phase diagnosis (Phase 1.7 = domain research)
│   ├── design-philosophy.md          # 6 design principles
│   ├── platform-adaptation.md        # 4-platform tool mapping + fallbacks
│   ├── anti-patterns-by-domain.md    # Writing / visual / analysis / teaching
│   ├── quality-ladder.md             # Knowledge layer diagnosis + research method
│   └── se-kit-integration.md         # Optional self-evolution bundling
└── LICENSE-apache2.0
```

## Sources

- **[ljg-skills](https://github.com/lijigang/ljg-skills)** — Constraint-driven design, stance over role, domain anti-pattern libraries.
- **Human-workflow methodology** — Knowledge layer diagnosis, case asset libraries, constraint tightening. From a 66-brand design system improvement (199 files, ~45 min with parallel agents).
- **[Anthropic skill-creator](https://github.com/anthropics/claude-code)** (Apache 2.0) — Progressive disclosure, SKILL.md conventions.

## License

Apache 2.0. See [LICENSE-apache2.0](LICENSE-apache2.0).
