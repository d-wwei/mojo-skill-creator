# Portable Boost Expected Guidance

For boosting a portable skill, diagnosis should separate:

- Portable core defects: missing red lines, subjective acceptance criteria, token budget violations, broken references, or platform-specific wording inside workflow instructions.
- Adapter recommendations: Claude Code hooks, Codex `apply_patch` discipline, platform-specific install paths, tool permission scoping, or runtime-specific fallback notes.

The boost report should not mark a portable skill incomplete only because it lacks Claude Code hooks. It should require at least one portable Do-axis mechanism for high-stakes constraints: artifact gate, validation script, CI/pre-commit check, or equivalent detectable evidence.
