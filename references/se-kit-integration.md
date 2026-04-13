# Self-Evolution Integration via skill-se-kit

Optional enhancement that gives a skill the ability to learn and improve from its own usage. Based on the skill-se-kit agent-native protocol.

---

## What It Adds

A dual-loop learning system bundled inside the skill package:
- **Execution loop**: Before each task, retrieve relevant past learnings from the skill bank
- **Learning loop**: After each task, extract feedback → record experience → update skill bank

The skill works identically without self-evolution — it is a pure enhancement, not a dependency.

## Distribution Constraint

**The entire skill-se-kit is bundled inside the distributed skill package.** End users do NOT need to install anything globally, clone any repo, or run any setup commands. The package is self-contained.

When skill-se-kit releases a new version, the skill author updates the bundled `se-kit/` directory via the `boost` workflow and redistributes.

---

## Directory Structure After Integration

```
my-skill/
├── SKILL.md                    # Skill's own instructions
├── references/                 # Skill's references
├── se-kit/                     # skill-se-kit bundled (read-only protocol)
│   ├── SKILL.md               # Self-evolution protocol spec (~3400 words)
│   └── schemas/               # JSON validation schemas
└── se-workspace/               # Per-skill evolution data (read-write)
    ├── manifest.json           # Skill identity + governance config
    ├── skill_bank.json         # Accumulated learnings
    ├── experience/             # Immutable experience records
    ├── audit/                  # Immutable decision logs
    └── snapshots/              # Pre-mutation backups
```

**se-kit/**: Protocol files from skill-se-kit. Treated as read-only by the agent. Updated only by the skill author via `boost`.

**se-workspace/**: This skill's own evolution data. Read-write by the agent at runtime. Persists across sessions.

---

## Integration Steps (for `new` workflow)

### 1. Copy Protocol Files

Copy from the skill-se-kit source into `se-kit/`:
- `SKILL.md` (protocol specification)
- `schemas/` directory (all 6 JSON schema files)

Do NOT copy docs/, examples/, tools/, or README files — those are for skill authors, not end users.

### 2. Initialize Workspace

Create `se-workspace/` with:
- `manifest.json` from skill-se-kit's `workspace-template/manifest.json`, edited with:
  - `skill_id`: match the skill's name
  - `name`: human-readable skill name
  - `governance.mode`: "standalone" (default) or "governed"
  - `metadata.contract.auto_promote`: true (default)
- `skill_bank.json`: `{"skills": []}`
- Empty directories: `experience/`, `audit/`, `snapshots/`

### 3. Add Self-Evolution Section to SKILL.md

Append to the skill's own SKILL.md:

```markdown
## Self-Evolution

This skill learns from usage. After each task completion:

1. Dispatch a sub-agent to execute the self-evolution protocol at `se-kit/SKILL.md`
2. The sub-agent operates on `se-workspace/` — extracting feedback, recording experience, and updating the skill bank
3. Before the next task, retrieve relevant learnings from `se-workspace/skill_bank.json` and inject as context

Fallback (platform without sub-agent support): Execute the learning loop sequentially after the main task completes, in the same session.
```

---

## Runtime Behavior

### Main Agent (executes the skill)

1. Before task: Read `se-workspace/skill_bank.json`, score entries against current task, inject top matches as guidance
2. Execute the task using the skill's main workflow
3. After task: Dispatch sub-agent for learning loop

### Sub-Agent (executes self-evolution)

1. Read `se-kit/SKILL.md` for protocol instructions
2. Extract structured feedback from the completed task
3. Check confidence gate (≥ 0.35 default)
4. Record experience to `se-workspace/experience/`
5. Run decision tree: ADD / MERGE / SUPERSEDE / DISCARD
6. If mutating skill bank: create snapshot first, then apply, then audit log
7. Exit

### Token Impact

| Context | Additional Token Cost |
|---------|----------------------|
| Main skill (with skill bank retrieval) | +50-100 words (pointer + injected learnings) |
| Sub-agent (self-evolution protocol) | ~3400 words (isolated context, does not affect main skill) |
| Platforms without sub-agent | ~3400 words added to main session (significant) |

---

## Upgrade Path (via `boost`)

When skill-se-kit releases a new version:

1. `boost` Phase 1.6 detects the outdated `se-kit/` version
2. Phase 2.3 prescribes: replace `se-kit/SKILL.md` and `se-kit/schemas/` with latest release
3. `se-workspace/` data is preserved — schemas are backward-compatible
4. Skill author redistributes the updated package

End users receive the upgrade as part of the normal skill update — no action on their part.
