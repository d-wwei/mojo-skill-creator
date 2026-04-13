---
title: Mojo Skill Creator Requirements
scope: standard
status: approved
created: 2026-04-13
approved_by: user
---

# Mojo Skill Creator — Requirements

## Problem Statement

现有的 skill-creator 绑定 Claude Code 平台（init_skill.py、package_skill.py、插件目录结构），无法为其他 agent 平台创建技能。同时，现有工具擅长"验证技能结构"，但对"怎么设计一个好技能"的内容质量指导偏弱。

**目标**：创建一个平台无关的 Skill Creator 技能，用统一方法论为任意 agent 平台创建和提升高质量技能。

## Sub-commands

- **`new`** — 从零创建新技能
- **`boost`** — 诊断并提升已有技能

## Six Design Dimensions

### 1. Structural Foundation (骨架)

来源：`skill-creator-original.md` (Apache 2.0, Anthropic)

保留：
- 6 步创建流程（理解→规划→初始化→编辑→验证→迭代）
- Progressive disclosure 三层设计
- SKILL.md + YAML frontmatter 格式
- 目录结构约定（scripts/references/assets/）

替换：
- `init_skill.py` / `package_skill.py` → 平台无关的创建指引
- Claude Code 插件目录结构 → 通用路径约定
- Claude Code 特有工具名 → 平台无关语义动词

### 2. Design Philosophy (设计哲学)

来源：ljg-skills 分析

**A. 红线优先设计原则**
设计顺序：红线（不可违反的约束）→ 验收标准 → 流程 → 工具箱。告诉 agent "不能做什么"比"要做什么"有效得多，因为约束可验证、正面指导模糊。

**B. 验收标准前置**
每个 SKILL.md 必须包含可检验的验收标准（3-5 条），从用户视角出发。

**C. 姿态替代角色**
不写"你是一个 XXX 专家"，写认知位置。身份产生模仿，姿态产生认知校准。

**D. 领域反模式库**
按领域分类的反模式清单（写作、视觉、分析、教学），每条可机械检验。

**E. 工作流组合模式**
原子化（一个技能做一件事）+ 管道模式（A→B 串联）+ 并行模式 + 统一获取层。

### 3. Quality Leap Methodology (质量跃迁)

来源：methodology-skill-improvement-via-human-workflow.md

**知识层次诊断**（用于 boost）：
- 原则层：输出正确但泛泛，所有项目看起来像同一模板
- 模式层：识别场景类型并应用对应模式，但缺乏辨识度
- 案例层：输出有明确辨识度，能指出"这里不对"

**案例资产库三级体系**：
- 标杆级（5-10，极深手工打磨）
- 工作级（20-30，深度经过研究）
- 基础级（50+，基本参数正确）

**四维度覆盖**：参数 / 操作指南 / 品质底线 / 直觉校验

**约束逐步收紧**：探索阶段松 → 交付阶段严

**缺陷分层修复**：架构缺陷 → 机械缺陷 → 内容缺陷（顺序不可逆）

**特异性测试**：去掉名字还能猜出是谁 → 才是有效的案例知识

### 4. Cross-Platform Adaptation (跨平台)

目标平台：Claude Code / Codex / Gemini CLI / OpenClaw

**共同基线**：SKILL.md + YAML frontmatter（name, description）

**差异适配**：
- 发现路径（~/.claude/ vs ~/.agents/ vs ~/.gemini/ vs ~/.openclaw/）
- 工具名映射（Read/read_file/原生、Bash/run_shell_command、Skill/activate_skill/skill）
- 能力边界（Gemini 无子 agent、Codex 沙箱限制、OpenClaw 权限模型）

**创建原则**：
- 用平台无关语义描述指令（"读取文件"而非"用 Read tool"）
- 对有能力差异的功能提供 fallback 方案
- 在 skill 内可选包含工具映射表

### 5. Token Efficiency (上下文效率)

**四层 Token 预算架构**：

| Layer | 内容 | Token 预算 | 加载时机 |
|-------|------|-----------|---------|
| 0: Metadata | name + description | ~50-100 | 始终在 context |
| 1: Router | 核心原则压缩版 + 路由 + 指针 | ~300-500 | skill 触发时 |
| 2: Workflow | 具体子命令完整流程 | ~1000-2000 | 按需加载其一 |
| 3: Reference | 反模式库、平台适配、案例等 | 按需片段 | agent 判断需要时 |

**额外手段**：
- Phase-gated loading（多阶段流程每阶段只加载当前指令）
- 平台自适配剪枝（检测平台，跳过无关内容）
- Script 外化计算（决策表写成脚本，返回结果而非注入 context）
- Token budget 声明（reference 指针处标注预估 token 数）

**对两条路径的影响**：
- `new`：强制设计者规划分层预算（"加载后占多少 token？超 2000 要拆层"）
- `boost`：诊断步骤增加 context 效率审计

### 6. Human Observability (人类可观测性) — Optional

**Artifact 输出规范**（可选声明）：
- 任务理解、关键决策、过程记录、质量验证、交付物
- 格式统一为 Markdown
- 输出路径约定 `docs/{skill-name}/`
- 生成是流程的自然副产品，不增加额外工作

**适用判断**：
- 分析/决策类 → 推荐（决策依据可追溯）
- 创作/生成类 → 可选（过程透明有助于迭代）
- 工具/转换类 → 通常不需要

**对两条路径的影响**：
- `new`：设计阶段问"是否需要对人类可审计？"→ 引导设计 artifact 模板
- `boost`：诊断"有可观测输出吗？"→ 复杂技能建议补充

## Future Consideration

**skill-se-kit 集成**（`/Users/admin/Documents/AI/skill self-evolution/skill-se-kit`）作为可选项，待后续迭代评估。

## Acceptance Criteria

1. `new` 流程能引导创建符合跨平台 SKILL.md 标准的技能，含红线、验收标准、姿态设定
2. `boost` 流程能诊断已有技能的知识层次（原则→模式→案例），给出具体提升方案
3. 生成的技能可直接部署到 Claude Code / Codex / Gemini CLI / OpenClaw 任一平台
4. SKILL.md 自身遵循自己定义的设计原则（红线优先、验收前置、约束驱动）
5. 指令中不出现平台特有工具名（用平台无关语义）
6. Mojo Skill Creator 自身 SKILL.md (Layer 1) ≤ 500 词，证明 4 层架构有效
7. `boost` 流程包含 context 效率审计步骤

## Constraints

- 不绑定任何单一 agent 平台特有 API
- 不做 skill 打包分发（各平台自有机制）
- 不做 skill 运行时加载器或 marketplace
- 保留 Apache 2.0 许可证声明（衍生自 Anthropic skill-creator）

## Approach

**Approach B: 主 SKILL.md + 子命令分流到 references**

```
mojo-skill-creator/
├── SKILL.md                          # Layer 1 薄路由（~500 词）
├── references/
│   ├── new-workflow.md               # Layer 2 - new 完整流程
│   ├── boost-workflow.md             # Layer 2 - boost 完整流程
│   ├── design-philosophy.md          # Layer 3 - 设计哲学完整版
│   ├── platform-adaptation.md        # Layer 3 - 四平台适配指南 + 工具映射表
│   ├── anti-patterns-by-domain.md    # Layer 3 - 领域反模式库
│   └── quality-ladder.md             # Layer 3 - 知识层次诊断 + 案例资产库方法论
└── LICENSE                           # Apache 2.0
```
