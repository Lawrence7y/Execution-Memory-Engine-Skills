<p align="right">
  <a href="./project-introduction.zh-CN.md"><img src="https://img.shields.io/badge/语言-中文-blue" alt="中文"></a>
  <a href="./project-introduction.en.md"><img src="https://img.shields.io/badge/Language-English-lightgrey" alt="English"></a>
</p>

# Execution Memory Engine Skills 项目介绍

## 1. 项目定位

`Execution Memory Engine Skills` 是一个面向全部大模型和 AI Agent 的技能包。它不是 OpenCode 专属项目，也不是某一个命令行工具的插件。它的核心价值是把 Execution Memory Engine 的架构纪律、测试纪律和实现边界沉淀成一个可复用的 `SKILL.md`，让不同模型在参与相关项目时能更快进入正确工作方式。

这个仓库发布的是面向模型的技能说明，而不是完整的 Execution Memory Engine 服务端实现。任何能够读取 Markdown 指令的大模型工具，都可以把这里的 skill 作为执行 Execution Memory Engine 项目时的高优先级工作规范。

## 2. 为什么需要这个 Skills 包

Execution Memory Engine 的难点不在于“保存更多数据”，而在于长期保持清晰的概念边界：

- `run trace` 是原始执行证据，不是长期记忆。
- `memory` 是提炼后的可复用经验，不是聊天流水。
- `decision` 表示可复用的架构或实现决策。
- `failure_pattern` 表示可复用的失败模式和规避方式。
- `skill` 表示可再次触发的稳定工作流经验。
- `ExecutionBrief` 是给 Planner / Tool Selection 的低 token、高密度输入，不是检索结果堆叠。
- `Operation` 是长耗时任务生命周期模型，不是普通日志字段。

如果模型忽略这些边界，系统会退化成“把历史记录塞回上下文”的简单方案，失去可复用性、可观测性、冲突处理能力和 token 效率。

## 3. 支持的模型与工具

这个 skill 包设计为模型无关，可以用于：

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE Agent
- 自研 Agent Runtime
- 任意可以读取 `SKILL.md` 的大模型工作流

OpenCode 只是支持的安装目标之一，不是这个仓库的唯一目标。

## 4. Skill 文件

可安装的核心 skill 文件位于：

```text
skills/execution-memory-engine-skills/SKILL.md
```

Codex / OpenAI 的界面元数据位于：

```text
skills/execution-memory-engine-skills/agents/openai.yaml
```

它包含：

- Execution Memory Engine 的事实来源规则
- 核心对象边界
- MVP 最小闭环要求
- Embedded / Cloud Profile 抽象要求
- Operation 长耗时任务模型要求
- Retrieval 和 Brief 依赖闭包要求
- Seed Skills 与 Learned Skills 共存规则
- 推荐测试、构建和 demo 验证流程

## 5. 安装方式

### Codex

Windows PowerShell：

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target codex
```

macOS / Linux：

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

验证：

```powershell
opencode debug skill | Select-String "execution-memory-engine-skills"
```

### Claude Code

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target claude
```

### 项目级通用安装

如果你的工具没有固定的全局 skills 目录，可以把 skill 安装到项目的 `.skills` 目录：

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target project -ProjectPath "D:\path\to\your\project"
```

然后要求模型读取：

```text
D:\path\to\your\project\.skills\execution-memory-engine-skills\SKILL.md
```

### 自定义目录安装

```powershell
.\scripts\install.ps1 -Target custom -CustomSkillsPath "D:\my-skills"
```

```bash
./scripts/install.sh custom "$(pwd)" /path/to/my-skills
```

## 6. 使用方式

在支持 skills 自动发现的工具里，直接要求模型使用：

```text
Use the execution-memory-engine-skills skill.
```

在不支持自动发现的工具里，把安装后的 `SKILL.md` 路径交给模型：

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

## 7. 验证方式

对于 TypeScript + Node.js 的 Execution Memory Engine MVP，这个 skill 推荐模型至少运行：

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

API 烟测示例：

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

## 8. 推荐实现边界

模型在实现 Execution Memory Engine 项目时，应尽量保留以下边界：

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

这些边界让 Embedded Profile 可以先落地，同时保留 Cloud Profile 的扩展能力。

## 9. 许可证

本仓库使用 MIT 许可证发布。许可证文件位于：

```text
LICENSE
```

## 10. 后续扩展

这个仓库后续可以继续扩展：

- 拆分更多子 skill，例如 architecture、distillation、retrieval、brief-packing。
- 增加更多工具专属元数据和默认提示。
- 增加 sqlite-vec / pgvector 替换指南。
- 增加 Cloud Profile adapter checklist。
- 增加更完整的 example prompts 和 forward tests。
