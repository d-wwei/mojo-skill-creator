# Spec: Codex-Compatible Portable Enforcement Adapters

Date: 2026-05-28
Status: Draft v2

## Objective

Refactor Mojo Skill Creator's constraint enforcement guidance so it works cleanly in Codex while preserving first-class Claude Code support.

The skill remains a portable skill creator, not a Codex-only or Claude-only fork.

## Problem

The current constraint system was originally shaped around Claude Code concepts: hooks, `PreToolUse`, named tools such as `Read`, `Edit`, `Write`, `Bash`, and `Agent`, and tool-call interception as a strong enforcement mechanism.

Codex can use the skill format and benefits from the same core methodology, but its reliable enforcement surfaces are different:

- artifact gates
- validation scripts
- explicit verification checklists
- patch-based edits
- command output checks
- project instructions and local skill instructions

Codex should not be asked to rely on Claude Code hook semantics for correctness.

## Architecture Decision

Use a three-layer portability model:

```text
portable core
  -> platform adaptation guide
      -> platform enforcement adapters
```

The portable core defines the skill-creation method and cross-platform constraints. Platform adapters define how each runtime enforces those constraints.

Do not turn Claude Code hooks into Codex guidance. Do not remove Claude Code hooks from the system. Move them to the Claude Code adapter.

## Scope

In scope:

- Keep the core Think + Do constraint model.
- Make platform-neutral workflow text the default.
- Move platform-specific enforcement details into explicit adapters.
- Add a Codex adapter for reliable Codex enforcement patterns.
- Preserve Claude Code hook guidance as a Claude Code adapter.
- Update validation so platform-specific names are allowed inside adapter/mapping contexts but not in portable workflow instructions.
- Clarify Codex install paths for this environment and shared installations.
- Include `references/design-philosophy.md` in the migration because it currently contains hook/tool examples.
- Add behavior-level fixtures that prove the skill produces platform-appropriate guidance.

Out of scope:

- Removing Claude Code support.
- Replacing the `new` and `boost` workflows.
- Adding runtime hook implementations for every platform.
- Changing the skill's public purpose or target platforms.
- Introducing non-shell dependencies.

## Target Selection

When a workflow needs platform-specific enforcement guidance:

1. If the user explicitly names a platform, load only that platform's adapter.
2. If the current task is to build a portable skill, stay on the portable core and reference adapter tradeoffs only when choosing enforcement mechanisms.
3. If the user does not specify a platform and the task is being executed in Codex, default to the portable core plus the Codex adapter.
4. If auditing an existing skill, infer target platforms from its README, install paths, frontmatter, adapter docs, or user request. If still ambiguous, report the ambiguity and continue with portable-core findings first.

Adapters are not always-loaded material. They are loaded only when platform-specific implementation or audit decisions are required.

## Enforcement Strength Model

Do-axis mechanisms must be classified by strength:

| Strength | Meaning | Examples |
|---|---|---|
| Advisory | Reminds the agent, but violation is easy | checklist text, comments |
| Detectable | Violation can be found after the fact | validation scripts, grep checks, command output review |
| Blocking | Violation is prevented by the runtime or workflow gate | artifact gate with required content, CI gate, hook denial |
| External | Enforced outside the agent session | CI, pre-commit, platform policy, repository protection |

Codex guidance should avoid claiming that checklists or pasted command outputs are blocking. They are usually detectable unless paired with a strict artifact gate or CI.

Claude Code hooks may be blocking, but only in the Claude Code adapter and only when the user installs the hook mechanism.

## Proposed Design

### 1. Keep Core Enforcement Platform-Neutral

`references/constraint-enforcement-guide.md` should define only the portable model:

- Think axis: cognitive guidance, red lines, anti-rationalization tables.
- Do axis: mechanisms that make violations blocking, detectable, or externally enforced.
- Default portable mechanisms:
  - artifact gates
  - verification scripts
  - required checklist output
  - command/test result capture
  - CI or pre-commit checks when a repository already has them

Hook templates and named platform tools should not appear as baseline enforcement.

### 2. Add Platform Enforcement Adapters

Add adapter references:

```text
references/adapters/claude-code.md
references/adapters/codex.md
```

Claude Code adapter covers:

- `PreToolUse` and hook templates
- tool permission restrictions
- sub-agent tool scoping
- `~/.claude/skills/`
- hooks as optional blocking enforcement
- fallback artifact/script gates when hooks are unavailable or not installed

Codex adapter covers:

- artifact gates as the primary progression control
- `apply_patch` for manual file edits
- shell scripts for deterministic validation
- short plan/checklist updates for multi-step work
- final verification reporting
- command output capture as detectable evidence, not automatic blocking
- skill roots:
  - `~/.codex/skills/` for Codex-specific local user skills in this environment
  - `~/.agents/skills/` for shared/cross-agent skill installations when supported
- no reliance on Claude Code hook interception

### 3. Update Platform Adaptation Guidance

`references/platform-adaptation.md` should separate:

- portable instruction style
- platform capability matrix
- adapter loading guidance
- install path notes

Portable workflow files should use semantic verbs:

- read a file
- edit a file
- execute a command
- search the codebase
- dispatch a review task

Platform tool names belong only in adapter docs, mapping tables, explicit examples, or tests.

### 4. Update Core Philosophy and Workflows

Files to update:

- `SKILL.md`
- `references/constraint-enforcement-guide.md`
- `references/design-philosophy.md`
- `references/platform-adaptation.md`
- `references/new-workflow.md`
- `references/boost-workflow.md`

Required changes:

