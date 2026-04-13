# Mojo Skill Creator

Create and upgrade AI agent skills that work across platforms. One tool, any agent.

## What It Does

**`new`** — Build a skill from scratch with built-in quality controls: red lines, acceptance criteria, token budget planning, and cross-platform validation.

**`boost`** — Diagnose an existing skill's quality level (Principles → Patterns → Cases), then systematically upgrade it with targeted fixes.

Both paths produce self-contained skill packages ready for distribution. End users install and use them with zero configuration.

## Target Platforms

Skills created by Mojo work on any agent that supports the SKILL.md format:

| Platform | Discovery Path |
|----------|---------------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| OpenClaw | `~/.openclaw/skills/` |

No platform-specific tool names appear in generated skills — instructions use semantic verbs that any agent understands.

## Design Principles

1. **Distribution-first** — The skill package is self-contained. No global installs, no assumed setup.
2. **Constraints before guidance** — Red lines (what must NOT happen) before workflows (what should happen). Every constraint is mechanically checkable.
3. **Acceptance criteria upfront** — 3-5 testable standards defined before any content is written.
4. **Stance over role** — Skills define a cognitive position ("thinks in constraints, not instructions") rather than an identity ("you are an expert").
5. **Atomic + composable** — One skill, one job. Complex tasks = skill composition.
6. **4-layer token architecture** — Metadata (~100w) → Router (≤500w) → Workflow (≤2000w) → Reference (on-demand). Minimizes context window consumption.

## 4-Layer Token Architecture

Most skills dump everything into one file. Mojo enforces layered loading:

```
Layer 0: Metadata       ~100 words    Always in context (trigger matching)
Layer 1: Router          ≤500 words    Loaded when skill activates
Layer 2: Workflow       ≤2000 words    One sub-command loaded per invocation
Layer 3: Reference       On-demand     Deep material loaded only when needed
```

This skill practices what it preaches — its own SKILL.md is 475 words.

## Optional: Self-Evolution

Skills can optionally bundle [skill-se-kit](https://github.com/d-wwei/skill-se-kit) (~48KB) for runtime learning. After each task, a sub-agent extracts feedback and updates a skill bank. The skill gets better with use.

- Zero-config for end users — se-kit is bundled inside the skill package
- Sub-agent isolation — self-evolution runs in a separate context, no token impact on the main skill
- Upgrade path — skill authors update the bundled se-kit via `boost`, then redistribute

## Project Structure

```
mojo-skill-creator/
├── SKILL.md                              # Layer 1 router (475 words)
├── references/
│   ├── new-workflow.md                   # 8-step creation workflow
│   ├── boost-workflow.md                 # 4-phase diagnosis + upgrade
│   ├── design-philosophy.md              # 6 design principles
│   ├── platform-adaptation.md            # 4-platform tool mapping
│   ├── anti-patterns-by-domain.md        # Domain failure pattern checklists
│   ├── quality-ladder.md                 # Knowledge layer diagnosis
│   └── se-kit-integration.md             # Optional self-evolution guide
├── docs/
│   ├── brainstorms/                      # Requirements artifacts
│   ├── plans/                            # Implementation plans
│   ├── reviews/                          # Review reports
│   ├── solutions/                        # Knowledge extraction
│   └── roadmaps/                         # Iteration roadmaps
└── LICENSE-apache2.0
```

## Installation

Symlink into your agent's skill discovery path:

```bash
# Claude Code
ln -sf /path/to/mojo-skill-creator ~/.claude/skills/mojo-skill-creator

# Codex / Gemini CLI
ln -sf /path/to/mojo-skill-creator ~/.agents/skills/mojo-skill-creator

# Gemini CLI (alternative)
ln -sf /path/to/mojo-skill-creator ~/.gemini/skills/mojo-skill-creator
```

Then ask your agent: "Create a new skill" or "Boost this skill" — it will activate automatically.

## Methodology Sources

This tool synthesizes three proven approaches:

- **Structural foundation** — Derived from Anthropic's [skill-creator](https://github.com/anthropics/claude-code) (Apache 2.0). 6-step creation process, progressive disclosure, SKILL.md conventions.
- **Design philosophy** — Extracted from [ljg-skills](https://github.com/lijigang/ljg-skills) analysis. Constraint-driven design, stance over role, acceptance criteria upfront, domain anti-pattern libraries.
- **Quality methodology** — From real-world skill improvement practice. Knowledge layer diagnosis (Principles → Patterns → Cases), case asset libraries, constraint tightening gradients, defect-layer repair ordering.

## License

Apache 2.0 — derived from Anthropic's skill-creator. See [LICENSE-apache2.0](LICENSE-apache2.0).
