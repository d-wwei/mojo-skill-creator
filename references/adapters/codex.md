# Codex Enforcement Adapter

Use this adapter when the target platform is Codex or when the current runtime is Codex and the user did not name another target platform.

## Enforcement Surface

Codex does not rely on Claude Code hook interception. Prefer enforcement that is visible in files, scripts, command outputs, and final verification.

| Mechanism | Strength | Use When |
|---|---|---|
| Artifact gate | Blocking in workflow | A phase must not proceed until a named file exists with required content |
| Verification script | Detectable; blocking when required by workflow or CI | A shell check can measure word count, structure, references, or output format |
| Plan/checklist update | Advisory | Multi-step work needs visible progress and stopping points |
| Command output capture | Detectable | Completion claims need evidence from tests or scripts |
| `apply_patch` edit discipline | Detectable | Manual edits should be reviewable and scoped |

## Codex Defaults

- Use artifact gates and validation scripts before platform-specific hooks.
- Treat pasted command output and checklist items as evidence, not automatic blocking.
- Prefer `apply_patch` for manual file edits so changes are explicit.
- Run the narrowest meaningful verification after each coherent slice.
- Final responses should name what changed, what was verified, and residual risk.

## Skill Roots

Use the path that matches the installation intent:

```bash
~/.codex/skills/   # Codex-specific local user skills in this environment
~/.agents/skills/  # Shared/cross-agent skills when supported
```

If both paths are documented, explain which one was used and why.

## Codex Constraint Pattern

For high-stakes red lines, combine:

1. Think-axis rationale in `SKILL.md`.
2. An artifact gate or verification script.
3. A required verification line in the final report.

Example:

```text
Red line: No generated skill is complete without validation evidence.
Do mechanism: Run scripts/verify-token-budget.sh and scripts/verify-platform-names.sh.
Gate: build/validation-checklist.md must include command output before completion.
Strength: Detectable; blocking when the workflow refuses completion without the artifact.
```
