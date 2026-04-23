<p align="right">
  <a href="./README.md"><img src="https://img.shields.io/badge/语言-中文-lightgrey" alt="中文"></a>
  <a href="./README.en.md"><img src="https://img.shields.io/badge/Language-English-blue" alt="English"></a>
</p>

# Execution Memory Engine Skills

Model-agnostic skills for large language models and AI coding agents working on Execution Memory Engine systems.

## Project Overview

`Execution Memory Engine Skills` is a reusable skill package for large language models, AI agents, IDE agents, CLI coding assistants, and automated engineering agents. It guides models when designing, implementing, testing, and reviewing Execution Memory Engine systems.

The goal of an Execution Memory Engine is not to store more chat history. It is to distill agent execution traces into a searchable, compressible, and reusable execution experience layer. This repository packages that workflow as an installable and model-readable `SKILL.md`.

## What This Is Not

This is not an OpenCode-only project and not a plugin for a single CLI. OpenCode is only one supported installation target.

This repository is also not the full Execution Memory Engine service implementation. It publishes model-facing skill instructions that help agents implement or maintain Execution Memory Engine systems in different repositories.

## Intended Users

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE agents
- custom agent runtimes
- any LLM workflow that can read a `SKILL.md` file

## Problems Solved By The Skill

The skill helps models avoid common mistakes:

- injecting raw `run trace` as long-term memory
- mixing up `memory`, `decision`, `failure_pattern`, `skill`, and `brief`
- generating briefs with linear truncation that drops supporting decisions or failure patterns
- replacing the long-running `Operation` lifecycle with synchronous logs
- failing to distinguish Seed Skills from Learned Skills
- bypassing adapters and making Embedded / Cloud profiles hard to extend
- changing code without running tests, build, and demo verification

## Core Architecture Principles

1. `run trace` is raw evidence.
2. `memory` is distilled experience.
3. `decision` captures reusable architecture or implementation decisions.
4. `failure_pattern` captures reusable failure modes and mitigation paths.
5. `skill` captures reusable workflows.
6. `ExecutionBrief` is low-token, high-density input for Planner / Tool Selection.
7. `Operation` must explicitly model long-running work.
8. Brief generation must use dependency closure and cluster packing.
9. Embedded and Cloud profiles must be isolated through adapters.

## Repository Layout

```text
skills/
  execution-memory-engine-skills/
    SKILL.md                       # model-agnostic skill file
scripts/
  install.ps1                      # Windows installer
  install.sh                       # macOS/Linux installer
docs/
  project-introduction.zh-CN.md    # Chinese detailed introduction
  project-introduction.en.md       # English detailed introduction
README.md                          # Chinese entry
README.en.md                       # English entry
```

## Installation

### Codex

Windows PowerShell:

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target codex
```

macOS / Linux:

```bash
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
chmod +x scripts/install.sh
./scripts/install.sh codex
```

### OpenCode

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target opencode
```

Verify:

```powershell
opencode debug skill | Select-String "execution-memory-engine-skills"
```

### Claude Code

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target claude
```

### Project-local Generic Install

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

### Custom Skills Directory

```powershell
.\scripts\install.ps1 -Target custom -CustomSkillsPath "D:\my-skills"
```

```bash
./scripts/install.sh custom "$(pwd)" /path/to/my-skills
```

## How To Use

In tools that support skills, ask the model:

```text
Use the execution-memory-engine-skills skill.
```

For tools without automatic skill discovery, point the model at the file:

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

## Quick Test

Ask the model:

```text
Use the execution-memory-engine-skills skill. Tell me the required verification routine for a TypeScript Execution Memory Engine MVP. Do not modify files.
```

Expected answer should include:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

OpenCode example:

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-skills skill. Tell me the verification routine, but do not modify files."
```

## Typical Target Code Structure

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

## Detailed Documentation

- [Chinese detailed introduction](docs/project-introduction.zh-CN.md)
- [English detailed introduction](docs/project-introduction.en.md)

## License

No license has been added yet. Add one before using this repository in a public package ecosystem or commercial distribution.
