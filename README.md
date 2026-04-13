[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

A skill for AI agents that creates and upgrades other skills. Works on Claude Code, Codex, Gemini CLI, and OpenClaw.

## What It Is

Mojo Skill Creator is itself an AI agent skill (a SKILL.md with 8 reference files). When installed, it gives your agent two capabilities:

- **`new`** — Walk through a 9-step process to create a skill from scratch
- **`boost`** — Diagnose an existing skill across 6 dimensions, then upgrade it

The output is a self-contained skill package (SKILL.md + references) that can be distributed to others and installed on any of the four supported platforms with a symlink.

## What Problem It Solves

Writing a SKILL.md is easy. Writing one that produces good output is not.

The typical failure: a skill passes every structural check — frontmatter, directory layout, trigger phrases — but its output is generic. Run it on two different tasks, and you get two sets of words over the same skeleton. The skill is technically correct and practically mediocre.

This happens because most skills are designed from the author's intuition or from abstract best practices, without studying how domain experts actually do the work. A writing skill that doesn't encode how professional writers work will produce AI-flavored writing. A design skill that skips how the best design teams operate will produce safe, average layouts.

Mojo addresses this with a specific structural choice: **before designing any red line or workflow step, the creator researches how the best practitioners in the target domain actually work** — their real workflows, quality standards, and non-negotiables. Expert workflows become the skill's workflow. Expert standards become the skill's red lines. This is the difference between a skill assembled from generic building blocks and one informed by domain expertise.

Beyond methodology, it also handles the engineering that makes skills practical:
- **Cross-platform** — no platform-specific tool names, works on all four agent platforms
- **Token-efficient** — 4-layer architecture so only the relevant workflow loads per invocation
- **Distribution-ready** — self-contained packages that end users install with a symlink, no setup needed

## How `new` Works

The 9 steps, in order:

1. **Understand use cases** — Collect 3-5 concrete examples of how the skill will be used, including failure cases
2. **Research domain best practices** — Study how the best humans do the task this skill automates. Find their actual workflows, quality standards, and principles. Do a cross-disciplinary scan. Then synthesize: rethink the workflow, principles, and quality bar before proceeding
3. **Design red lines and acceptance criteria** — Define 5-10 unbreakable constraints (sourced from expert standards in step 2) and 3-5 testable acceptance criteria, before writing any content
4. **Plan token architecture** — Design the 4-layer structure (metadata → router → workflow → reference) with word budgets per layer
5. **Plan reusable resources** — Identify what goes into scripts/, references/, and assets/
6. **Create the skill** — Write SKILL.md, workflow references, and deep references
7. **Human observability** (optional) — Add artifact output for auditable execution trails
7b. **Self-evolution integration** (optional) — Bundle skill-se-kit for runtime learning
8. **Cross-platform validation** — Verify no platform-specific tool names, all references exist, word budgets met
9. **Iterate** — Observe first use, tighten red lines, clarify workflows, compress token-heavy sections

Step 2 is the most important. The detailed research and synthesis process is in `references/domain-research-guide.md`.

## How `boost` Works

4 phases:

**Phase 1 — Diagnose** (8 checks):
1. Structural audit (frontmatter, red lines, acceptance criteria, stance)
2. Knowledge layer diagnosis (Layer 1 Principles → Layer 2 Patterns → Layer 3 Cases)
3. Context efficiency audit (word counts, always-loaded cost)
4. Human observability audit
5. Cross-platform compatibility check
6. Self-evolution audit
7. Domain best practice research (compare skill's workflow against expert workflow)
8. Research synthesis (decide: surface fixes or structural redesign?)

**Phase 2 — Prescribe**: Architecture fixes → Mechanical fixes → Content upgrades, in strict order. If the research synthesis found structural workflow gaps, prescription starts with workflow redesign.

**Phase 3 — Execute**: Repair in order, verify after each category.

**Phase 4 — Report**: Human-auditable boost summary with before/after metrics.

## Design Decisions

These are the choices embedded in the tool, and why:

**Domain research before design.** Step 2 of `new` and Phase 1.7 of `boost` require studying how the best practitioners actually do the task. Red lines come from expert quality standards, not abstract principles. The skill's workflow mirrors expert workflow, not a generic template. This is based on a real improvement where researching Apple, Linear, Stripe, and Airbnb design practices led to a skill's specificity test pass rate going from ~20% to ~85%.

**Constraints before workflows.** Influenced by [ljg-skills](https://github.com/lijigang/ljg-skills) — 14 skills that define what NOT to produce before defining what to produce. "No sentence with more than one subordinate clause" is checkable; "write clearly" is not.

**Stance over role.** Skills define a cognitive position ("not teaching, not presenting — show your wrong turns first") instead of an identity ("you are an expert"). This produces more precise behavior.

**Knowledge layer diagnosis.** From real-world skill improvement practice. A skill at Layer 1 (generic) needs different upgrades than one at Layer 2 (pattern-aware) or Layer 3 (case-specific). Diagnosis first, then targeted intervention.

**4-layer token architecture.** SKILL.md is a thin router (≤500 words). Workflows live in references (≤2000 words each). Deep material loads on-demand. Only one workflow loads per invocation. This skill's own SKILL.md is 499 words.

**Distribution-first.** Every skill produced is self-contained. No global installs, no assumed environment setup. End users symlink and use.

## Optional: Self-Evolution

Skills can bundle [skill-se-kit](https://github.com/d-wwei/skill-se-kit) (~48KB) for runtime learning. After each task, a sub-agent extracts feedback and updates a skill bank. The se-kit is bundled inside the skill package — end users don't install anything extra. Authors update the bundled copy via `boost`.

## Installation

```bash
git clone https://github.com/d-wwei/mojo-skill-creator.git
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Codex/Gemini: ln -sf ... ~/.agents/skills/mojo-skill-creator
```

Tell your agent "create a new skill" or "boost this skill."

## Supported Platforms

| Platform | Skill Path |
|----------|-----------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| OpenClaw | `~/.openclaw/skills/` |

Instructions in generated skills use semantic verbs (e.g., "read the file"), not platform-specific tool names.

## Project Structure

```
mojo-skill-creator/
├── SKILL.md                          # Router (499 words)
├── references/
│   ├── new-workflow.md               # 9-step creation process
│   ├── boost-workflow.md             # 4-phase diagnosis and upgrade
│   ├── domain-research-guide.md      # How to study expert workflows
│   ├── design-philosophy.md          # 6 design principles with examples
│   ├── platform-adaptation.md        # Tool name mapping for 4 platforms
│   ├── anti-patterns-by-domain.md    # Failure checklists: writing/visual/analysis/teaching
│   ├── quality-ladder.md             # Knowledge layer diagnosis method
│   └── se-kit-integration.md         # Optional self-evolution bundling guide
└── LICENSE-apache2.0
```

## Sources

- **[ljg-skills](https://github.com/lijigang/ljg-skills)** — Constraint-driven design, stance over role, domain anti-pattern libraries
- **Human-workflow methodology** — Knowledge layer diagnosis, case asset libraries, constraint tightening gradients. From a 66-brand design system improvement project
- **[Anthropic skill-creator](https://github.com/anthropics/claude-code)** (Apache 2.0) — Progressive disclosure, SKILL.md format conventions

## License

Apache 2.0. See [LICENSE-apache2.0](LICENSE-apache2.0).
