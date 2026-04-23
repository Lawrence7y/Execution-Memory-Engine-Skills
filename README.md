# Execution Memory Engine MVP Skill / Execution Memory Engine MVP 技能

OpenCode skill for working on projects that implement the Execution Memory Engine MVP: run trace logging, Operation tracking, experience distillation, retrieval, dependency-aware Execution Brief generation, and Seed/Learned Skills.

这是一个用于 OpenCode 的项目技能，面向实现 Execution Memory Engine MVP 的代码库：执行轨迹记录、长任务 Operation 追踪、经验提炼、检索、依赖感知 Execution Brief 生成，以及 Seed/Learned Skills 管理。

## Install / 安装

### Project-local install / 项目级安装

Use this when you want the skill available only in one repository.

如果只想让某个项目使用该 skill，推荐项目级安装。

```powershell
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
.\scripts\install.ps1 -Scope project -ProjectPath "D:\path\to\your\project"
```

Verify:

```powershell
cd "D:\path\to\your\project"
opencode debug skill | Select-String "execution-memory-engine-mvp"
```

### Global install / 全局安装

Use this when you want the skill available to all OpenCode projects.

如果想让所有 OpenCode 项目都能发现该 skill，可以全局安装。

```powershell
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
.\scripts\install.ps1 -Scope global
```

Verify:

```powershell
opencode debug skill | Select-String "execution-memory-engine-mvp"
```

### macOS/Linux

```bash
git clone https://github.com/Lawrence7y/opencode-execution-memory-engine-skill.git
cd opencode-execution-memory-engine-skill
chmod +x scripts/install.sh
./scripts/install.sh project /path/to/your/project
# or
./scripts/install.sh global
```

## Quick test / 快速测试

```powershell
opencode run --dir "D:\path\to\your\project" "Use the execution-memory-engine-mvp skill. Tell me the verification commands for this repository, but do not modify files."
```

Expected answer should include:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

## Documentation / 文档

Read the detailed bilingual project introduction:

阅读详细的中英双语项目介绍：

- [docs/project-introduction.zh-CN.en.md](docs/project-introduction.zh-CN.en.md)

## Repository layout / 仓库结构

```text
skills/execution-memory-engine-mvp/SKILL.md   # installable OpenCode skill
scripts/install.ps1                           # Windows installer
scripts/install.sh                            # macOS/Linux installer
docs/project-introduction.zh-CN.en.md         # detailed bilingual introduction
```
