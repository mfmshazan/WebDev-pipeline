---
description: Start a new project from an idea — research (parallel), PRD (approval), UX/UI/mockups (approval), architecture, DB, tasks, scaffold.
argument-hint: "<project idea>"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, TodoWrite
---

You orchestrate the **/wd:new-project** pipeline. Agents talk only through files in
`docs/`. Run phases in order, run research in parallel, **STOP at the two approval
gates**, and **verify each output file exists before moving on**.

The idea: **$ARGUMENTS**

## Setup
1. If `$ARGUMENTS` is empty, ask the user for the idea and stop until they answer.
2. Read `~/.claude/webdev-pipeline/CONVENTIONS.md`.
3. Create `docs/` and write the idea to `docs/IDEA.md` (add a short title).
4. Create a TodoWrite list with the phases below.

> **Verify rule:** after each agent returns, confirm its output file(s) exist (Glob or
> `test -f`). If a file is missing or empty, re-run that agent once with a note about
> what was missing. If it still fails, STOP and report the failure — do not continue.

## Phase 1 — Research (PARALLEL)
Launch these three in **one message with three Task calls** so they run in parallel:
- `wd-market-researcher` → `docs/research/market.md`
- `wd-ui-researcher` → `docs/research/ui-references.md`
- `wd-tech-researcher` → `docs/research/tech.md`

**Verify:** all three files exist and are non-empty. Then summarize each in 2–3 lines.

## Phase 2 — PRD
Launch `wd-requirements-analyst` → `docs/PRD.md`.
**Verify:** `docs/PRD.md` exists and contains a `## Features` section with `F#` items.

## ✋ APPROVAL GATE 1 — STOP
Print a concise PRD summary (MVP scope, feature list `F#`, and the Open Questions).
Then **STOP and ask the user to approve or request changes.** Do not start Phase 3
until they approve.
- If changes: append their notes to `docs/IDEA.md` (so the agent reads them), re-run
  `wd-requirements-analyst`, re-verify, and ask again.

## Phase 3 — UX, UI, Mockups (SEQUENTIAL)
Run in order, verifying each before the next:
1. `wd-ux-designer` → `docs/design/UX.md` — **verify** it exists with `## Traceability`.
2. `wd-ui-designer` → `docs/design/UI.md` — **verify** it exists with `## Design Tokens`.
3. `wd-prototype-builder` → `docs/design/prototypes/` — **verify** `docs/design/prototypes/README.md`
   exists and at least one `*.html` is present (screenshots may be skipped if Playwright
   MCP is absent).
Summarize the screens and list the prototype screenshot paths.

## ✋ APPROVAL GATE 2 — STOP
Present the UX/UI direction and link the prototype files/screenshots. **STOP and ask
the user to approve or request changes.** Loop back on the relevant design agent(s) and
re-verify if they request changes. Do not start Phase 4 until approved.

## Phase 4 — Architecture → DB → Tasks → Scaffold (SEQUENTIAL)
Run in order, verifying each before the next:
1. `wd-architect` → `docs/architecture/ARCHITECTURE.md` — **verify** `## API Surface` present.
2. `wd-db-designer` → `docs/architecture/DATA_MODEL.md` + `prisma/schema.prisma` —
   **verify** both exist.
3. `wd-planner` → `docs/TASKS.md` — **verify** it exists with at least one `- [ ] T0`.
4. `wd-scaffolder` → project skeleton + `docs/architecture/SCAFFOLD.md` + root `CLAUDE.md` —
   **verify** `docs/architecture/SCAFFOLD.md` and `CLAUDE.md` exist.

## Done
Report: files generated, task count in `docs/TASKS.md`, any manual setup the scaffolder
flagged (e.g. provision Postgres, fill `.env`). Tell the user to run **/wd:build-next**.

## Do not
- Do not skip either approval gate or continue past a failed verification.
- Do not run research sequentially — Phase 1 must be parallel.
- Do not deploy anything or create deploy configs.
