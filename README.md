# Execution Memory Engine Skills

> 面向全部大模型与 AI 编程代理的 Execution Memory Engine 技能包  
> Model-agnostic skills for large language models and AI coding agents working on Execution Memory Engine systems

## 1. 项目简介 / Project Overview

**中文**

`Execution Memory Engine Skills` 是一组面向大模型、AI Agent、IDE Agent、CLI 编程助手和自动化工程代理的可复用技能说明。它用于指导模型在设计、实现、测试和审查 Execution Memory Engine 系统时遵守稳定的架构边界。

Execution Memory Engine 的核心目标不是“保存更多聊天记录”，而是把 Agent 的执行轨迹提炼成可检索、可压缩、可复用的执行经验层。这个 Skills 包把这套工作方式沉淀为一个可安装、可复制、可直接喂给模型读取的 `SKILL.md`。

**English**

`Execution Memory Engine Skills` is a reusable skill package for large language models, AI agents, IDE agents, CLI coding assistants, and automated engineering agents. It guides models when designing, implementing, testing, and reviewing Execution Memory Engine systems.

The goal of an Execution Memory Engine is not to store more chat history. It is to distill agent execution traces into a searchable, compressible, and reusable execution experience layer. This repository packages that workflow as an installable and model-readable `SKILL.md`.

## 2. 它不是什么 / What This Is Not

**中文**

这不是 OpenCode 专属项目，也不是某一个 CLI 的插件。OpenCode 只是支持的安装目标之一。

这个仓库也不是完整的 Execution Memory Engine 服务端实现。它发布的是面向大模型的技能说明，用来指导模型在不同代码库中实现或维护 Execution Memory Engine。

**English**

This is not an OpenCode-only project and not a plugin for a single CLI. OpenCode is only one supported installation target.

This repository is also not the full Execution Memory Engine service implementation. It publishes model-facing skill instructions that help agents implement or maintain Execution Memory Engine systems in different repositories.

## 3. 适用对象 / Intended Users

**中文**

适用于：

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE Agent
- 自研 Agent Runtime
- 任意可以读取 `SKILL.md` 的大模型工作流

**English**

Suitable for:

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE agents
- custom agent runtimes
- any LLM workflow that can read a `SKILL.md` file

## 4. Skill 解决的问题 / Problems Solved By The Skill

**中文**

该 skill 帮助模型避免以下常见错误：

- 把原始 `run trace` 当成长期记忆直接注入模型
- 混淆 `memory`、`decision`、`failure_pattern`、`skill` 和 `brief`
- 用线性截断生成 Brief，导致支撑 Decision 或 Failure Pattern 被裁掉
- 用同步日志代替长耗时任务的 `Operation` 生命周期模型
- 忘记区分 Seed Skills 与 Learned Skills
- 在实现中绕过 Adapter，导致 Embedded / Cloud 双部署形态难以扩展
- 修改代码后没有运行测试、构建和 demo

**English**

The skill helps models avoid common mistakes:

- injecting raw `run trace` as long-term memory
- mixing up `memory`, `decision`, `failure_pattern`, `skill`, and `brief`
- generating briefs with linear truncation that drops supporting decisions or failure patterns
- replacing the long-running `Operation` lifecycle with synchronous logs
- failing to distinguish Seed Skills from Learned Skills
- bypassing adapters and making Embedded / Cloud profiles hard to extend
- changing code without running tests, build, and demo verification

## 5. 核心架构原则 / Core Architecture Principles

**中文**

Execution Memory Engine Skills 强调以下原则：

1. `run trace` 是原始事实层。
2. `memory` 是提炼后的经验层。
3. `decision` 表示可复用架构或实现决策。
4. `failure_pattern` 表示可复用失败模式和规避方式。
5. `skill` 表示可被再次触发的工作流经验。
6. `ExecutionBrief` 是给 Planner / Tool Selection 的低 token、高密度输入。
7. `Operation` 必须显式建模长耗时任务。
8. Brief 生成必须做依赖闭包和 cluster packing。
9. Embedded Profile 与 Cloud Profile 要通过 Adapter 隔离。

