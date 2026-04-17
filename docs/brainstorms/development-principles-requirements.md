---
title: "Development Principles Integration Requirements"
scope: standard
status: approved
created: 2026-04-17
updated: 2026-04-17
approval: user approved with modifications (hybrid CHANGELOG + ADR mechanism)
adversarial_review: .apex/verifications/brainstorm-adversarial.md (11 issues, all addressed below)
---

# Development Principles Integration Requirements

## Problem Statement

mojo-skill-creator 有 7 条设计哲学原则和 10 条红线，但缺少软件工程实践层面的开发原则。用户提出 13 条原则需要编码进 skill 中，适用于两个层面：A（MSC 自身开发）和 B（MSC 创建/升级的产出 skill）。

## Confirmed Decisions

### D1: 方案选择 — 新段落 + 分布式 enforcement
不扩展 Core Design Principles（避免混合设计哲学与工程实践），不用纯 reference（容易被跳过）。在 SKILL.md 新增 "Development Practices" 段落（薄声明）+ 硬约束提升为 Red Lines + enforcement 分布到 workflow 步骤。

### D2: CHANGELOG 格式 — 混合格式
顶部 3-5 行叙事（背景 + 策略概要）→ 底部 Keep a Changelog 分类（Added/Changed/Fixed）。叙事部分限制在 5 行以内。
- 叙事仅 minor+ 版本必填，patch 版本可选
- 叙事写 KaC 不覆盖的"为什么"和"策略"，不重复 KaC 内容
- 允许自定义 KaC 分类（如 "Pipeline Artifacts"），但必须排在标准分类之后
- 5 行限制为 advisory（非机械门禁）

