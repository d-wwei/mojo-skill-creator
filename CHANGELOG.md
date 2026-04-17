# Changelog

## [0.4.0] - 2026-04-17

### Added
- Step 10: Behavioral Eval & Surgical Fix (Optional) in `new` workflow
- `references/behavioral-eval-guide.md` — 5-phase eval loop: design scenarios → subagent execution → weighted scoring → surgical fix → re-score
- Test scenario coverage: ≥3 minimum (simple/boundary/adversarial), no upper limit, per-sub-command and per-red-line coverage required
- Scoring system: red lines = CRITICAL (3x), acceptance criteria = HIGH (2x), quality dimensions = MEDIUM (1x)
- Surgical fix protocol with strict discipline: one FAIL → one fix → verify → regression → next
- Termination rules: SUCCESS (≥A/90%), PLATEAU (3 rounds <5% gain), MAX_ROUNDS (10)
- Upgrade trigger: plateau or max rounds → recommend `boost` for structural redesign

### Changed
- Router layer token budget: 500w → 1000w (across SKILL.md, new-workflow.md, boost-workflow.md, README.md, README.zh-CN.md)
- Step 8 validation: router word count target updated from 500 to 1000

## [0.3.0] - 2026-04-15

### Added
- Unified constraint framework integration (Think + Do dual-axis model)
- Design Principle 7: Dual-Axis Constraints in design-philosophy.md
- Step 3d (Constraint Enforcement Design) in `new` workflow with artifact gate
- Phase 1.9 (Constraint Enforcement Audit) in `boost` workflow with artifact gate
- `references/constraint-enforcement-guide.md` — 4 enforcement mechanisms
- 3 verification scripts: `verify-token-budget.sh`, `verify-platform-names.sh`, `verify-artifact-content.sh`
- MSC self-analysis as dogfood validation (`docs/solutions/msc-constraint-analysis.md`)
- New red line: high-stakes constraints must have Do-axis enforcement
- New acceptance criterion: ≥30% red lines with Do-axis mechanisms

### Changed
- Compressed `new-workflow.md` from 2127w to 1930w
- Compressed `boost-workflow.md` from 2626w to 1891w
- Compressed `SKILL.md` body from 563w to ~500w
- Updated word count estimates in SKILL.md references table

### Pipeline Artifacts
- Requirements: `docs/brainstorms/constraint-framework-integration-requirements.md`
- Plan: `docs/plans/constraint-framework-integration-plan.md`
- Review: `docs/reviews/constraint-framework-integration-review.md`
- Execution Log: `docs/execution/constraint-framework-integration-log.md`
