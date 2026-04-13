[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

Build agent skills that don't waste tokens, don't lock you into one platform, and don't fall apart when someone else tries to use them.

## Why This Exists

We had 100+ skills installed across Claude Code, Codex, and Gemini CLI. Most of them shared the same problem: they were written for the author's machine, not for anyone else's.

Some assumed you had a global Python package installed. Others used Claude Code-specific tool names that broke on Codex. A few dumped 4,000 words into the context window every time they loaded, whether you needed 10% of it or all of it.

The existing skill creators (Anthropic's built-in, the superpowers plugin) were good at validating structure. They'd tell you if your frontmatter was wrong. But they didn't help you *design* a good skill — one with actual quality controls, one that worked on four platforms, one that wouldn't eat half your agent's context for breakfast.

So we built this.

## What It Does

Two commands. One for creating, one for upgrading.

**`new`** walks you through 8 steps: understand the use cases, design red lines and acceptance criteria before writing anything, plan the token budget, build the skill, optionally add self-evolution and human auditability, validate across platforms, then iterate.

**`boost`** diagnoses an existing skill on four axes — structural quality, knowledge depth, token efficiency, cross-platform compatibility — then prescribes targeted fixes in strict order: architecture first, mechanical second, content last.

Both produce self-contained packages. The person who receives your skill installs it with a symlink and starts using it. No README to read, no setup to run.

## How It Works

The core insight: a skill's SKILL.md shouldn't contain everything. It should contain just enough to route to the right workflow.

```
Layer 0: Metadata       ~100 words    Always in context (name + description for trigger matching)
Layer 1: Router          ≤500 words    Loaded when skill activates — principles, red lines, pointers
Layer 2: Workflow       ≤2000 words    Only ONE sub-command's workflow loaded per invocation
Layer 3: Reference       On-demand     Deep material pulled only when the agent actually needs it
```

This skill is its own proof. The SKILL.md is 475 words. It routes to 7 reference files totaling ~7,500 words. But an agent running `new` only loads ~2,000 words at a time. An agent running `boost` loads a different ~2,000. The remaining 5,500 words never enter context unless specifically requested.

**The file structure:**

```
mojo-skill-creator/
├── SKILL.md                          # 475-word router
├── references/
│   ├── new-workflow.md               # 8-step creation (loaded for `new`)
│   ├── boost-workflow.md             # 4-phase diagnosis (loaded for `boost`)
│   ├── design-philosophy.md          # 6 principles — loaded when designing
│   ├── platform-adaptation.md        # Tool name mapping for 4 platforms
│   ├── anti-patterns-by-domain.md    # Failure checklists by domain
│   ├── quality-ladder.md             # Knowledge layer diagnosis method
│   └── se-kit-integration.md         # Optional self-evolution bundling
└── LICENSE-apache2.0
```

## What Makes It Different

**From Anthropic's skill-creator:** That tool validates structure (frontmatter, directories). This one teaches design — red lines before workflows, stance instead of role, token budgets before content. Structure validation is table stakes; design methodology is the gap.

**From "just write a good SKILL.md":** Every skill created through Mojo ships with mechanically checkable constraints. "No acceptance criterion requiring subjective judgment" isn't a suggestion — it's a red line with a concrete test: two independent reviewers must agree on pass/fail. If they'd disagree, the criterion is too vague.

**From single-platform tools:** Instructions use semantic verbs ("read the file", "search the codebase"), not platform tool names (`Read`, `read_file`, `grep_search`). One skill, four platforms, zero adaptation needed.

## The 6 Design Principles

| # | Principle | One-liner |
|---|-----------|-----------|
| 1 | **Distribution-first** | The end user's machine has nothing pre-installed. Design for that. |
| 2 | **Constraints before guidance** | Tell the agent what NOT to do. Constraints are checkable; aspirations aren't. |
| 3 | **Acceptance criteria upfront** | Define "done" before writing a single word. |
| 4 | **Stance over role** | "Thinks in constraints, not instructions" beats "You are an expert skill architect." |
| 5 | **Atomic + composable** | One skill, one job. Complex = composition. |
| 6 | **4-layer token architecture** | Load only what you need, when you need it. |

## Optional: Self-Evolution

Skills can bundle [skill-se-kit](https://github.com/d-wwei/skill-se-kit) (~48KB) for runtime learning. After each task, a sub-agent extracts feedback and updates a skill bank — the skill gets better with use.

The se-kit is bundled inside the skill package. End users don't install anything extra. When se-kit releases a new version, the skill author runs `boost`, updates the bundled copy, and redistributes. Users never manage dependencies.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/d-wwei/mojo-skill-creator.git

# 2. Symlink to your agent
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Or for Codex/Gemini: ln -sf ... ~/.agents/skills/mojo-skill-creator

# 3. Use it
# Tell your agent: "Create a new skill" or "Boost this skill"
# Mojo activates automatically from the trigger phrases in its description.
```

## Platforms

| Platform | Skill Path | Project Instructions |
|----------|-----------|---------------------|
| Claude Code | `~/.claude/skills/` | `CLAUDE.md` |
| Codex | `~/.agents/skills/` | `AGENTS.md` |
| Gemini CLI | `~/.gemini/skills/` | `GEMINI.md` |
| OpenClaw | `~/.openclaw/skills/` | — |

## Built On

Three methodologies, combined:

- **Anthropic's skill-creator** (Apache 2.0) — 6-step creation process, progressive disclosure, SKILL.md format conventions.
- **ljg-skills analysis** — Constraint-driven design, "stance over role", acceptance criteria upfront, domain anti-pattern libraries. From a [deep analysis](https://github.com/lijigang/ljg-skills) of 14 skills that prioritize quality floors over feature ceilings.
- **Human-workflow methodology** — Knowledge layer diagnosis (Principles → Patterns → Cases), case asset libraries, constraint tightening gradients, defect-layer repair ordering. Extracted from real-world skill improvement on a 66-brand design system.

## License

Apache 2.0 — derived from Anthropic's skill-creator. See [LICENSE-apache2.0](LICENSE-apache2.0).
