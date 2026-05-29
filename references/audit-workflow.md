# `audit` — Read-Only Skill Review

Use this workflow when the user asks to audit, review, or assess a skill without explicitly asking to boost, upgrade, or edit it.

## Boundaries

- Do not create `diagnosis/`, `build/`, or other artifacts.
- Do not edit files.
- Do not run fix scripts that mutate the workspace.
- If the user asks for improvements after the audit, switch to `boost`.

## Review Steps

1. Identify the target skill and intended platforms from the user request, README, install paths, and SKILL.md.
2. Inspect `SKILL.md` frontmatter, trigger breadth, stance, red lines, acceptance criteria, and reference routing.
3. Check progressive disclosure: always-loaded content stays small; workflow/reference files are loaded only when needed.
4. Review enforcement: classify red lines as Think-only or Think+Do, and note advisory/detectable/blocking/external strength.
5. Check platform boundaries: portable instructions use semantic verbs; platform-specific details live in adapters or mapping references.
6. Check safety and privacy: no secrets, raw chat transcripts, private data retention, or unbounded external research requirements.
7. Check verification: scripts, fixtures, tests, or manual gates exist for the claims the skill makes.

## Output

Report findings first, ordered by severity:

- `P1`: likely incorrect behavior, unsafe behavior, or major user confusion
- `P2`: important gap that can cause regression or failed distribution
- `P3`: polish, maintainability, or documentation issue

For each finding, include file/line, risk, and a concrete fix. End with the top 2-3 fixes worth absorbing first.