- `SKILL.md` references table includes the adapter loading rule.
- `constraint-enforcement-guide.md` no longer presents hooks or named tool access as portable defaults.
- `design-philosophy.md` replaces hook-specific examples with portable examples or points to adapters.
- `new-workflow.md` says to load an adapter only after selecting a target platform or when platform-specific enforcement is required.
- `boost-workflow.md` audits whether platform-specific enforcement belongs in the portable core or an adapter.
- Both workflows say Codex-targeted skills prefer artifact gates, validation scripts, and verification reporting over hooks.
- Both workflows say Claude Code-targeted skills may add hooks as optional reinforcement, but portable skills must also include artifact/script fallback mechanisms.

### 5. Update Validation Scripts

`scripts/verify-platform-names.sh` should classify files before scanning.

Portable instruction files:

- `SKILL.md`
- `references/new-workflow.md`
- `references/boost-workflow.md`
- `references/constraint-enforcement-guide.md`
- `references/design-philosophy.md`
- any future workflow/core reference files not under `references/adapters/`

Adapter or mapping files:

- `references/platform-adaptation.md`
- `references/adapters/*.md`

Rules:

- Portable instruction files fail on imperative platform-tool phrasing.
- Adapter/mapping files may mention platform tool names.
- Code blocks, "Do/Don't" examples, mapping tables, and tests may mention platform tool names when clearly marked as examples.
- The script must recursively scan `references/` so `references/adapters/*.md` are visible.
- The script output must identify each hit as `portable-fail`, `adapter-allowed`, or `example-ignored` when verbose mode is enabled.

Required test fixtures in `scripts/test-verify-scripts.sh`:

- portable `SKILL.md` with semantic verbs passes
- portable `SKILL.md` with "Use Bash" fails
- portable workflow reference with "Run Grep" fails
- adapter file with `PreToolUse`, `Read`, `Edit`, `Write`, `Bash`, or `Agent` passes
- `platform-adaptation.md` style mapping table passes
- unmarked imperative tool guidance in a core reference fails

### 6. Add Behavior-Level Fixtures

Static validation is not enough. Add lightweight fixtures under:

```text
docs/specs/fixtures/codex-portable-enforcement/
```

Required fixtures:

- `codex-new-expected.md`: expected guidance for creating a Codex-targeted skill. Must not prescribe Claude Code hooks as required enforcement.
- `claude-code-new-expected.md`: expected guidance for creating a Claude Code-targeted skill. Must preserve hook guidance as optional blocking enforcement.
- `portable-boost-expected.md`: expected guidance for boosting a portable skill. Must separate portable core defects from platform adapter recommendations.

These fixtures may be markdown snapshots, not generated automatically at first. They become regression references for future behavioral evals.

## Acceptance Criteria

1. Codex can use the skill without being instructed to depend on Claude Code hooks.
2. Claude Code hook support remains documented and usable through the Claude Code adapter.
3. `references/constraint-enforcement-guide.md` reads as a platform-neutral core model.
4. `references/design-philosophy.md` no longer leaks Claude-specific hook/tool examples as portable guidance.
5. Codex-specific enforcement guidance exists and names artifact gates, validation scripts, `apply_patch`, verification reporting, and Codex skill roots.
6. Platform-specific tool names are absent from portable workflow instructions, except where clearly marked as examples.
7. Adapter docs may contain platform-specific names without failing validation.
8. Gemini CLI and OpenClaw remain represented in the platform matrix and fallback guidance.
9. Behavior fixtures exist for Codex-targeted new, Claude Code-targeted new, and portable boost scenarios.
10. `./scripts/verify-token-budget.sh .` passes.
11. `./scripts/verify-platform-names.sh .` passes after validator rules are updated.
12. `./scripts/test-verify-scripts.sh` passes.

## Verification Plan

Run:

```bash
./scripts/verify-token-budget.sh .
./scripts/verify-platform-names.sh .
./scripts/test-verify-scripts.sh
```

Manual review:

- Inspect `SKILL.md` for trigger breadth, adapter loading rule, and portable phrasing.
- Inspect `constraint-enforcement-guide.md` for Claude-specific leakage.
- Inspect `design-philosophy.md` for hook/tool examples that should move to adapters.
- Inspect both adapters to confirm Claude Code and Codex each have clear enforcement guidance.
- Confirm `new` and `boost` workflows load adapters only when platform-specific work is required.
- Confirm Gemini CLI and OpenClaw support did not regress in `platform-adaptation.md`.

Behavior review:

- Compare Codex-targeted guidance against `docs/specs/fixtures/codex-portable-enforcement/codex-new-expected.md`.
- Compare Claude Code-targeted guidance against `docs/specs/fixtures/codex-portable-enforcement/claude-code-new-expected.md`.
- Compare portable boost guidance against `docs/specs/fixtures/codex-portable-enforcement/portable-boost-expected.md`.

## Token Budget Strategy

Do not solve adapter support by inflating always-loaded or workflow files.

Rules:

- New adapter content lives in `references/adapters/`.
- Core workflow edits should be short routing text, not embedded platform guidance.
- If a workflow file crosses 2000 words, move details into adapter or deep reference files.
- After every substantive edit, run `./scripts/verify-token-budget.sh .`.

## Migration Order

1. Create adapter files.
2. Rewrite `constraint-enforcement-guide.md` to remove hooks and named tools from the portable baseline.
3. Rewrite hook/tool examples in `design-philosophy.md` to either portable examples or adapter pointers.
4. Update `platform-adaptation.md` with adapter loading and install path decisions.
5. Update `new-workflow.md` and `boost-workflow.md` routing text.
6. Update `verify-platform-names.sh` and its tests.
7. Add behavior fixtures.
8. Run verification.

## Open Questions

- Should `description` be narrowed so `mojo-skill-creator` does not compete with Codex's built-in `skill-creator`, or should explicit invocation remain the recommended usage?
- Should behavior fixtures remain manual markdown snapshots, or should a future script compare generated outputs against them?
