# Changelog

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
