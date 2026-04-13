[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

## Why This?

We spent months building and collecting AI agent skills — over 100 across Claude Code, Codex, and Gemini CLI. The pattern became obvious: most skills that pass structural validation still produce generic output. Two different tasks, same skeleton, different words.

We dug into why. The root cause wasn't bad prompting or wrong structure. It was that skill authors design from their own intuition or from abstract "best practices," without ever studying how domain experts actually do the work. A writing skill that doesn't encode how professional writers think will produce AI-flavored text. A design skill that skips how Apple, Linear, or Stripe's teams actually operate will produce safe, average layouts.

Then we found two bodies of work that attacked quality from opposite directions. [ljg-skills](https://github.com/lijigang/ljg-skills) — 14 Chinese-language skills that consistently produce output with character — showed that defining what a skill must NOT produce (mechanically checkable constraints) is more effective than telling it what to produce. Separately, a 66-brand design system improvement project showed that skills operate at measurable knowledge layers (generic → pattern-aware → case-specific), and each layer requires a different upgrade strategy.

The missing piece was obvious once we saw it: **before designing any constraint or workflow, go study how the best practitioners in the target domain actually work.** Their workflows become the skill's workflow. Their standards become the skill's red lines. Their mindset becomes the skill's stance.

Mojo Skill Creator packages all of this into a working tool. It's a skill that creates other skills — and upgrades existing ones — with these ideas built into every step.

## What It Is

Mojo Skill Creator is itself an AI agent skill (SKILL.md + 8 reference files, ~8,500 words total). Install it on any agent that supports the SKILL.md format, and it gains two capabilities:

- **`new`** — A 9-step guided process to create a skill from scratch, starting with domain expert research
- **`boost`** — A 4-phase diagnostic and upgrade process for existing skills

Every skill it produces is cross-platform (Claude Code, Codex, Gemini CLI, OpenClaw), self-contained for distribution, and token-efficient by design.

## Key Features

- **Domain research first.** Before writing any red line or workflow step, the creator guides you to study how the best practitioners actually do the task — their real workflows, quality standards, and principles. Then it asks you to rethink: does the skill need a different workflow structure? Do the principles still hold? What should the quality bar actually be? This single step is the difference between a skill assembled from generic parts and one informed by real expertise.

- **Constraint-driven quality.** Every skill ships with 5-10 mechanically checkable red lines — things the output must NOT contain. "No sentence with more than one subordinate clause" can be verified by scanning. "Write clearly" cannot. Red lines sourced from expert standards catch failure modes that abstract guidelines miss.

- **Knowledge layer diagnosis.** The `boost` command diagnoses where a skill sits: Layer 1 (correct but generic), Layer 2 (pattern-aware but no identity), or Layer 3 (distinctive, can detect its own errors). Each layer has a different upgrade path. No wasted effort applying Layer 3 techniques to a Layer 1 skill.

- **4-layer token architecture.** Skills don't dump everything into one file. Metadata (~100 words) → Router (≤500 words) → Workflow (≤2,000 words) → Reference (on-demand). Only one workflow loads per invocation. This skill's own SKILL.md is 499 words.

- **Cross-platform by default.** Instructions use semantic verbs ("read the file," "search the codebase"), not platform tool names. One skill package works on all four supported platforms without modification.

- **Distribution-ready.** Every skill produced is self-contained. No global installs, no environment assumptions. End users symlink and use. Optional components (like self-evolution via [skill-se-kit](https://github.com/d-wwei/skill-se-kit)) are bundled inside the package, not referenced externally.

## With and Without

| | Without Mojo | With Mojo |
|---|---|---|
| **Starting point** | Author's intuition + generic templates | Domain expert workflows + quality standards |
| **Red lines** | Vague ("write clearly") or absent | Mechanically checkable, sourced from expert practice |
| **Workflow design** | Invented from scratch | Mirrors how the best practitioners actually work |
| **Quality diagnosis** | "It feels generic" | Measured: Layer 1 / 2 / 3 with specific upgrade path |
| **Token cost** | Full skill in context every time | Only the relevant workflow loads per invocation |
| **Platform support** | Works on the author's platform | Works on Claude Code, Codex, Gemini CLI, OpenClaw |
| **Distribution** | "Install X globally, set up Y" | Symlink and use. Nothing else. |

## How It Works

### `new` — Create a skill (9 steps)

1. **Understand use cases** — Collect 3-5 concrete examples including failure cases
2. **Research domain best practices** — Find the best practitioners, study their actual workflows and quality standards, do a cross-disciplinary scan, then synthesize: rethink the workflow, principles, and quality bar before proceeding. Detailed guide in `references/domain-research-guide.md`
3. **Design red lines and acceptance criteria** — 5-10 constraints from expert standards, 3-5 testable criteria, define a stance (cognitive position, not role identity) — all before writing content
4. **Plan token architecture** — Design the 4-layer structure with word budgets per layer
5. **Plan reusable resources** — What goes into scripts/, references/, assets/
6. **Create the skill** — Write SKILL.md (router), workflow references, deep references. The workflow structure mirrors the expert workflow from step 2
7. **Human observability** (optional) — Artifact output for auditable execution trails
7b. **Self-evolution** (optional) — Bundle skill-se-kit (~48KB) for runtime learning
8. **Cross-platform validation** — No platform tool names, all references exist, budgets met
9. **Iterate** — Observe first use, tighten red lines, clarify workflows

### `boost` — Upgrade an existing skill (4 phases)

**Phase 1: Diagnose** — 8 checks: structural audit, knowledge layer diagnosis, context efficiency, human observability, cross-platform compatibility, self-evolution status, domain best practice research (compare skill's workflow vs expert workflow), and research synthesis (surface fixes or structural redesign?).

**Phase 2: Prescribe** — Architecture fixes → Mechanical fixes → Content upgrades, in strict order. If research synthesis found structural workflow gaps, prescription starts with workflow redesign, not content polish.

**Phase 3: Execute** — Repair in order, verify after each category.

**Phase 4: Report** — Human-auditable boost summary with before/after metrics.

### Design decisions

| Choice | Why |
|--------|-----|
| Domain research before design | Skills designed from expert workflows produce domain-appropriate output. Verified in practice: specificity test pass rate ~20% → ~85% after researching Apple/Linear/Stripe/Airbnb design practices. |
| Constraints before workflows | Influenced by ljg-skills. Checkable constraints ("no more than one clause per sentence") catch more failure modes than aspirational guidance ("write well"). |
| Stance over role | "Not teaching, not chatting — show your wrong turns first" produces more precise behavior than "you are an expert writing coach." |
| 4-layer token architecture | Most skills waste context loading material irrelevant to the current invocation. Layer separation keeps each invocation lean. |
| Distribution-first | End users have nothing pre-installed. Every optional component (se-kit, assets) bundled inside the package. |

## Installation

```bash
git clone https://github.com/d-wwei/mojo-skill-creator.git
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
```

Then tell your agent: "Create a new skill" or "Boost this skill."

### Supported platforms

| Platform | Skill Path |
|----------|-----------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| OpenClaw | `~/.openclaw/skills/` |

## License

Apache 2.0 — derived from [Anthropic's skill-creator](https://github.com/anthropics/claude-code). See [LICENSE-apache2.0](LICENSE-apache2.0).
