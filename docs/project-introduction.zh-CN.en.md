# Execution Memory Engine MVP Skill 项目介绍 / Project Introduction

## 1. 项目定位 / Positioning

**中文**

`execution-memory-engine-mvp` 是一个面向 OpenCode 的专业技能包，用于指导 AI Agent 在实现或维护 Execution Memory Engine 类项目时遵守正确的架构边界、测试流程和验证标准。

它不是一个通用“记忆系统”提示词，而是针对 Execution Memory Engine MVP 的工程工作流技能。它帮助 Agent 在代码库中正确区分执行轨迹、提炼后的记忆、决策、失败模式、技能卡和最终给 Planner 使用的 Execution Brief。

**English**

`execution-memory-engine-mvp` is an OpenCode skill package for guiding AI agents while implementing or maintaining Execution Memory Engine style repositories. It encodes architecture boundaries, testing expectations, and verification routines for the MVP.

It is not a generic memory-system prompt. It is a workflow skill for the Execution Memory Engine MVP. It helps an agent keep run traces, distilled memories, decisions, failure patterns, skill cards, and planner-facing Execution Briefs separate.

## 2. 适用场景 / When To Use

**中文**

适合在以下任务中启用：

- 修改 Execution Memory Engine MVP 的 TypeScript/Node.js 实现
- 调试 run trace、Operation、distillation、retrieval、brief generation
- 审查是否错误地把原始 run trace 注入到 Execution Brief
- 增加 Seed Skills 或 Learned Skills
- 验证 Brief 是否保留 dependency cluster
- 运行 MVP 的测试、构建、demo 和 API smoke test

**English**

Use this skill when:

- modifying a TypeScript/Node.js Execution Memory Engine MVP
- debugging run trace, Operation, distillation, retrieval, or brief generation
- reviewing whether raw run trace is incorrectly injected into an Execution Brief
- adding Seed Skills or Learned Skills
- verifying that dependency clusters are preserved in generated briefs
- running MVP tests, builds, demos, and API smoke checks

## 3. 核心设计原则 / Core Design Principles

**中文**

该 skill 强制关注以下设计原则：

1. `run trace` 是原始事实层，不是长期记忆。
2. `memory`、`decision`、`failure_pattern`、`skill` 是经过提炼的经验层对象。
3. `ExecutionBrief` 是给 Planner / Tool Selection 使用的压缩输入，不是 trace dump。
4. 长耗时任务必须通过 `Operation` 建模，不能只依赖同步请求日志。
5. Brief 必须依赖感知组装，不能线性裁剪掉支撑 Decision 或 Failure Pattern。
6. Embedded Profile 要可本地运行，同时通过 Adapter 为 Cloud Profile 留扩展点。

**English**

The skill emphasizes these principles:

1. `run trace` is raw evidence, not long-term memory.
2. `memory`, `decision`, `failure_pattern`, and `skill` are distilled experience objects.
3. `ExecutionBrief` is compressed input for Planner / Tool Selection, not a trace dump.
4. Long-running tasks must be modeled with `Operation`, not only synchronous logs.
5. Brief generation must be dependency-aware and must not linearly truncate supporting decisions or failure patterns.
6. Embedded Profile should run locally, while adapter boundaries preserve Cloud Profile extensibility.

## 4. Skill 内容 / What The Skill Contains

**中文**

安装后的 skill 文件位于：

```text
skills/execution-memory-engine-mvp/SKILL.md
```

它包含：

- 架构边界提醒
- 必须运行的验证命令
- 典型源码文件映射
- 设计规则
- 修改代码时的测试优先流程

**English**

The installable skill file is:

```text
skills/execution-memory-engine-mvp/SKILL.md
```

It contains:

- architecture boundary reminders
- required verification commands
- typical source file map
- design rules
- test-first change workflow

## 5. 安装方式 / Installation

### 5.1 项目级安装 / Project-local Installation

**中文**

项目级安装会把 skill 复制到目标项目的 `.opencode/skills/` 目录。只有该项目会自动发现这个 skill。

**English**

Project-local installation copies the skill into the target project's `.opencode/skills/` directory. Only that project will discover the skill automatically.

```powershell
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
.\scripts\install.ps1 -Scope project -ProjectPath "D:\path\to\your\project"
```

验证 / Verify:

```powershell
cd "D:\path\to\your\project"
opencode debug skill | Select-String "execution-memory-engine-mvp"
```

### 5.2 全局安装 / Global Installation

**中文**

全局安装会把 skill 复制到当前用户的 OpenCode 配置目录，所有项目都可以发现。

**English**

Global installation copies the skill into the current user's OpenCode config directory, making it available to all projects.

```powershell
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
.\scripts\install.ps1 -Scope global
```

验证 / Verify:

```powershell
opencode debug skill | Select-String "execution-memory-engine-mvp"
```

### 5.3 macOS / Linux

```bash
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
chmod +x scripts/install.sh
./scripts/install.sh project /path/to/your/project
# or
./scripts/install.sh global
```

## 6. 使用方式 / Usage

**中文**

在目标项目中运行：

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-mvp skill. Tell me the verification commands for this repository, but do not modify files."
```

如果 skill 正常生效，OpenCode 输出中通常会出现：

```text
→ Skill "execution-memory-engine-mvp"
```

并返回类似：

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

**English**

Run this inside the target project:

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-mvp skill. Tell me the verification commands for this repository, but do not modify files."
```

When the skill is active, OpenCode usually prints:

```text
→ Skill "execution-memory-engine-mvp"
```

and returns commands such as:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

## 7. 验证策略 / Verification Strategy

**中文**

该 skill 要求 Agent 在完成代码修改后运行：

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

对于 API：

```powershell
$job = Start-Job -ScriptBlock { Set-Location (Get-Location); $env:PORT='3212'; node --disable-warning=ExperimentalWarning --experimental-strip-types src/api/server.ts }
try {
  Start-Sleep -Seconds 3
  Invoke-RestMethod -Uri 'http://127.0.0.1:3212/health'
} finally {
  Stop-Job $job -ErrorAction SilentlyContinue
  Remove-Job $job -Force -ErrorAction SilentlyContinue
}
```

**English**

The skill expects agents to run:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

For API smoke testing:

```powershell
$job = Start-Job -ScriptBlock { Set-Location (Get-Location); $env:PORT='3212'; node --disable-warning=ExperimentalWarning --experimental-strip-types src/api/server.ts }
try {
  Start-Sleep -Seconds 3
  Invoke-RestMethod -Uri 'http://127.0.0.1:3212/health'
} finally {
  Stop-Job $job -ErrorAction SilentlyContinue
  Remove-Job $job -Force -ErrorAction SilentlyContinue
}
```

## 8. 与 Execution Memory Engine MVP 的关系 / Relationship To The MVP

**中文**

这个仓库只发布 OpenCode skill，不包含完整 Execution Memory Engine MVP 实现。完整 MVP 项目可以使用该 skill 来指导开发、调试、测试和审查。

**English**

This repository publishes only the OpenCode skill. It does not contain the full Execution Memory Engine MVP implementation. A full MVP repository can use this skill to guide development, debugging, testing, and review.

## 9. 后续扩展 / Future Extensions

**中文**

后续可以加入：

- 更细的 Cloud Profile adapter 检查清单
- sqlite-vec / pgvector 替换指南
- Brief cluster packing 专项测试提示
- OpenCode 自动安装插件封装

**English**

Possible future additions:

- deeper Cloud Profile adapter checklist
- sqlite-vec / pgvector replacement guide
- dedicated Brief cluster packing test prompts
- OpenCode plugin-based auto-install packaging
