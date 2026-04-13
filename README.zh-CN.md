# Mojo Skill Creator

跨平台 AI Agent 技能创建与升级工具。一个工具，适配所有 Agent。

## 做什么

**`new`** — 从零创建技能。内置质量控制：红线约束、验收标准、Token 预算规划、跨平台验证。

**`boost`** — 诊断已有技能的质量层级（原则层 → 模式层 → 案例层），然后针对性升级。

两条路径都产出自包含的技能包，终端用户拿到即用，零配置。

## 支持平台

创建的技能可在所有支持 SKILL.md 格式的 Agent 上运行：

| 平台 | 发现路径 |
|------|---------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| OpenClaw | `~/.openclaw/skills/` |

生成的技能中不会出现任何平台特有的工具名 — 指令使用语义化动词，任何 Agent 都能理解。

## 设计原则

1. **分发优先** — 技能包自包含，终端用户无需全局安装或环境配置
2. **约束先于指导** — 先定义红线（不能做什么），再定义流程（应该做什么）。每条约束可机械检验
3. **验收标准前置** — 在写任何内容之前，先定义 3-5 条可测试的质量标准
4. **姿态替代角色** — 技能定义认知位置（"用约束思考，不用指令思考"），而非身份（"你是专家"）
5. **原子化 + 可组合** — 一个技能做一件事，复杂任务通过组合实现
6. **四层 Token 架构** — 元数据(~100词) → 路由(≤500词) → 工作流(≤2000词) → 参考资料(按需加载)，最小化上下文窗口占用

## 四层 Token 架构

大多数技能把所有内容塞进一个文件。Mojo 强制分层加载：

```
Layer 0: 元数据      ~100 词     始终在上下文中（触发匹配）
Layer 1: 路由        ≤500 词     技能激活时加载
Layer 2: 工作流      ≤2000 词    每次调用只加载一个子命令
Layer 3: 参考资料     按需        仅在需要时加载深度材料
```

这个技能自身就是活示范 — SKILL.md 只有 475 词。

## 可选：自进化

技能可以选择性地打包 [skill-se-kit](https://github.com/d-wwei/skill-se-kit)（~48KB）实现运行时学习。每次任务完成后，子 Agent 提取反馈并更新技能库。技能越用越好。

- 终端用户零配置 — se-kit 打包在技能内部
- 子 Agent 隔离 — 自进化在独立上下文中运行，不影响主技能的 Token 占用
- 升级路径 — 技能作者通过 `boost` 更新打包的 se-kit，然后重新分发

## 项目结构

```
mojo-skill-creator/
├── SKILL.md                              # Layer 1 路由（475 词）
├── references/
│   ├── new-workflow.md                   # 8 步创建流程
│   ├── boost-workflow.md                 # 4 阶段诊断升级
│   ├── design-philosophy.md              # 6 条设计原则
│   ├── platform-adaptation.md            # 4 平台工具映射
│   ├── anti-patterns-by-domain.md        # 领域反模式清单
│   ├── quality-ladder.md                 # 知识层级诊断
│   └── se-kit-integration.md             # 可选自进化指南
├── docs/                                 # 过程文档（需求/计划/评审/复盘）
└── LICENSE-apache2.0
```

## 安装

将技能 symlink 到你的 Agent 发现路径：

```bash
# Claude Code
ln -sf /path/to/mojo-skill-creator ~/.claude/skills/mojo-skill-creator

# Codex / Gemini CLI
ln -sf /path/to/mojo-skill-creator ~/.agents/skills/mojo-skill-creator
```

然后对 Agent 说："创建一个新技能" 或 "升级这个技能" — 技能会自动激活。

## 方法论来源

本工具融合了三套经过验证的方法论：

- **结构基础** — 衍生自 Anthropic 的 [skill-creator](https://github.com/anthropics/claude-code)（Apache 2.0）。六步创建流程、渐进式披露、SKILL.md 规范。
- **设计哲学** — 提取自 [ljg-skills](https://github.com/lijigang/ljg-skills) 分析。约束驱动设计、姿态替代角色、验收标准前置、领域反模式库。
- **质量方法论** — 来自真实技能改进实践。知识层级诊断（原则→模式→案例）、案例资产库、约束收紧梯度、缺陷分层修复。

## 许可证

Apache 2.0 — 衍生自 Anthropic skill-creator。详见 [LICENSE-apache2.0](LICENSE-apache2.0)。
