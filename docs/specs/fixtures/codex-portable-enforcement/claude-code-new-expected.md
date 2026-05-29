# Claude Code-Targeted New Skill Expected Guidance

For a Claude Code-targeted skill, enforcement guidance should:

- Keep the portable core: red lines, acceptance criteria, artifact gates, and validation scripts.
- Allow Claude Code hooks as optional blocking enforcement when the recipient installs them.
- Place `PreToolUse`, named tool permissions, and hook examples in the Claude Code adapter, not the portable core.
- Pair hooks with artifact or script fallbacks unless the skill is explicitly Claude Code-only.
- Document `~/.claude/skills/` for user-global installation.

Expected stance: Claude Code hooks strengthen enforcement, but portable fallback mechanisms keep the skill useful without hook installation.
