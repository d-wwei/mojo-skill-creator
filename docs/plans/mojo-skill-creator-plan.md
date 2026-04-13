---
title: Mojo Skill Creator — Implementation Plan
scope: standard
status: approved
created: 2026-04-13
source: docs/brainstorms/mojo-skill-creator-requirements.md
task_count: 8
complexity: medium
---

# Mojo Skill Creator — Implementation Plan

## Problem Frame

需要一个平台无关的 Skill Creator 技能（含 `new` 和 `boost` 两条路径），融合 6 个设计维度，用 4 层分层架构控制 token 开销，可部署到 Claude Code / Codex / Gemini CLI / OpenClaw。

## Decision Log

| Decision | Rationale | Rejected |
|----------|-----------|----------|
| Approach B: 主 SKILL.md + references 分流 | SKILL.md 保持 ~500 词薄路由，符合自身 4 层架构主张 | A（单文件过大）、C（双 skill 重复维护） |
| 用平台无关语义动词写指令 | 跨平台公约数，避免绑定任何单一平台 | 用 Claude Code 工具名 + 映射表 |
| `new` + `boost` 子命令 | 用户确认，务实无隐喻 | forge/reforge, craft/hone, spark/evolve |
| Layer 3 references 按职责拆分（非按子命令） | design-philosophy 和 anti-patterns 两条路径共享 | 按子命令拆（导致重复） |
| 人类可观测性作为 optional 设计维度 | 不是所有 skill 都需要，但分析/决策类强烈推荐 | 强制所有 skill 都生成 artifact |

## File Manifest

### Create

| File | Layer | Purpose | Token Budget |
|------|-------|---------|-------------|
| `SKILL.md` | 1 (Router) | 入口路由 + 核心原则压缩版 | ≤500 词 |
| `references/new-workflow.md` | 2 (Workflow) | `new` 子命令完整流程 | ~1500-2000 词 |
| `references/boost-workflow.md` | 2 (Workflow) | `boost` 子命令完整流程 | ~1500-2000 词 |
| `references/design-philosophy.md` | 3 (Reference) | 设计哲学完整版（5 原则 + 示例） | ~1200 词 |
| `references/platform-adaptation.md` | 3 (Reference) | 四平台适配指南 + 工具映射 + fallback | ~1000 词 |
| `references/anti-patterns-by-domain.md` | 3 (Reference) | 领域反模式库（4 域） | ~800 词 |
| `references/quality-ladder.md` | 3 (Reference) | 知识层次诊断 + 案例资产库方法论 | ~1200 词 |

### Existing (no change)

| File | Note |
|------|------|
| `LICENSE-apache2.0` | 已有，保留 |
| `skill-creator-original.md` | 参考源，保留 |
| `skill-development-plugin.md` | 参考源，保留 |

## Task Decomposition

### Phase 1: Layer 3 References (并行，无互相依赖)

#### T1: 创建 references/design-philosophy.md

- **Description**: 将 ljg 分析中的 5 个设计原则（红线优先、验收前置、姿态替代角色、反模式驱动、工作流组合）整理为完整参考文档，含原理说明和具体示例
- **Files**: `references/design-philosophy.md`
- **Complexity**: small
- **Dependencies**: none
- **Acceptance criteria**: AC4 (自身遵循设计原则)

#### T2: 创建 references/platform-adaptation.md

- **Description**: 整理 Claude Code / Codex / Gemini CLI / OpenClaw 四平台的 SKILL.md 格式差异、工具名映射表、发现路径、能力边界和 fallback 策略
- **Files**: `references/platform-adaptation.md`
- **Complexity**: medium
- **Dependencies**: none
- **Acceptance criteria**: AC3 (跨平台部署), AC5 (无平台特有工具名)

#### T3: 创建 references/anti-patterns-by-domain.md

- **Description**: 按写作、视觉、分析、教学四领域分类，每条反模式可机械检验，来源于 ljg-skills 分析
- **Files**: `references/anti-patterns-by-domain.md`
- **Complexity**: small
- **Dependencies**: none
- **Acceptance criteria**: AC1 (new 流程含红线)

