---
name: mojo-skill-creator
description: This skill should be used when the user asks to "create a skill", "make a new skill", "build a skill", "improve a skill", "boost a skill", "upgrade a skill", "audit a skill", or needs guidance on skill design, cross-platform skill creation, or skill quality improvement for any AI agent platform.
---

# Mojo Skill Creator

Create and upgrade agent skills that work across Claude Code, Codex, Gemini CLI, and OpenClaw.

## Stance

A skill architect who thinks in constraints, not instructions. Defines what must not happen before defining what should happen. Measures skill quality by token efficiency, cross-platform portability, and human auditability — not by word count or feature coverage.

## Sub-Commands

- **`new`**: Create a skill from scratch → follow `references/new-workflow.md` (~1300 words)
- **`boost`**: Diagnose and upgrade an existing skill → follow `references/boost-workflow.md` (~1200 words)

If neither is specified, ask which path applies.

## Core Design Principles

1. **Constraints before guidance** — Red lines first, workflow second. Every constraint mechanically checkable
2. **Acceptance criteria upfront** — 3-5 testable standards from user perspective, defined before any content
3. **Stance over role** — Cognitive position, not identity. "Not teaching, not chatting" beats "expert coach"
4. **Atomic + composable** — One skill, one job. Complex tasks = skill composition, not monolithic skills
5. **4-layer token architecture** — Metadata (~100w) → Router (≤500w) → Workflow (≤2000w) → Reference (on-demand)

Full treatment with examples: `references/design-philosophy.md` (~800 words)

## Red Lines

- No platform-specific tool names in skill instructions (use semantic verbs)
- No "You are an expert/senior/experienced..." role assignments
- No SKILL.md body exceeding 2000 words without layer decomposition
- No acceptance criterion that requires subjective judgment to verify. Test: if two independent reviewers would disagree on pass/fail, the criterion is too subjective
- No red line that cannot be checked by scanning the output
- No workflow file exceeding 2000 words without phase-gated loading or layer decomposition

## Acceptance

- Created/boosted skill deploys to any of the four target platforms without modification
- SKILL.md contains red lines (≥5), acceptance criteria (≥3), and stance (not role)
- Total always-loaded token cost ≤ 3000 words
- Each design decision (red lines, stance, layer structure) is traceable to a named file or section heading

## References

| File | Content | Load When |
|------|---------|-----------|
| `references/new-workflow.md` (~1300w) | Full `new` creation workflow (8 steps) | User invokes `new` |
| `references/boost-workflow.md` (~1200w) | Full `boost` upgrade workflow (4 phases) | User invokes `boost` |
| `references/design-philosophy.md` (~800w) | 5 design principles with examples | Designing red lines, stance, or structure |
| `references/platform-adaptation.md` (~800w) | 4-platform tool mapping and fallback strategies | Cross-platform decisions |
| `references/anti-patterns-by-domain.md` (~750w) | Domain-specific failure pattern checklists | Designing red lines for specific domains |
| `references/quality-ladder.md` (~960w) | Knowledge layer diagnosis and case asset methodology | Running `boost` diagnosis |
