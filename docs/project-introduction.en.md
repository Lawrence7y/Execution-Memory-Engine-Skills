<p align="right">
  <a href="./project-introduction.zh-CN.md"><img src="https://img.shields.io/badge/语言-中文-lightgrey" alt="中文"></a>
  <a href="./project-introduction.en.md"><img src="https://img.shields.io/badge/Language-English-blue" alt="English"></a>
</p>

# Execution Memory Engine Skills Project Introduction

## 1. Positioning

`Execution Memory Engine Skills` is a skill package for all large language models and AI agents. It is not an OpenCode-only project and not a plugin for a single command-line tool. Its core value is to encode the architecture discipline, testing discipline, and implementation boundaries of Execution Memory Engine systems into a reusable `SKILL.md`.

This repository publishes model-facing skill instructions, not a complete Execution Memory Engine backend service. Any LLM tool that can read Markdown instructions can use this skill as high-priority working guidance for Execution Memory Engine projects.

## 2. Why This Skills Package Exists

The hard part of an Execution Memory Engine is not “storing more data.” The hard part is preserving clear conceptual boundaries over time:

- `run trace` is raw execution evidence, not long-term memory.
- `memory` is distilled reusable experience, not a chat transcript.
- `decision` captures reusable architecture or implementation decisions.
- `failure_pattern` captures reusable failure modes and mitigation paths.
- `skill` captures stable workflows that can be triggered again.
- `ExecutionBrief` is low-token, high-density input for Planner / Tool Selection, not a pile of retrieval results.
- `Operation` models long-running task lifecycles, not ordinary log fields.

When a model ignores these boundaries, the system degrades into a simple “stuff history back into context” mechanism and loses reusability, observability, conflict handling, and token efficiency.

## 3. Supported Models And Tools

This skill package is model-agnostic and can be used with:

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE agents
- custom agent runtimes
- any LLM workflow that can read a `SKILL.md` file

OpenCode is one supported installation target, not the identity of this repository.

## 4. Skill File

The installable skill file is:

```text
skills/execution-memory-engine-skills/SKILL.md
```

Codex / OpenAI interface metadata is:

```text
skills/execution-memory-engine-skills/agents/openai.yaml
```

It contains:

- source-of-truth rules for Execution Memory Engine work
- core object boundaries
- MVP closed-loop requirements
- Embedded / Cloud Profile abstraction requirements
- long-running Operation model requirements
- Retrieval and Brief dependency-closure requirements
- Seed Skills and Learned Skills coexistence rules
- recommended test, build, and demo verification routines

## 5. Installation

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

If your tool has no fixed global skills directory, install the skill into the project’s `.skills` directory:

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target project -ProjectPath "D:\path\to\your\project"
```

Then ask the model to read:

```text
D:\path\to\your\project\.skills\execution-memory-engine-skills\SKILL.md
```

### Custom Directory Install

```powershell
.\scripts\install.ps1 -Target custom -CustomSkillsPath "D:\my-skills"
```

```bash
./scripts/install.sh custom "$(pwd)" /path/to/my-skills
```

## 6. Usage

In tools that support skill discovery, ask the model:

```text
Use the execution-memory-engine-skills skill.
```

In tools without automatic skill discovery, point the model at the installed `SKILL.md`:

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

## 7. Verification

For a TypeScript + Node.js Execution Memory Engine MVP, the skill expects at least:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

API smoke test example:

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

## 8. Recommended Implementation Boundaries

When implementing an Execution Memory Engine project, the model should preserve these boundaries:

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

These boundaries let Embedded Profile ship first while keeping Cloud Profile extensible.

## 9. License

This repository is released under the MIT License. The license file is:

```text
LICENSE
```

## 10. Future Extensions

This repository can later add:

- smaller sub-skills such as architecture, distillation, retrieval, and brief-packing
- more tool-specific metadata and default prompts
- sqlite-vec / pgvector replacement guidance
- Cloud Profile adapter checklist
- richer example prompts and forward tests