### D3: 架构决策记录 — ADR 机制
引入 Architecture Decision Records 解决"架构决策写设计理由"(#4) 和"不做的决定记录理由"(#5)。ADR 模板：Status / Context / Decision / Rejected Alternatives / Consequences。
- **决策阈值**：影响 ≥2 个文件或对未来变更产生约束的技术选择才需要 ADR。日常 bug fix 不需要
- **状态转换**：Proposed → Accepted → Superseded / Deprecated
- **Layer B 策略**：Deep scope 产出 skill 推荐 ADR；Lightweight/Standard 不强制
- **ADR-0001 是显式追溯记录**（bootstrapping），其 Context 段须说明这一点

### D4: Clippy → 泛化为 Linter 零警告
不锁定 Rust。通用规则为"项目 linter 零警告作为 CI 硬门禁"，具体 linter 由项目决定。

### D5: P6 向后兼容 — 可执行定义
- **"已发布"定义**：有 semver 版本标签 OR 已显式分发给外部用户
- **"破坏性变更"定义**：移除/重命名已有命令、参数、配置字段；改变已有字段的语义。新增字段不算破坏
- **机械检查**：`boost` workflow 中 diff SKILL.md 的 Red Lines + Acceptance + sub-command sections 对比上一个 tag
- **`new` workflow**：无先前版本，P6 不适用于 `new` 但在 Red Lines 中保留以建立意识

## Principles Catalog (13 → 11 distinct items after ADR merge)

SKILL.md 只列 9 条通用原则。P9（安全分层）和 P11（防重复计数）是领域特定，仅在 reference 文件中以 conditional 形式出现。

| # | 原则 | 层面 | SKILL.md? | 落地位置 | 硬约束? |
|---|------|------|-----------|---------|---------|
| P1 | 零依赖优先：单文件 > 包管理器，静态 > 动态 | AB | Yes | Development Practices + new Step 5 | No (preference) |
| P2 | 每个新功能必须附带测试 | AB | Yes | Development Practices + new Step 10 升级 | Yes (for A); conditional (for B) |
| P3 | 每个决策都有调研结论记录 | AB | Yes | Development Practices + new Step 2 扩展 | No (practice) |
| P4+P5 | 架构决策和"不做"的决定通过 ADR 记录 | AB | Yes | ADR 机制 + Red Line + new Step 3 | Yes (Red Line) |
| P6 | 向后兼容性：已发布接口不可破坏性变更 | AB | Yes | Red Line + boost 1.1 | Yes (Red Line, boost enforced) |
| P7 | Linter 零警告作为 CI 硬门禁 | AB | Yes | Development Practices + new Step 8 | Yes (for CI projects) |
| P8 | CHANGELOG：混合格式（叙事头 + KaC 分类） | AB | Yes | Development Practices + new Step 8 | Yes |
| P9 | 安全分层设计：权限逐层叠加，每层独立生效 | B | **No** | reference only (conditional) | No (design guidance) |
| P10 | 密码/密钥永远不经过 LLM 对话传递，不写入日志 | AB | Yes | Red Line | Yes (Red Line, CRITICAL) |
| P11 | 防重复计数：标注哪层计数、是否会重复 | B | **No** | reference only (conditional) | No (design checklist) |
| P12 | 先证明现有机制不覆盖，再决定加新功能 | AB | Yes | Development Practices + new Step 1 / boost Phase 1 | Yes |
| P13 | 先调查用户实际行为，不凭假设决策 | AB | Yes | Development Practices + new Step 1 / boost Phase 1 | No (practice) |

### Level A 合规性说明
- P1 零依赖：MSC 是 markdown + shell skill，无外部包依赖。多文件结构是 skill 的正常组织方式，不违反零依赖（preference 级别，指向"不加不必要的依赖"，不是"只能有一个文件"）
- P7 Linter：MSC 当前无 CI pipeline。P7 对 Level A 是 aspirational，bootstrap 时添加 CI 为后续迭代事项

## Token Budget Analysis [已验证]

| Target | Current | Addition | After | Limit | Status |
|--------|---------|----------|-------|-------|--------|
| SKILL.md body | 528w | ~150w (9 principles) + ~75w (3 red lines) | ~753w | 1000w | OK (~247w headroom) |
| references/development-practices.md | 0w (new) | ~950w (table-format principles ~400w + ADR guide ~300w + CHANGELOG spec ~200w + intro ~50w) | ~950w | 2000w | OK |
| references/new-workflow.md | 1994w | +~90w (6 single-line checkpoints) −~100w (compression targets) | ~1984w | 2000w | OK (needs compression plan) |
| references/boost-workflow.md | 1899w | +~50w (2-3 diagnostic additions) | ~1949w | 2000w | OK |

### new-workflow.md 压缩计划
需要释放 ~100w 来容纳 6 个 checkpoint（~90w）。候选压缩区域：
- Step 10 描述段（当前 ~80w，可压缩到 ~50w，因为详情在 behavioral-eval-guide.md）
- Step 7/7b 段落有重复的 "Optional" 说明（~30w 可合并）
- Step 6b 的 body structure 列表可缩短（~20w）

## Files to Change

| File | Action | 内容 | Word budget impact |
|------|--------|------|--------------------|
| SKILL.md | 新增段落 + 扩展 Red Lines | "Development Practices" (~150w) + 3 new Red Lines (~75w) | 528 → ~753w (limit: 1000w) |
| references/development-practices.md | **新建** | 表格格式原则规则 + ADR 模板/生命周期 + CHANGELOG 格式规范 | ~950w (limit: 2000w) |
| references/new-workflow.md | 增量修改 | 6 个单行 checkpoint + 压缩现有内容腾出空间 | 1994 → ~1984w (limit: 2000w) |
| references/boost-workflow.md | 增量修改 | Phase 1.1 加向后兼容 diff check + Phase 1.9 扩展 ADR 审计 | 1899 → ~1949w (limit: 2000w) |
| CHANGELOG.md | 格式升级 | 最新版本条目加叙事头部（示范混合格式） | N/A |
| docs/adr/ADR-0001.md | **新建** | 记录本次"引入 Development Practices + ADR"的决策（显式追溯） | N/A |

### 未包含在本次的变更（显式 deferred）
- 验证脚本更新（verify-token-budget.sh 等）：P7/P8 的 Do-axis enforcement 需要新脚本，列为 follow-up iteration 事项
- MSC 自身 CI pipeline 搭建：P7 Level A 的 bootstrap，列为 follow-up

## Acceptance Criteria

1. SKILL.md 包含 "Development Practices" 段落，9 条通用原则各一行（≤20w/行），标注 [A] [B] [AB]
2. Red Lines 从 10 条扩展到 13 条（+ADR +向后兼容 +密钥安全），每条含 "Check:" 子句
3. `references/development-practices.md` 存在（≤2000w），包含：表格格式原则规则 + ADR 模板及生命周期 + CHANGELOG 格式规范 + P9/P11 conditional 段落
4. `new-workflow.md` 至少 5 个步骤有单行 enforcement checkpoint（格式："**Dev Practice**: [principle ID + check]"）
5. `boost-workflow.md` Phase 1.1 包含向后兼容 diff check，Phase 1.9 扩展 ADR 审计
6. SKILL.md body word count ≤ 1000 words（verify-token-budget.sh 通过）
7. `docs/adr/ADR-0001.md` 存在，Status=Accepted，Context 段声明为追溯记录
8. CHANGELOG.md 最新版本条目升级为混合格式（叙事头 ≤5 行 + KaC 分类）
9. 现有 7 条 Core Design Principles 内容不变（git diff 可验证）

## Constraints

- SKILL.md body ≤ 1000 words (Layer 1 Router budget)
- references/ 每个文件 ≤ 2000 words
- 不修改现有 Core Design Principles #1-#7
- 不修改已有 Red Lines #1-#10（只追加）
- 不改变 `new` 和 `boost` 子命令的接口
- new-workflow.md 修改前必须先压缩 ~100w，确认有空间后再添加 checkpoint
