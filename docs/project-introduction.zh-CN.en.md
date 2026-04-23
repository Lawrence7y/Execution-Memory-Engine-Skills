# Execution Memory Engine Skills 项目介绍 / Project Introduction

## 1. 项目定位 / Positioning

**中文**

`Execution Memory Engine Skills` 是一个面向全部大模型和 AI Agent 的技能包。它不是 OpenCode 专属项目，也不是某一个命令行工具的插件。它的核心价值是把 Execution Memory Engine 的架构纪律、测试纪律和实现边界沉淀成一个可复用的 `SKILL.md`，让不同模型在参与相关项目时能更快进入正确工作方式。

**English**

`Execution Memory Engine Skills` is a model-agnostic skill package for large language models and AI agents. It is not an OpenCode-only project and not a plugin for a single CLI. Its value is to encode the architecture discipline, testing discipline, and implementation boundaries of Execution Memory Engine systems into a reusable `SKILL.md`.

## 2. 为什么需要这个 Skills 包 / Why This Skills Package Exists

**中文**

Execution Memory Engine 的关键难点不在于保存数据，而在于保持概念边界：

- 执行轨迹是证据，不是长期记忆。
- 记忆是提炼后的经验，不是聊天流水。
- Brief 是给 Planner 的压缩输入，不是检索列表。
- Operation 是长耗时任务的生命周期模型，不是普通日志字段。
- Skill 是稳定工作流经验，不是一次性总结。

如果模型忽略这些边界，最终系统会退化成“把历史记录塞回上下文”的简单方案，丢失可复用性、可观测性和 token 效率。

**English**

The hard part of an Execution Memory Engine is not storing data. The hard part is preserving conceptual boundaries:

- run traces are evidence, not long-term memory
- memories are distilled experience, not chat transcripts
- briefs are compressed planner input, not retrieval dumps
- operations model long-running task lifecycles, not ordinary log fields
- skills capture stable workflows, not one-off summaries

When a model ignores these boundaries, the system degrades into a simple "stuff history back into context" mechanism and loses reusability, observability, and token efficiency.

## 3. 支持的模型与工具 / Supported Models And Tools

**中文**

该 skill 可以用于：

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE Agent
- 自研 Agent Runtime
- 任意支持读取 Markdown 指令的大模型工具

**English**

This skill can be used with:

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE agents
- custom agent runtimes
- any LLM tool that can read Markdown instructions

## 4. Skill 文件 / Skill File

The installable skill is:

```text
skills/execution-memory-engine-skills/SKILL.md
```

It contains:

- source-of-truth rules
- architecture boundaries
- MVP loop requirements
- verification routine
- typical implementation map
- design rules
- change workflow

## 5. 安装方式 / Installation

### Codex

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target codex
```

### OpenCode

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target opencode
```

### Claude Code

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target claude
```

### Generic Project Install

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target project -ProjectPath "D:\path\to\your\project"
```

Then ask the model to read:

```text
D:\path\to\your\project\.skills\execution-memory-engine-skills\SKILL.md
```

## 6. 使用方式 / Usage

**中文**

如果工具支持 skill 自动发现：

```text
Use the execution-memory-engine-skills skill.
```

如果工具不支持自动发现：

```text
Read the file .skills/execution-memory-engine-skills/SKILL.md and follow it for this task.
```

**English**

If your tool supports skill discovery:

```text
Use the execution-memory-engine-skills skill.
```

If it does not:

```text
Read the file .skills/execution-memory-engine-skills/SKILL.md and follow it for this task.
```

## 7. 验证方式 / Verification

For a TypeScript + Node.js Execution Memory Engine MVP, the skill expects:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

For an API smoke test:

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

## 8. 推荐实现边界 / Recommended Implementation Boundaries

**中文**

模型在实现项目时应保留这些边界：

- `ExecutionMemoryStore`
- `VectorIndexAdapter`
- `QueueAdapter`
- `ArtifactStoreAdapter`
- `RunTraceLogger`
- `OperationManager`
- `ExperienceDistiller`
- `RetrievalEngine`
- `BriefGenerator`
- `SkillBuilder`

**English**

When implementing a project, the model should preserve these boundaries:

- `ExecutionMemoryStore`
- `VectorIndexAdapter`
- `QueueAdapter`
- `ArtifactStoreAdapter`
- `RunTraceLogger`
- `OperationManager`
- `ExperienceDistiller`
- `RetrievalEngine`
- `BriefGenerator`
- `SkillBuilder`

## 9. 后续扩展 / Future Extensions

**中文**

后续可以加入：

- 多个子 skill，例如 architecture、distillation、retrieval、brief-packing
- 针对 Codex / Claude / OpenCode / Gemini 的安装元数据
- sqlite-vec / pgvector 替换指南
- Cloud Profile adapter checklist
- 更完整的 example prompts

**English**

Future extensions may include:

- multiple sub-skills such as architecture, distillation, retrieval, and brief-packing
- installation metadata for Codex / Claude / OpenCode / Gemini
- sqlite-vec / pgvector replacement guide
- Cloud Profile adapter checklist
- richer example prompts
