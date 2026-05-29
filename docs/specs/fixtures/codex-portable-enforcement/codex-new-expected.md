# Codex-Targeted New Skill Expected Guidance

For a Codex-targeted skill, enforcement guidance should:

- Use portable red lines and acceptance criteria in `SKILL.md`.
- Prefer artifact gates, validation scripts, command output evidence, and final verification reporting.
- Mention `apply_patch` only as Codex editing discipline, not as a cross-platform requirement.
- Avoid requiring Claude Code hooks, `PreToolUse`, or hook installation.
- Document Codex skill roots when installation guidance is needed: `~/.codex/skills/` for Codex-specific local skills and `~/.agents/skills/` for shared skills.

Expected stance: Codex enforcement is evidence-driven and auditable. Checklists are advisory; scripts and artifacts make violations detectable; workflow gates make completion blocking.
