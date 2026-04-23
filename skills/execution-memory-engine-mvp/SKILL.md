---
name: execution-memory-engine-mvp
description: Work on and test the Execution Memory Engine MVP in an OpenCode project. Use when modifying, debugging, reviewing, or verifying a repository that implements run trace logging, operation tracking, distillation, retrieval, dependency-aware Execution Brief generation, or Seed/Learned Skills.
compatibility: opencode
metadata:
  project: execution-memory-engine
  profile: embedded
---

# Execution Memory Engine MVP

Use this skill when working on an Execution Memory Engine implementation, especially in repositories based on the v1.1 design with run trace logging, Operation tracking, experience distillation, retrieval, and dependency-aware Execution Brief generation.

## Source Of Truth

- Treat the local design document, usually `Execution Memory Engine.md`, as the primary product and architecture source.
- If planning files exist, read `task_plan.md`, `findings.md`, and `progress.md` before making multi-step changes.
- Do not replace the project design with generic memory-system assumptions.

## Architecture Boundaries

- `run trace` is raw evidence.
- `memory`, `decision`, `failure_pattern`, and `skill` are distilled experience objects.
- `ExecutionBrief` is the planner input. Do not inject raw run trace directly into the brief.
- Long-running work must use `Operation`, not only synchronous request/response events.
- Brief generation must keep dependency clusters intact; do not linearly truncate away supporting decisions.

## Required Verification

When the repository provides the standard TypeScript MVP scripts, run:

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run demo
```

Expected baseline:

- `npm.cmd test`: all tests pass.
- `npm.cmd run build`: TypeScript exits 0.
- `npm.cmd run demo`: prints run/distill/retrieval/brief observability and a five-section Execution Brief.

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

## Implementation Map

Look for these files in the target repository:

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
- Keep seed skills and learned skill candidates distinct by `sourceType`.
- Store high-frequency stdout/stderr as artifacts or tails/pointers, not full `run_events` streams.
- Retrieval must include structured filtering, keyword search, vector abstraction, fusion scoring, rerank, and dependency closure.
- Brief generation must use dependency-aware cluster packing.

## Change Workflow

1. Write or update a focused test first.
2. Run the test and confirm it fails for the expected reason.
3. Implement the smallest production change that makes it pass.
4. Run `npm.cmd test`, `npm.cmd run build`, and relevant demo/API smoke checks.
5. Record meaningful errors or decisions in planning/progress files when the task is multi-step.
