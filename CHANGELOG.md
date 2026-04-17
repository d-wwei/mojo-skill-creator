# Changelog

## [0.5.0] - 2026-04-17

### Development Practices — 把实战教训写进流程

**Background**: MSC 有设计哲学和红线，但缺少工程纪律层面的规则（依赖管理、向后兼容、决策记录、密钥安全等）。13 条原则来自生产环境教训。
**Strategy**: 薄声明 + 分布式 enforcement。SKILL.md 列 10 条一行声明，reference 文件放完整规则，new/boost workflow 在关键步骤加 checkpoint。引入 ADR 机制和混合 CHANGELOG 格式。

### Added
- "Development Practices" section in SKILL.md: 10 universal principles with P-IDs, tagged [A]/[B]/[AB]
- 3 new Red Lines: ADR for architecture decisions (P4+P5), backward compatibility (P6), secrets safety (P10)
- `references/development-practices.md`: principle rules table + ADR template/lifecycle + hybrid CHANGELOG spec
- 6 "Dev Practice" enforcement checkpoints in `new-workflow.md` (Steps 1, 2, 3, 5, 6, 8)
- Backward compat + ADR audit diagnostics in `boost-workflow.md` (Phase 1.1 + 1.9)
- `docs/adr/ADR-0001.md`: seed ADR recording this decision (retroactive)
- Conditional practices P9 (security layering) and P11 (anti-duplicate counting) in reference file

### Changed
- CHANGELOG format upgraded to hybrid: narrative header (≤5 lines) + Keep a Changelog categories
- `new-workflow.md` compressed from 1994w to 2000w (freed ~100w for checkpoints)
- `boost-workflow.md` structural audit expanded from 7 to 9 items
- SKILL.md body: 528w → 750w (router budget: 1000w)

### Pipeline Artifacts
- Requirements: `docs/brainstorms/development-principles-requirements.md`
- Plan: `docs/plans/development-principles-plan.md`
- Review: `docs/reviews/development-principles-review.md`
- ADR: `docs/adr/ADR-0001.md`

## [0.4.0] - 2026-04-17

### Behavioral Eval — skill 产出质量的最后一道检验

**Background**: 验证脚本检查结构，但 skill 的输出质量（风格、判断力、边界处理）只能通过实际运行来检验。
**Strategy**: 加入可选的 Step 10 行为评估循环——设计测试场景、subagent 执行、加权评分、外科手术式修复。同时放宽 router 层 token 预算（500w → 1000w）以容纳更丰富的路由逻辑。

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