**English**

Execution Memory Engine Skills emphasizes:

1. `run trace` is raw evidence.
2. `memory` is distilled experience.
3. `decision` captures reusable architecture or implementation decisions.
4. `failure_pattern` captures reusable failure modes and mitigation paths.
5. `skill` captures reusable workflows.
6. `ExecutionBrief` is low-token, high-density input for Planner / Tool Selection.
7. `Operation` must explicitly model long-running work.
8. Brief generation must use dependency closure and cluster packing.
9. Embedded and Cloud profiles must be isolated through adapters.

## 6. 仓库结构 / Repository Layout

```text
skills/
  execution-memory-engine-skills/
    SKILL.md                       # model-agnostic skill file
scripts/
  install.ps1                      # Windows installer for Codex/OpenCode/Claude/project/custom
  install.sh                       # macOS/Linux installer
docs/
  project-introduction.zh-CN.en.md # detailed bilingual introduction
README.md                         # this bilingual guide
```

## 7. 安装方式 / Installation

### 7.1 Codex

**Windows PowerShell**

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target codex
```

**macOS / Linux**

```bash
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
chmod +x scripts/install.sh
./scripts/install.sh codex
```

### 7.2 OpenCode

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target opencode
```

Verify:

```powershell
opencode debug skill | Select-String "execution-memory-engine-skills"
```

### 7.3 Claude Code

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target claude
```

### 7.4 Project-local Generic Install / 项目级通用安装

**中文**

如果你的工具没有固定的全局 skills 目录，可以把 skill 安装到项目的 `.skills` 目录，然后在提示词中要求模型读取该文件。

**English**

If your tool has no fixed global skills directory, install into the project's `.skills` directory and ask the model to read the file.

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target project -ProjectPath "D:\path\to\your\project"
```

Then point the model to:

```text
D:\path\to\your\project\.skills\execution-memory-engine-skills\SKILL.md
```

### 7.5 Custom Skills Directory / 自定义目录安装

```powershell
.\scripts\install.ps1 -Target custom -CustomSkillsPath "D:\my-skills"
```

```bash
./scripts/install.sh custom "$(pwd)" /path/to/my-skills
```

## 8. 如何使用 / How To Use

**中文**

在支持 skills 的工具里，直接要求模型使用：

```text
Use the execution-memory-engine-skills skill.
```

对于不支持自动发现 skills 的工具，把 `SKILL.md` 路径贴给模型：

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

**English**

In tools that support skills, ask the model:

```text
Use the execution-memory-engine-skills skill.
```

For tools without automatic skill discovery, point the model at the file:

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

## 9. 快速测试 / Quick Test

**Codex / Generic**

Ask:

```text
Use the execution-memory-engine-skills skill. Tell me the required verification routine for a TypeScript Execution Memory Engine MVP. Do not modify files.
```

Expected answer should include:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

**OpenCode**

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-skills skill. Tell me the verification routine, but do not modify files."
```

## 10. 典型目标代码结构 / Typical Target Code Structure

The skill expects or recommends this kind of implementation map:

```text
src/domain/models.ts
src/domain/scoring.ts
src/application/ports/
src/application/engine.ts
src/application/services/run-trace-logger.ts
src/application/services/operation-manager.ts
src/application/services/experience-distiller.ts
src/application/services/retrieval-engine.ts
src/application/services/brief-generator.ts
src/infrastructure/embedded/embedded-store.ts
src/infrastructure/embedded/seed-skill-loader.ts
examples/demo.ts
```

## 11. 详细文档 / Detailed Documentation

See:

- [docs/project-introduction.zh-CN.en.md](docs/project-introduction.zh-CN.en.md)

## 12. License / 许可证

No license has been added yet. Add one before using this repository in a public package ecosystem or commercial distribution.
