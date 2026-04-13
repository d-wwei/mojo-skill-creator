<!-- Synced with README.md as of 2026-04-13 -->

[English](README.md) | [中文](README.zh-CN.md)

# Mojo Skill Creator

造不浪费 Token 的技能，造不挑平台的技能，造别人拿到就能用的技能。

## 为什么做这个

我们装了 100 多个 Skill，横跨 Claude Code、Codex、Gemini CLI。大部分有同一个毛病：只在作者的机器上能跑。

有的假设你全局装了某个 Python 包。有的用了 Claude Code 独有的工具名，搬到 Codex 上直接报错。还有几个一加载就往 context 里灌 4000 词，不管你这次只用到其中 10% 还是全部。

现有的 Skill Creator（Anthropic 内置的、superpowers 插件里的）擅长验结构——frontmatter 格式对不对、目录规范不规范。但它们不帮你**设计**一个好 Skill。什么是好 Skill？有质量红线的、跨四个平台能跑的、不把 Agent 的 context 窗口吃掉一半的。

没有现成工具做这件事，就自己造了一个。

## 做什么

两个命令。一个造新的，一个升级旧的。

**`new`** 走 8 步流程：理解使用场景、在写任何内容之前先设计红线和验收标准、规划 Token 预算、构建 Skill、可选加入自进化和人类可审计能力、跨平台验证、迭代。

**`boost`** 从四个维度诊断现有 Skill——结构质量、知识深度、Token 效率、跨平台兼容——然后按严格顺序开处方：先修架构、再修机械问题、最后改内容。

两条路径都产出自包含的包。拿到你 Skill 的人，symlink 一下就能用。不需要看说明书，不需要跑 setup。

## 怎么做到的

核心思路：SKILL.md 不应该装所有东西，它只负责路由到正确的工作流。

```
Layer 0: 元数据      ~100 词     始终在 context 里（name + description，用于触发匹配）
Layer 1: 路由        ≤500 词     Skill 激活时加载——原则、红线、指针
Layer 2: 工作流      ≤2000 词    每次只加载一个子命令的流程
Layer 3: 参考资料     按需        Agent 确实需要时才拉取深度材料
```

这个 Skill 自己就是证明。SKILL.md 475 词。路由到 7 个 reference 文件，总计约 7,500 词。但跑 `new` 时 Agent 只加载 ~2,000 词。跑 `boost` 时加载另一组 ~2,000 词。剩下的 5,500 词从不进入 context，除非被明确请求。

**文件结构：**

```
mojo-skill-creator/
├── SKILL.md                          # 475 词路由
├── references/
│   ├── new-workflow.md               # 8 步创建流程（`new` 时加载）
│   ├── boost-workflow.md             # 4 阶段诊断（`boost` 时加载）
│   ├── design-philosophy.md          # 6 条设计原则——设计时加载
│   ├── platform-adaptation.md        # 4 平台工具映射
│   ├── anti-patterns-by-domain.md    # 按领域分类的反模式清单
│   ├── quality-ladder.md             # 知识层级诊断方法
│   └── se-kit-integration.md         # 可选自进化打包指南
└── LICENSE-apache2.0
```

## 和现有工具的区别

**和 Anthropic skill-creator 比：** 那个工具验结构（frontmatter 对不对、目录规不规范）。这个教设计——先写红线再写流程、用认知姿态不用角色标签、在写内容之前先规划 Token 预算。结构验证是基本功，设计方法论才是缺的。

**和「自己写一个好 SKILL.md」比：** 通过 Mojo 创建的每个 Skill 都自带可机械检验的约束。「验收标准不能依赖主观判断」不是建议——是红线，有具体测试方法：两个独立评审必须对通过/不通过达成一致。如果他们会争论，说明标准太模糊。

**和单平台工具比：** 指令用语义化动词（「读取文件」「搜索代码库」），不用平台工具名（`Read`、`read_file`、`grep_search`）。一个 Skill，四个平台，零适配。

## 6 条设计原则

| # | 原则 | 一句话 |
|---|------|--------|
| 1 | **分发优先** | 终端用户的机器上什么都没装，为这个场景设计 |
| 2 | **约束先于指导** | 告诉 Agent 不能做什么。约束可检验，愿景不行 |
| 3 | **验收标准前置** | 在写任何内容之前先定义「做完了」是什么样子 |
| 4 | **姿态替代角色** | 「用约束思考，不用指令思考」比「你是资深 Skill 架构师」精确一个量级 |
| 5 | **原子化 + 可组合** | 一个 Skill 做一件事。复杂 = 组合 |
| 6 | **四层 Token 架构** | 只加载需要的，在需要的时候加载 |

## 可选：自进化

Skill 可以打包 [skill-se-kit](https://github.com/d-wwei/skill-se-kit)（~48KB）实现运行时学习。每次任务完成后，子 Agent 提取反馈并更新技能库——越用越好。

se-kit 打包在 Skill 内部。终端用户不需要额外安装任何东西。se-kit 出新版本时，Skill 作者跑一次 `boost`，更新打包的副本，重新分发。用户永远不需要管依赖。

## 快速开始

```bash
# 1. Clone
git clone https://github.com/d-wwei/mojo-skill-creator.git

# 2. Symlink 到你的 Agent
ln -sf "$(pwd)/mojo-skill-creator" ~/.claude/skills/mojo-skill-creator
# Codex/Gemini 用户: ln -sf ... ~/.agents/skills/mojo-skill-creator

# 3. 开始用
# 对 Agent 说：「创建一个新技能」或「升级这个技能」
# Mojo 会根据 description 中的触发短语自动激活。
```

## 支持平台

| 平台 | Skill 路径 | 项目级指令 |
|------|-----------|-----------|
| Claude Code | `~/.claude/skills/` | `CLAUDE.md` |
| Codex | `~/.agents/skills/` | `AGENTS.md` |
| Gemini CLI | `~/.gemini/skills/` | `GEMINI.md` |
| OpenClaw | `~/.openclaw/skills/` | — |

## 方法论来源

三套方法论，取长补短：

- **Anthropic skill-creator**（Apache 2.0）— 六步创建流程、渐进式披露、SKILL.md 格式规范。
- **ljg-skills 分析** — 约束驱动设计、姿态替代角色、验收前置、领域反模式库。来自对 [14 个 Skill](https://github.com/lijigang/ljg-skills) 的深度解剖，这些 Skill 的特点是锁死下限而非追求上限。
- **人类工作流方法论** — 知识层级诊断（原则→模式→案例）、案例资产库、约束收紧梯度、缺陷分层修复。提取自一个 66 品牌设计系统的真实改进实践。

## 许可证

Apache 2.0 — 衍生自 Anthropic skill-creator。详见 [LICENSE-apache2.0](LICENSE-apache2.0)。
