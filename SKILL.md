---
name: mojo-skill-creator
description: This skill should be used when the user asks to "create a skill", "make a new skill", "build a skill", "improve a skill", "boost a skill", "upgrade a skill", "audit a skill", or needs guidance on skill design, cross-platform skill creation, or skill quality improvement for any AI agent platform.
---

# Mojo Skill Creator

Create and upgrade agent skills for distribution across Claude Code, Codex, Gemini CLI, and OpenClaw. Every decision accounts for end users who receive the skill package, not just the author.

## Stance

Thinks in constraints, not instructions. Designs from the end user's perspective — the person who receives the distributed skill. Defines what must not happen before what should happen.

## Sub-Commands

- **`new`**: Create from scratch → `references/new-workflow.md` (~1500w)
- **`boost`**: Diagnose and upgrade → `references/boost-workflow.md` (~1400w)

If neither specified, ask which path.

## Core Design Principles

1. **Distribution-first** — Self-contained, zero-config for recipients
2. **Constraints before guidance** — Red lines first, every constraint mechanically checkable
3. **Acceptance criteria upfront** — 3-5 testable standards from user perspective
4. **Stance over role** — Cognitive position, not identity
5. **Atomic + composable** — One skill, one job. Complex tasks = composition
6. **4-layer token architecture** — Metadata (~100w) → Router (≤500w) → Workflow (≤2000w) → Reference (on-demand)

Full treatment: `references/design-philosophy.md` (~800w)

## Red Lines

- No platform-specific tool names in skill instructions (use semantic verbs)
- No "You are an expert/senior/experienced..." role assignments
- No SKILL.md body exceeding 2000 words without layer decomposition
- No acceptance criterion requiring subjective judgment. Test: two independent reviewers must agree on pass/fail
- No red line that cannot be checked by scanning output
- No workflow file exceeding 2000 words without phase-gated loading
- No assumption that end users have pre-installed tools or global packages — distributed skills work out of the box

## Acceptance

- Created/boosted skill deploys to any of the four target platforms without modification
- SKILL.md contains red lines (≥5), acceptance criteria (≥3), and stance (not role)
- Total always-loaded token cost ≤ 3000 words
- Each design decision (red lines, stance, layer structure) is traceable to a named file or section heading

## References

| File | Content | Load When |
|------|---------|-----------|
| `references/new-workflow.md` (~1500w) | `new` workflow (9 steps) | User invokes `new` |
| `references/boost-workflow.md` (~1400w) | `boost` workflow (4 phases) | User invokes `boost` |
| `references/design-philosophy.md` (~800w) | 6 design principles with examples | Designing red lines, stance, structure |
| `references/platform-adaptation.md` (~800w) | 4-platform tool mapping + fallbacks | Cross-platform decisions |
| `references/anti-patterns-by-domain.md` (~750w) | Domain failure pattern checklists | Designing domain red lines |
| `references/quality-ladder.md` (~960w) | Knowledge layer diagnosis + case methodology | `boost` diagnosis |
| `references/se-kit-integration.md` (~650w) | Optional self-evolution via skill-se-kit | `new` Step 6b / `boost` Phase 1.6 |
