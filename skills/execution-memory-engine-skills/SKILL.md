---
name: execution-memory-engine-skills
description: Guide any AI coding agent or large language model assistant working on Execution Memory Engine systems. Use when designing, implementing, testing, debugging, reviewing, or documenting systems for run trace logging, Operation tracking, experience distillation, memory retrieval, dependency-aware Execution Brief generation, Seed Skills, Learned Skills, or Embedded/Cloud memory engine profiles.
---

# Execution Memory Engine Skills

Use this skill when working on an Execution Memory Engine implementation or design. It is model-agnostic and can guide Codex, OpenCode, Claude Code, Gemini CLI, Cursor-style agents, or any LLM assistant that can read a skill file.

## Source Of Truth

- Treat the local design document, usually `Execution Memory Engine.md`, as the primary architecture source.
- If the repository has planning files such as `task_plan.md`, `findings.md`, or `progress.md`, read them before multi-step work.
- Do not replace the project design with generic memory-system assumptions.

## Core Architecture Boundaries

- `run trace` is raw evidence.
- `memory`, `decision`, `failure_pattern`, and `skill` are distilled experience objects.
- `ExecutionBrief` is the planner/tool-selection input. Do not inject raw run trace directly into the brief.
- Long-running work must use an `Operation` model, not only synchronous request/response events.
- Brief generation must keep dependency clusters intact; do not linearly truncate away supporting decisions or failure patterns.
- Seed Skills and Learned Skills must remain distinguishable by source and priority.

## Required MVP Loop

When implementing the MVP, preserve this closed loop:

```text
run trace -> operation tracking -> distillation -> structured memories/skills
-> retrieval -> dependency closure -> clustered Execution Brief
```

## Verification Routine

For the standard TypeScript + Node.js MVP implementation, run:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

Expected baseline:

- Tests pass.
- TypeScript build exits 0.
- Demo prints run/distill/retrieval/brief observability and a five-section Execution Brief.

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

## Typical Implementation Map

Look for these files in a TypeScript MVP repository:

- Domain types: `src/domain/models.ts`
- Scoring and token helpers: `src/domain/scoring.ts`
- Store/vector/queue/artifact ports: `src/application/ports/`
- Engine composition: `src/application/engine.ts`
- Run logging: `src/application/services/run-trace-logger.ts`
- Operation lifecycle: `src/application/services/operation-manager.ts`
- Distillation: `src/application/services/experience-distiller.ts`
- Retrieval: `src/application/services/retrieval-engine.ts`
- Brief generation: `src/application/services/brief-generator.ts`
- Embedded SQLite store: `src/infrastructure/embedded/embedded-store.ts`
- Seed skill loader: `src/infrastructure/embedded/seed-skill-loader.ts`
- Demo: `examples/demo.ts`

## Design Rules

- Preserve adapter boundaries for Cloud Profile: `ExecutionMemoryStore`, `VectorIndexAdapter`, `QueueAdapter`, and `ArtifactStoreAdapter`.
- Keep Embedded Profile runnable without external databases.
- Store high-frequency stdout/stderr as artifacts or tails/pointers, not full `run_events` streams.
- Retrieval must include structured filtering, keyword search, vector abstraction, fusion scoring, rerank, and dependency closure.
- Brief generation must use dependency-aware cluster packing.
- Every accepted memory must be traceable to a source run or explicit seed/import source.

## Change Workflow

1. Write or update a focused test first.
2. Run the test and confirm it fails for the expected reason.
3. Implement the smallest production change that makes it pass.
4. Run the verification routine.
5. Record meaningful errors or decisions in planning/progress files when the task spans multiple steps.
