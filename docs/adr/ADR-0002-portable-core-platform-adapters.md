# ADR-0002: Split Portable Core from Platform Enforcement Adapters

## Status
Accepted (2026-05-28)

## Context
Mojo Skill Creator originally described constraint enforcement with Claude Code-shaped concepts such as hooks, named tools, and tool-call interception. That made the guidance useful for Claude Code, but ambiguous for Codex and risky for portable skills: a portable skill could accidentally depend on enforcement that only one runtime provides.

The Codex compatibility spec (`docs/specs/2026-05-28-codex-portable-enforcement-adapters.md`) changes multiple core references and constrains future platform guidance, so it meets the ADR threshold from ADR-0001.

## Decision
1. Keep the Think + Do constraint model in a platform-neutral core.
2. Move runtime-specific enforcement details into adapter references under `references/adapters/`.
3. Add a Codex adapter for artifact gates, validation scripts, patch discipline, and verification reporting.
4. Preserve Claude Code hook guidance in a Claude Code adapter.
5. Treat target platform and current runtime as separate decisions: target platform controls generated skill content; runtime adapter only guides local execution discipline.

## Rejected Alternatives
- **Make the skill Codex-only**: Rejected because cross-platform distribution is a core value of MSC.
- **Keep hooks in the portable core**: Rejected because it overstates portability and can produce unusable guidance for Codex, Gemini CLI, or OpenClaw.
- **Duplicate full workflows per platform**: Rejected because it would inflate maintenance cost and token load. Thin adapters preserve progressive disclosure.

## Consequences
- Claude Code remains supported, but hook guidance is explicitly adapter-scoped.
- Codex can use the skill without depending on Claude Code hook semantics.
- Validators must distinguish portable workflow files from adapter/mapping files.
- Future platform additions should add adapter references instead of expanding portable workflow files.
- `new-workflow.md` and `boost-workflow.md` remain close to the 2000-word budget, so platform detail must stay in adapters.
