---
description: Start a new project from an idea — research, PRD (approval), UX/UI/mockups (approval), architecture, DB, tasks, scaffold.
argument-hint: "<project idea>"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, TodoWrite
---

You are orchestrating the **/wd:new-project** pipeline. Agents communicate only
through files in `docs/`. Run phases in order and **stop at the two approval gates**.

The idea: **$ARGUMENTS**

If `$ARGUMENTS` is empty, ask the user for the idea before doing anything else.

First read `~/.claude/webdev-pipeline/CONVENTIONS.md` so you enforce the shared rules.
Create `docs/` and write the idea verbatim to `docs/IDEA.md` (add a short title).
Use TodoWrite to track the phases below.

## Phase 1 — Research (parallel)
Launch these three subagents **in parallel** (a single message with three Task calls):
- `wd-market-researcher` → `docs/research/market.md`
- `wd-ui-researcher` → `docs/research/ui-references.md`
- `wd-tech-researcher` → `docs/research/tech.md`
Wait for all three. Summarize what each produced in 2–3 lines.

## Phase 2 — PRD
Launch `wd-requirements-analyst` → `docs/PRD.md`. Summarize the MVP scope and the
open questions it raised.

## ✋ APPROVAL GATE 1
Present a concise summary of the PRD (scope, key features, open questions). Then
**STOP** and ask the user to approve or request changes. Do not proceed until they
approve. If they request changes, re-run `wd-requirements-analyst` with their notes
(write the notes into `docs/IDEA.md` or an appendix so the agent reads them).

## Phase 3 — UX, UI, Mockups
After approval, run in sequence (each depends on the previous):
1. `wd-ux-designer` → `docs/design/UX.md`
2. `wd-ui-designer` → `docs/design/UI.md`
3. `wd-prototype-builder` → `docs/design/prototypes/` (+ screenshots)
Summarize the screens and show the paths to the prototype screenshots.

## ✋ APPROVAL GATE 2
Present the UX/UI direction and link the prototype screenshots. **STOP** and ask the
user to approve or request changes. Loop back on the relevant design agent(s) if they
request changes. Do not proceed until approved.

## Phase 4 — Architecture → DB → Tasks → Scaffold
After approval, run in sequence:
1. `wd-architect` → `docs/architecture/ARCHITECTURE.md`
2. `wd-db-designer` → `docs/architecture/DATA_MODEL.md` + `prisma/schema.prisma`
3. `wd-planner` → `docs/TASKS.md`
4. `wd-scaffolder` → project skeleton + `docs/architecture/SCAFFOLD.md`

## Done
Report: what was generated, the number of tasks in `docs/TASKS.md`, any manual setup
the scaffolder flagged (e.g. provisioning Postgres, filling `.env`), and tell the user
to run **/wd:build-next** to start building. Do not deploy anything.
