---
name: mojo-skill-creator
description: This skill should be used when the user asks to "create a skill", "make a new skill", "build a skill", "improve a skill", "boost a skill", "upgrade a skill", "audit a skill", or needs guidance on skill design, cross-platform skill creation, or skill quality improvement for any AI agent platform.
---

# Mojo Skill Creator

Create and upgrade agent skills for distribution across Claude Code, Codex, Gemini CLI, and OpenClaw. Every decision accounts for end users who receive the skill package, not just the author.

## Stance

Thinks constraints not instructions. Designs from end-user (recipient) perspective. Defines constraints before guidance.

## Sub-Commands

- **`new`**: Create from scratch → `references/new-workflow.md` (~1900w)
- **`boost`**: Diagnose and upgrade → `references/boost-workflow.md` (~1900w)

Ask if unspecified.

## Core Design Principles

1. **Distribution-first** — Self-contained, zero-config for recipients
2. **Constraints before guidance** — Red lines first, every constraint mechanically checkable
3. **Acceptance criteria upfront** — 3-5 testable standards from user perspective
4. **Stance over role** — Cognitive position, not identity
5. **Atomic + composable** — One skill, one job. Complex tasks = composition
6. **4-layer token architecture** — Metadata (~100w) → Router (≤1000w) → Workflow (≤2000w) → Reference (on-demand)
7. **Dual-axis constraints** — Think (cognitive) + Do (structural); high-stakes red lines need both axes

See: `references/design-philosophy.md` (~1100w)

## Red Lines

- No platform-specific tool names in skill instructions (use semantic verbs)
- No "You are an expert/senior/experienced..." role assignments
- No SKILL.md body exceeding 2000 words without layer decomposition
- No subjective acceptance criteria. Test: two reviewers must independently agree on pass/fail
- No red line uncheckable via output scan
- No workflow file exceeding 2000 words without phase-gated loading
- No assumption that end users have pre-installed tools or global packages — distributed skills work out of the box
- No phase/step completes without mandatory artifact in diagnosis/ (boost) or build/ (new). Check: artifact exists before next step
- No domain research completed with < 5 independent sources. Check: research artifact contains ≥ 5 entries with name, finding, and implication
- No high-stakes red line in a produced skill left cognitive-only when structural enforcement is feasible. Check: `build/constraint-enforcement-plan.md` classifies each red line's enforcement axis

## Acceptance

- Deploys to 4 target platforms without modification
- SKILL.md: ≥5 red lines, ≥3 acceptance criteria, stance (not role)
- Always-loaded tokens ≤ 3000 words
- Design decisions traceable to named files/headings
- Constraint enforcement plan classifies ≥30% of red lines with Do-axis mechanisms

## References

| File | Content | Load When |
|------|---------|-----------|
| `references/new-workflow.md` (~1900w) | `new` workflow (9 steps + 3d enforcement) | User invokes `new` |
| `references/boost-workflow.md` (~2000w) | `boost` workflow (4 phases incl. enforcement audit) | User invokes `boost` |
| `references/design-philosophy.md` (~1100w) | 7 design principles with examples | Designing red lines, stance, structure |
| `references/constraint-enforcement-guide.md` (~1100w) | Think/Do axis model + 4 enforcement mechanisms | `new` Step 3d / `boost` Phase 1.9 |
| `references/platform-adaptation.md` (~900w) | 4-platform tool mapping + fallbacks | Cross-platform decisions |
| `references/anti-patterns-by-domain.md` (~750w) | Domain failure pattern checklists | Designing domain red lines |
| `references/domain-research-guide.md` (~1100w) | How to study expert workflows + synthesize findings | `new` Step 2 / `boost` Phase 1.7-1.8 |
| `references/quality-ladder.md` (~1200w) | Knowledge layer diagnosis + case methodology | `boost` diagnosis |
| `references/se-kit-integration.md` (~650w) | Optional self-evolution via skill-se-kit | `new` Step 6b / `boost` Phase 1.6 |
