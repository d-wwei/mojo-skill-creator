# Development Practices

Engineering discipline rules for MSC development [A] and skills MSC produces [B]. Complements the 7 Design Principles (philosophy) with concrete engineering practices.

---

## Universal Practices (always loaded in SKILL.md)

| ID | Practice | Scope | Enforcement | Hard? |
|----|----------|-------|-------------|-------|
| P1 | **Zero-dependency preference**: single-file > package manager; static link > dynamic. Justify every added dependency | AB | `new` Step 5: audit resource plan for unnecessary deps | No |
| P2 | **Every new feature ships with tests**: no untested feature merges. For skills: behavioral eval (Step 10) upgrades from optional to expected for Standard+ scope | AB | `new` Step 10; `boost` Phase 3 | Yes (A) |
| P3 | **Every decision has a research trail**: architecture, tool selection, and design choices cite evidence — not convention alone | AB | `new` Step 2 expanded scope; `boost` Phase 1.7 | No |
| P4+5 | **ADR for architecture decisions and non-decisions**: decisions affecting ≥2 files or constraining future changes get an ADR. "We decided NOT to do X" also gets an ADR | AB | Red Line; see ADR Template below | Yes |
| P6 | **Backward compatibility is a hard constraint**: published interfaces (semver-tagged or distributed) cannot have breaking changes without a deprecation cycle | AB | Red Line; `boost` Phase 1.1 diff check | Yes |
| P7 | **Linter zero warnings as CI gate**: project's linter (Clippy, ESLint, pylint, shellcheck, etc.) must pass clean. Specific linter chosen per project | AB | `new` Step 8 validation | Yes |
| P8 | **CHANGELOG in hybrid format**: narrative header (≤5 lines: background + strategy) + Keep a Changelog categories. See Hybrid CHANGELOG Spec below | AB | `new` Step 8; Ship stage | Yes |
| P10 | **Secrets never transit LLM conversation or logs**: passwords, API keys, tokens use OS Keychain or env vars exclusively | AB | Red Line (CRITICAL) | Yes |
| P12 | **Prove existing mechanisms insufficient before adding features**: search existing capabilities first; document why they don't cover the need | AB | `new` Step 1; `boost` Phase 1 | Yes |
| P13 | **Investigate actual user behavior before adding/cutting features**: decisions grounded in observed usage, not assumed preferences | AB | `new` Step 1; `boost` Phase 1 | No |

## Conditional Practices (loaded from reference only, when applicable)

| ID | Practice | Scope | When to Apply |
|----|----------|-------|---------------|
| P9 | **Security layered design**: permissions stack per layer, each layer independently effective, no single-point-of-failure auth | B | Produced skill involves authentication, authorization, or multi-tenant access |
| P11 | **Anti-duplicate counting annotation**: any counting/quota/notification logic must document which layer counts and whether duplication is possible across layers | B | Produced skill involves rate limiting, billing, quotas, or notification triggers |

---

## ADR Template

Architecture Decision Records capture "what we decided, why, and what we rejected." Use for decisions affecting ≥2 files or constraining future changes. Also use for significant "we decided NOT to do X" decisions.

### When to Write an ADR

- Choosing a framework, library, or tool
- Designing a data model or API contract
- Deciding to NOT implement a requested feature
- Changing a workflow or process that others depend on
- Any decision you'd want to explain to a newcomer in 6 months

### Format

```markdown
# ADR-NNNN: [Decision Title]

## Status
[Proposed | Accepted | Superseded by ADR-XXXX | Deprecated]

## Context
[What situation or problem prompted this decision? What constraints exist?]

## Decision
[What was decided and why. Include specific reasoning, not just the choice.]

## Rejected Alternatives
[What else was considered and why each was ruled out. Include "do nothing" if evaluated.]

## Consequences
[What changes as a result? Positive, negative, and neutral impacts. What new constraints does this create?]
```

### Lifecycle

1. **Proposed**: Draft, under discussion
2. **Accepted**: Decision is in effect (date in Status section)
3. **Superseded**: A newer ADR replaces this one (link to successor)
4. **Deprecated**: Decision is no longer relevant (context changed)

### Layer B Guidance

- **Deep scope** skills: ADR directory recommended for major design decisions
- **Standard scope**: ADR optional; design rationale in build/ artifacts may suffice
- **Lightweight scope**: No ADR needed

---

## Hybrid CHANGELOG Spec

### Format

```markdown
## [X.Y.Z] - YYYY-MM-DD

### [Short Title] — [One-phrase summary]

**Background**: [Why this change exists — the problem or trigger]
**Strategy**: [How we approached it — method, not implementation detail]
[Limit narrative to 3-5 lines. No blog posts.]

### Added
- [New capabilities]

### Changed
- [Modifications to existing behavior]

### Fixed
- [Bug fixes]

### Removed / Deprecated / Security
- [As needed — standard KaC categories]
```

### Rules

1. **Narrative required** for minor+ versions (x.Y.0). Optional for patches (x.y.Z)
2. **Narrative content**: the "why" and "strategy" that KaC categories don't capture. Not a summary of the bullet points below
3. **Custom categories allowed** (e.g., "Pipeline Artifacts") — place after standard KaC categories
4. **5-line narrative limit**: advisory, not mechanical gate. If you need 6 lines, use 6. If you need 10, your narrative is a blog post — compress
5. **Every KaC entry is one line**: use sub-bullets only for essential detail
