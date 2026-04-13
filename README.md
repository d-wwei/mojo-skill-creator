[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

A methodology for building AI agent skills that are actually good — not just structurally correct.

## The Problem With Most Skills

Most AI agent skills pass validation. The frontmatter is right, the directory structure is clean, the description triggers correctly. But the output is generic. Run the same skill on two different tasks and the results have different words but the same skeleton — same rhythm, same depth, same lack of personality.

The gap isn't in structure. It's in design methodology.

Existing skill creators tell you *how to package a skill*. None of them tell you *how to design a skill that produces distinctive, reliable output*. That's the difference between a skill that validates and a skill that works.

## What Mojo Brings

Mojo combines two proven methodologies that attack quality from opposite directions:

### Locking the Floor: Constraint-Driven Design

From deep analysis of [ljg-skills](https://github.com/lijigang/ljg-skills) — 14 skills that consistently produce output with character, not just correctness.

The key insight: **telling an agent what NOT to do is more effective than telling it what to do.** "No sentence may contain more than one subordinate clause" is checkable — scan every sentence. "Write clearly" is not checkable — it means different things to different agents.

What this translates to in practice:

- **Red lines before workflows.** A skill defines 5-10 unbreakable constraints before it defines a single step. Each constraint has a mechanical check method. The quality floor is set before the first word of content.
- **Stance over role.** "You are a senior writing coach" produces imitation. "Not teaching, not presenting, not chatting. Show your wrong turns first, then the direction" produces a precise cognitive position. One order of magnitude more specific.
- **Acceptance criteria upfront.** Before writing anything, define 3-5 testable conditions for "done." Test: would two independent reviewers agree on pass/fail? If they'd argue, the criterion is too vague.
- **Domain anti-pattern libraries.** Writing skills get anti-patterns for writing (passive stacking, AI-slop phrases, translation tone). Visual skills get anti-patterns for visual (pure black, Inter font, equal-thirds layout). Each item is a binary check.

### Raising the Ceiling: Knowledge Layer Methodology

From real-world skill improvement practice — systematically upgrading a 66-brand design system from generic to distinctive.

The key insight: **skills operate at one of three knowledge layers, and the upgrade path between layers is different.**

| Layer | How Output Looks | Diagnostic |
|-------|-----------------|------------|
| **Principles** | Correct but generic. All projects look like the same template. | Give two very different tasks. If outputs differ only in surface content — same structure, rhythm, spacing — it's Layer 1. |
| **Patterns** | Recognizes scenarios and applies appropriate patterns. Stable but no identity. | Ask for output "in the style of X." If it gets the category right but misses the specific parameters — Layer 2. |
| **Cases** | Has clear identity. Can detect and correct errors against specific references. | Produce output in a reference style, then introduce a deliberate error. If the skill catches it — Layer 3. |

Moving from Layer 1 to 2 requires adding scenario-specific patterns. Moving from 2 to 3 requires building a case asset library — benchmark references with four dimensions each (parameters, operation guide, quality floor, intuition check). Every case entry must pass the specificity test: remove the name — can someone still identify which case it describes?

### Two Sides of the Same Problem

ljg's methodology locks the floor: output cannot be worse than the red lines allow.
The knowledge layer methodology raises the ceiling: output becomes increasingly specific and distinctive.

Together they address what neither does alone — skills that are both *reliable* (never below the floor) and *good* (clearly above generic).

## Two Commands

**`new`** — Build a skill from scratch. 8 steps: understand use cases → design red lines and acceptance criteria (before writing anything) → plan token budget → identify reusable resources → create the skill → optionally add self-evolution and human auditability → cross-platform validation → iterate.

**`boost`** — Diagnose and upgrade an existing skill. 4 phases: diagnosis (structural audit + knowledge layer + token efficiency + cross-platform check) → prescription (architecture → mechanical → content, in strict order) → execution → report.

## Also Handles the Engineering

The methodology is the core. But the engineering matters too — a well-designed skill that only works on one platform or eats the entire context window still fails in practice.

- **Cross-platform:** Skills work on Claude Code, Codex, Gemini CLI, and OpenClaw. Instructions use semantic verbs, not platform tool names.
- **Token-efficient:** 4-layer architecture — metadata → router (≤500w) → workflow (≤2000w) → reference (on-demand). This skill's own SKILL.md is 475 words.
- **Distribution-ready:** Self-contained packages. End users symlink and use. No global installs, no setup scripts, no README required.
- **Optionally self-evolving:** Skills can bundle [skill-se-kit](https://github.com/d-wwei/skill-se-kit) (~48KB) for runtime learning. A sub-agent handles feedback extraction — zero token impact on the main skill.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/d-wwei/mojo-skill-creator.git

# 2. Symlink to your agent
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Codex/Gemini: ln -sf ... ~/.agents/skills/mojo-skill-creator

# 3. Use it
# "Create a new skill" → activates `new`
# "Boost this skill" → activates `boost`
```

## Project Structure

```
mojo-skill-creator/
├── SKILL.md                          # 475-word router
├── references/
│   ├── new-workflow.md               # 8-step creation workflow
│   ├── boost-workflow.md             # 4-phase diagnosis + upgrade
│   ├── design-philosophy.md          # 6 design principles with examples
│   ├── platform-adaptation.md        # 4-platform tool mapping + fallbacks
│   ├── anti-patterns-by-domain.md    # Writing / visual / analysis / teaching
│   ├── quality-ladder.md             # Knowledge layer diagnosis method
│   └── se-kit-integration.md         # Optional self-evolution bundling
└── LICENSE-apache2.0
```

## Methodology Sources

- **[ljg-skills](https://github.com/lijigang/ljg-skills)** — 14 skills that prioritize quality floors over feature ceilings. Constraint-driven design, stance over role, domain anti-pattern libraries.
- **Human-workflow methodology** — Knowledge layer diagnosis, case asset libraries, constraint tightening gradients, defect-layer repair ordering. From a 66-brand design system improvement (199 files, 19,209 lines, ~45 minutes with parallel agents).
- **[Anthropic skill-creator](https://github.com/anthropics/claude-code)** (Apache 2.0) — 6-step creation process, progressive disclosure, SKILL.md format conventions.

## License

Apache 2.0 — derived from Anthropic's skill-creator. See [LICENSE-apache2.0](LICENSE-apache2.0).