#### T4: 创建 references/quality-ladder.md

- **Description**: 从 human-workflow 方法论提取知识层次诊断方法、案例资产库三级体系、四维度覆盖、特异性测试、约束收紧梯度、缺陷分层修复
- **Files**: `references/quality-ladder.md`
- **Complexity**: medium
- **Dependencies**: none
- **Acceptance criteria**: AC2 (boost 流程诊断知识层次)

### Phase 2: Layer 2 Workflows (依赖 Phase 1)

#### T5: 创建 references/new-workflow.md

- **Description**: 基于 skill-creator-original 6 步流程改造的 `new` 子命令完整工作流。融合红线优先设计顺序、验收前置、姿态设定、4 层 token 预算规划、可选人类可观测性。全程平台无关语义
- **Files**: `references/new-workflow.md`
- **Complexity**: large
- **Dependencies**: T1 (design-philosophy), T2 (platform-adaptation), T3 (anti-patterns)
- **Acceptance criteria**: AC1, AC3, AC5, AC6

#### T6: 创建 references/boost-workflow.md

- **Description**: `boost` 子命令完整工作流。包含知识层次诊断、context 效率审计、人类可观测性审计、基于诊断结果的分层提升方案。引用 quality-ladder 和 design-philosophy
- **Files**: `references/boost-workflow.md`
- **Complexity**: large
- **Dependencies**: T1 (design-philosophy), T4 (quality-ladder)
- **Acceptance criteria**: AC2, AC7

### Phase 3: Layer 1 Router (依赖 Phase 2)

#### T7: 创建 SKILL.md

- **Description**: 薄路由入口。Frontmatter（name, description, 触发短语）+ 核心设计原则压缩版（~5 条，每条一句）+ new/boost 路由指令 + references 指针清单（含 token 预估）。严格控制 ≤500 词
- **Files**: `SKILL.md`
- **Complexity**: medium
- **Dependencies**: T5 (new-workflow), T6 (boost-workflow)
- **Acceptance criteria**: AC4, AC5, AC6

### Phase 4: Validation (依赖全部)

#### T8: 验证全套交付物

- **Description**: 对全部 7 个文件执行验证：词数检查（SKILL.md ≤500）、无平台特有工具名扫描、所有引用文件存在性、frontmatter 完整性、自我应用测试（skill 是否遵循自己的设计原则）
- **Files**: 无新文件（验证现有文件）
- **Complexity**: small
- **Dependencies**: T7
- **Acceptance criteria**: AC1-AC7 全部

## Test Plan

| Acceptance Criterion | Validation Method |
|---------------------|-------------------|
| AC1: `new` 流程含红线/验收/姿态 | 检查 new-workflow.md 是否包含红线设计步骤、验收标准要求、姿态设定指导 |
| AC2: `boost` 诊断知识层次 | 检查 boost-workflow.md 是否包含三层诊断方法和对应提升方案 |
| AC3: 跨平台可部署 | 检查 platform-adaptation.md 覆盖四平台；SKILL.md 和 workflow 文件无平台绑定 |
| AC4: 自身遵循设计原则 | SKILL.md 有红线节、有验收标准节、用姿态而非角色 |
| AC5: 无平台特有工具名 | grep 扫描全部文件，不含 `Read tool`/`Bash tool`/`read_file`/`run_shell_command` 等特有名称 |
| AC6: SKILL.md ≤500 词 | `wc -w SKILL.md` ≤ 500 |
| AC7: boost 含 context 效率审计 | 检查 boost-workflow.md 包含 token 占用测量和分层下沉建议 |

## Dependency Graph

```
Phase 1 (parallel):  T1  T2  T3  T4
                      │   │   │   │
Phase 2:              ├───┤   │   │
                      ▼   ▼   ▼   │
                      T5 ◄────┘   │
                      │       T6 ◄┘
                      │       │
Phase 3:              └──►T7◄─┘
                          │
Phase 4:                  T8
```
