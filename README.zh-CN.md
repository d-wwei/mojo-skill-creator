<!-- Synced with README.md as of 2026-04-13 -->

[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

一个给 AI Agent 用的技能，用来创建和升级其他技能。支持 Claude Code、Codex、Gemini CLI 和 OpenClaw。

## 是什么

Mojo Skill Creator 本身是一个 AI Agent 技能（一个 SKILL.md + 8 个 reference 文件）。装上之后，你的 Agent 多了两个能力：

- **`new`** — 走 9 步流程，从零创建一个技能
- **`boost`** — 从 6 个维度诊断一个已有技能，然后升级

产出是一个自包含的技能包（SKILL.md + references），可以分发给别人，在四个支持的平台上 symlink 安装即用。

## 解决什么问题

写一个 SKILL.md 很容易。写一个产出真正好的 SKILL.md 不容易。

典型的失败模式：技能通过了所有结构检查——frontmatter 对、目录规范、触发短语准确——但产出平庸。两个不同任务跑出两组词，套在同一副骨架上。技能结构正确，实际效果泛泛。

问题出在：大多数技能是从作者的直觉或抽象的最佳实践出发设计的，没有研究过领域专家实际怎么做。一个写作技能如果不编码专业作者的工作方式，产出就是 AI 味的文章。一个设计技能如果跳过顶级设计团队的真实流程，产出就是安全但平庸的布局。

Mojo 用一个具体的结构性选择解决这个问题：**在设计任何红线或工作流步骤之前，先研究目标领域最好的从业者实际怎么做**——他们的真实工作流、质量标准和不可妥协的底线。专家的工作流成为技能的工作流，专家的标准成为技能的红线。这是"从通用积木拼装的技能"和"用领域专业知识灌注的技能"之间的差别。

方法论之外，它还处理了让技能在实际中可用的工程问题：
- **跨平台** — 不用平台特有工具名，四个 Agent 平台都能跑
- **Token 高效** — 四层架构，每次只加载一个工作流
- **分发就绪** — 自包含的包，终端用户 symlink 即用，不需要任何配置

## `new` 怎么工作

9 步，按顺序：

1. **理解使用场景** — 收集 3-5 个具体的使用示例，包括失败场景
2. **研究领域最佳实践** — 研究这个技能要自动化的那件事，世界上最好的人是怎么做的。找到他们真实的工作流、质量标准和原则。做跨学科扫描。然后综合重构：重新思考工作流、原理和质量标准
3. **设计红线和验收标准** — 定义 5-10 条不可违反的约束（来源于第 2 步发现的专家标准）和 3-5 条可测试的验收标准，在写任何内容之前
4. **规划 Token 架构** — 设计四层结构（元数据 → 路由 → 工作流 → 参考资料），每层分配词数预算
5. **规划可复用资源** — 确定 scripts/、references/、assets/ 里放什么
6. **构建技能** — 写 SKILL.md、工作流 reference、深度 reference
7. **人类可审计**（可选）— 添加 artifact 输出，让执行过程可追溯
7b. **自进化集成**（可选）— 打包 skill-se-kit 实现运行时学习
8. **跨平台验证** — 检查有没有平台特有工具名、所有引用文件是否存在、词数是否在预算内
9. **迭代** — 观察首次使用，收紧红线、澄清工作流、压缩 Token 占用高的部分

第 2 步是最重要的。详细的研究和综合流程在 `references/domain-research-guide.md`。

## `boost` 怎么工作

4 个阶段：

**Phase 1 — 诊断**（8 项检查）：
1. 结构审计（frontmatter、红线、验收标准、姿态）
2. 知识层级诊断（原则层 → 模式层 → 案例层）
3. 上下文效率审计（词数、始终加载的总成本）
4. 人类可审计性审计
5. 跨平台兼容检查
6. 自进化审计
7. 领域最佳实践研究（对比技能当前工作流 vs 专家工作流）
8. 研究综合（判断：是修补还是重构？）

**Phase 2 — 处方**：架构修复 → 机械修复 → 内容升级，严格按序。如果研究综合发现工作流存在结构性差距，处方从工作流重构开始。

**Phase 3 — 执行**：按序修复，每类修完后验证。

**Phase 4 — 报告**：人类可审计的升级总结，含前后对比指标。

## 设计决策

这些是嵌入在工具中的选择，以及为什么这样选：

**先做领域研究再做设计。** `new` 的第 2 步和 `boost` 的 Phase 1.7 要求研究最好的从业者实际怎么做。红线来自专家的质量标准，不是抽象原则。技能的工作流镜像专家的工作流，不是通用模板。这基于真实的改进案例：研究 Apple、Linear、Stripe、Airbnb 的设计实践后，一个技能的特异性测试通过率从 ~20% 升到 ~85%。

**约束先于流程。** 受 [ljg-skills](https://github.com/lijigang/ljg-skills) 影响 — 14 个先定义「不能产出什么」再定义「应该产出什么」的技能。「每句话不得包含超过一个从句」可检验；「写得清楚一点」不可检验。

**姿态替代角色。** 技能定义认知位置（「不教课，不演讲——先亮弯路，再给方向」）而非身份（「你是专家」）。行为更精确。

**知识层级诊断。** 来自真实的技能改进实践。原则层（泛泛）的技能需要的升级方式和模式层（有场景感知）、案例层（有辨识度）完全不同。先诊断，再针对性干预。

**四层 Token 架构。** SKILL.md 是薄路由（≤500 词）。工作流在 references 里（每个 ≤2000 词）。深度材料按需加载。每次调用只加载一个工作流。本技能自身的 SKILL.md 是 499 词。

**分发优先。** 产出的每个技能都自包含。不假设终端用户全局安装了任何东西。Symlink 即用。

## 可选：自进化

技能可以打包 [skill-se-kit](https://github.com/d-wwei/skill-se-kit)（~48KB）实现运行时学习。每次任务完成后，子 Agent 提取反馈并更新技能库。se-kit 打包在技能内部——终端用户不需要额外安装。作者通过 `boost` 更新打包的副本。

## 安装

```bash
git clone https://github.com/d-wwei/mojo-skill-creator.git
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Codex/Gemini: ln -sf ... ~/.agents/skills/mojo-skill-creator
```

对 Agent 说「创建一个新技能」或「升级这个技能」。

## 支持平台

| 平台 | Skill 路径 |
|------|-----------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| OpenClaw | `~/.openclaw/skills/` |

生成的技能中的指令使用语义化动词（如「读取文件」），不用平台特有工具名。

## 项目结构

```
mojo-skill-creator/
├── SKILL.md                          # 路由（499 词）
├── references/
│   ├── new-workflow.md               # 9 步创建流程
│   ├── boost-workflow.md             # 4 阶段诊断升级
│   ├── domain-research-guide.md      # 如何研究专家工作流
│   ├── design-philosophy.md          # 6 条设计原则 + 示例
│   ├── platform-adaptation.md        # 4 平台工具映射
│   ├── anti-patterns-by-domain.md    # 反模式清单：写作/视觉/分析/教学
│   ├── quality-ladder.md             # 知识层级诊断方法
│   └── se-kit-integration.md         # 可选自进化打包指南
└── LICENSE-apache2.0
```

## 来源

- **[ljg-skills](https://github.com/lijigang/ljg-skills)** — 约束驱动设计、姿态替代角色、领域反模式库
- **人类工作流方法论** — 知识层级诊断、案例资产库、约束收紧梯度。来自 66 品牌设计系统改进项目
- **[Anthropic skill-creator](https://github.com/anthropics/claude-code)**（Apache 2.0）— 渐进式披露、SKILL.md 格式规范

## 许可证

Apache 2.0。详见 [LICENSE-apache2.0](LICENSE-apache2.0)。
