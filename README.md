<p align="right">
  <a href="./README.md"><img src="https://img.shields.io/badge/语言-中文-blue" alt="中文"></a>
  <a href="./README.en.md"><img src="https://img.shields.io/badge/Language-English-lightgrey" alt="English"></a>
</p>

# Execution Memory Engine Skills

面向全部大模型与 AI 编程代理的 Execution Memory Engine 技能包。

## 项目简介

`Execution Memory Engine Skills` 是一组面向大模型、AI Agent、IDE Agent、CLI 编程助手和自动化工程代理的可复用技能说明。它用于指导模型在设计、实现、测试和审查 Execution Memory Engine 系统时遵守稳定的架构边界。

Execution Memory Engine 的核心目标不是“保存更多聊天记录”，而是把 Agent 的执行轨迹提炼成可检索、可压缩、可复用的执行经验层。这个 Skills 包把这套工作方式沉淀为一个可安装、可复制、可直接给模型读取的 `SKILL.md`。

## 它不是什么

这不是 OpenCode 专属项目，也不是某一个 CLI 的插件。OpenCode 只是支持的安装目标之一。

这个仓库也不是完整的 Execution Memory Engine 服务端实现。它发布的是面向大模型的技能说明，用来指导模型在不同代码库中实现或维护 Execution Memory Engine。

## 适用对象

- Codex / OpenAI Codex
- OpenCode
- Claude Code
- Gemini CLI
- Cursor / Windsurf / IDE Agent
- 自研 Agent Runtime
- 任意可以读取 `SKILL.md` 的大模型工作流

## Skill 解决的问题

该 skill 帮助模型避免以下常见错误：

- 把原始 `run trace` 当成长期记忆直接注入模型
- 混淆 `memory`、`decision`、`failure_pattern`、`skill` 和 `brief`
- 用线性截断生成 Brief，导致支撑 Decision 或 Failure Pattern 被裁掉
- 用同步日志代替长耗时任务的 `Operation` 生命周期模型
- 忘记区分 Seed Skills 与 Learned Skills
- 在实现中绕过 Adapter，导致 Embedded / Cloud 双部署形态难以扩展
- 修改代码后没有运行测试、构建和 demo

## 核心架构原则

1. `run trace` 是原始事实层。
2. `memory` 是提炼后的经验层。
3. `decision` 表示可复用架构或实现决策。
4. `failure_pattern` 表示可复用失败模式和规避方式。
5. `skill` 表示可被再次触发的工作流经验。
6. `ExecutionBrief` 是给 Planner / Tool Selection 的低 token、高密度输入。
7. `Operation` 必须显式建模长耗时任务。
8. Brief 生成必须做依赖闭包和 cluster packing。
9. Embedded Profile 与 Cloud Profile 要通过 Adapter 隔离。

## 仓库结构

```text
skills/
  execution-memory-engine-skills/
    agents/
      openai.yaml                  # Codex / OpenAI skill UI metadata
    SKILL.md                       # 面向全部大模型的 skill 文件
scripts/
  install.ps1                      # Windows 安装脚本
  install.sh                       # macOS/Linux 安装脚本
docs/
  project-introduction.zh-CN.md    # 中文详细介绍
  project-introduction.en.md       # English detailed introduction
README.md                          # 中文入口
README.en.md                       # English entry
LICENSE                            # MIT 许可证
```

## 安装方式

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

如果你的工具没有固定的全局 skills 目录，可以把 skill 安装到项目的 `.skills` 目录，然后在提示词中要求模型读取该文件。

```powershell
git clone https://github.com/Lawrence7y/Execution-Memory-Engine-Skills.git
cd Execution-Memory-Engine-Skills
.\scripts\install.ps1 -Target project -ProjectPath "D:\path\to\your\project"
```

然后把这个路径交给模型：

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

## 如何使用

在支持 skills 的工具里，直接要求模型使用：

```text
Use the execution-memory-engine-skills skill.
```

对于不支持自动发现 skills 的工具，把 `SKILL.md` 路径贴给模型：

```text
Read .skills/execution-memory-engine-skills/SKILL.md and follow it while working on this Execution Memory Engine repository.
```

## 快速测试

向模型发送：

```text
Use the execution-memory-engine-skills skill. Tell me the required verification routine for a TypeScript Execution Memory Engine MVP. Do not modify files.
```

期望回答包含：

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

OpenCode 示例：

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-skills skill. Tell me the verification routine, but do not modify files."
```

## 典型目标代码结构

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

## 详细文档

- [中文详细介绍](docs/project-introduction.zh-CN.md)
- [English detailed introduction](docs/project-introduction.en.md)

## License

本项目使用 MIT 许可证发布。详见 [LICENSE](LICENSE)。
