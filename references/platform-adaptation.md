# Platform Adaptation Guide

How to create skills that work across Claude Code, Codex, Gemini CLI, and OpenClaw.

---

## Baseline Format (All Platforms)

All major agent platforms converge on the same skill format:

```yaml
---
name: skill-name
description: When and why to activate this skill
---

# Markdown instruction body
```

**Required fields**: `name`, `description`
**File**: `SKILL.md` in a named directory
**Supporting resources**: `references/`, `scripts/`, `assets/` subdirectories

This is the universal baseline. Write to this format and the skill works everywhere.

---

## Discovery Paths

Where each platform looks for skills:

| Platform | User-global | Project-local | Shared |
|----------|------------|---------------|--------|
| Claude Code | `~/.claude/skills/` | project plugins | — |
| Codex | `~/.agents/skills/` | `.agents/skills/` | — |
| Gemini CLI | `~/.gemini/skills/` | `.gemini/skills/` | `~/.agents/skills/` |
| OpenClaw | `~/.openclaw/skills/` | workspace `skills/` | `~/.agents/skills/` |

**Installation**: Symlink the skill directory into the platform's discovery path:
```bash
ln -sf /path/to/my-skill ~/.claude/skills/my-skill
ln -sf /path/to/my-skill ~/.agents/skills/my-skill
ln -sf /path/to/my-skill ~/.gemini/skills/my-skill
```

---

## Tool Name Mapping

Skills should use **platform-agnostic semantic verbs** in instructions. If platform-specific guidance is needed, provide a mapping table within the skill.

| Semantic Action | Claude Code | Codex | Gemini CLI | OpenClaw |
|----------------|-------------|-------|-----------|----------|
| Read a file | Read | native | read_file | Read |
| Write a file | Write | native | write_file | Write |
| Edit a file | Edit | native | replace | Edit |
| Run a command | Bash | native shell | run_shell_command | Bash |
| Search file content | Grep | native | grep_search | Grep |
| Find files by pattern | Glob | native | glob | Glob |
| Invoke a skill | Skill | skill | activate_skill | skill |
| Launch sub-agent | Agent | spawn_agent | *not supported* | Agent |
| Search the web | WebSearch | native | google_web_search | WebSearch |
| Fetch a URL | WebFetch | native | web_fetch | WebFetch |
| Create tasks | TaskCreate | native | write_todos | TaskCreate |

### Writing Platform-Agnostic Instructions

**Do**: "Read the configuration file and extract the relevant section."
**Don't**: "Use the Read tool to open the configuration file."

**Do**: "Search the codebase for functions matching the pattern."
**Don't**: "Run Grep with the pattern parameter."

**Do**: "Execute the validation script and check the exit code."
**Don't**: "Use Bash to run the script."

When a skill MUST reference specific tool behavior (e.g., explaining search syntax), use a conditional block:

```markdown
## Platform-Specific Notes
- **Claude Code / OpenClaw**: Grep supports ripgrep regex syntax
- **Gemini CLI**: grep_search uses similar regex syntax
- **Codex**: Native search tools support standard regex
```

---

## Capability Boundaries and Fallbacks

Not all platforms support all features. Design skills with graceful degradation.

| Capability | Claude Code | Codex | Gemini CLI | OpenClaw |
|-----------|-------------|-------|-----------|----------|
| Sub-agent dispatch | Yes (Agent tool) | Yes (spawn_agent) | **No** | Yes (Agent) |
| Background tasks | Yes | Yes | Limited | Yes |
| MCP servers | Yes | Yes | Yes | Yes |
| File system access | Full | Sandboxed | Full | Full |
| Interactive prompts | Yes | Yes | Yes | Yes |

### Fallback Strategies

**Sub-agent unavailable** (Gemini CLI):
- Replace parallel dispatch with sequential execution in a single session
- Skill instruction: "If sub-agent dispatch is not available, execute tasks sequentially in the order listed."

**Sandboxed file system** (Codex App):
- Limit file operations to the project directory
- Avoid absolute paths; use relative paths from project root

**General fallback pattern**:
```markdown
## Execution Mode

Preferred: Dispatch tasks T1-T4 to parallel sub-agents.
Fallback: If parallel dispatch is unavailable, execute T1 → T2 → T3 → T4 sequentially.
```

---

## Extended Metadata (Optional)

Some platforms support additional frontmatter fields. These are ignored by platforms that don't recognize them.

```yaml
---
name: my-skill
description: Core description (all platforms read this)
version: 1.0.0                          # Codex, OpenClaw
metadata:
  openclaw:
    requires:
      bins: ["git", "node"]             # OpenClaw: load-time gating
      env: ["API_KEY"]                  # OpenClaw: env var check
    os: ["darwin", "linux"]             # OpenClaw: OS filter
---
```

**Recommendation**: Include extended metadata only when the skill genuinely requires specific binaries, environment variables, or OS features. Most skills need only `name` and `description`.

---

## Project-Level Instructions

Each platform has a project-level instruction file (complementary to skills):

| Platform | File | Behavior |
|----------|------|----------|
| Claude Code | `CLAUDE.md` | Loaded at session start |
| Codex | `AGENTS.md` | Hierarchical (directory tree cascade) |
| Gemini CLI | `GEMINI.md` | Hierarchical + `/memory` commands |
| OpenClaw | — | Via workspace config |

Skills and project instructions serve different purposes:
- **Skills**: Reusable, portable, task-triggered expertise
- **Project instructions**: Repo-specific conventions, always-on context

Do not duplicate project-level content inside skills. Reference it instead.
