# Claude Code Enforcement Adapter

Use this adapter only when the target platform is Claude Code or a skill is explicitly Claude Code-only.

## Enforcement Surface

Claude Code can add blocking enforcement through hooks and tool permissions. Treat these as platform enhancements, not portable defaults.

| Mechanism | Strength | Use When |
|---|---|---|
| Artifact gate | Blocking | A workflow phase must produce an auditable file before continuing |
| Verification script | Detectable or blocking | A shell check can measure the constraint; blocking when wired into CI or hooks |
| PreToolUse hook | Blocking | A dangerous action must be denied until a precondition is met |
| Tool permission scope | Blocking | A delegated task must not edit, execute, or dispatch |

## Hook Template

Use hooks only when the recipient is expected to install Claude Code hook configuration.

```text
IF a tool call targets {path or action}
AND {required artifact/check is missing}
THEN deny with: "{specific recovery step}"
```

Example: prevent editing a skill router before domain research exists.

```text
Trigger: Edit/Write on */SKILL.md
Condition: build/domain-research.md does not exist
Action: deny — Complete domain research first.
```

Pair every hook with a portable fallback such as an artifact gate or verification script unless the skill is explicitly Claude Code-only.

## Hook Safety Contract

- Prefer deny-only hooks that block risky actions instead of hooks that perform actions.
- Keep path scopes narrow and auditable.
- Do not exfiltrate file contents, prompts, logs, or user data.
- Do not run unreviewed shell commands from hooks.
- Confirm hook installation separately from skill installation.

## Sub-Agent Scoping

When dispatching review or research work, scope permissions in natural language and, where available, tool restrictions.

| Role | Allowed | Disallowed | Purpose |
|---|---|---|---|
| Reviewer | Read, Grep, Glob | Edit, Write, Bash | Inspect only |
| Researcher | Read, Grep, WebSearch, WebFetch | Edit, Write | Gather evidence |
| Implementer | Read, Grep, Edit, Write, Bash | Agent | Change files without spawning more agents |

## Install Notes

User-global Claude Code skills are commonly linked under:

```bash
~/.claude/skills/
```

Document hook installation separately from skill installation. A skill can load without hooks; hooks only strengthen enforcement after installation.
