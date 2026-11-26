---
description: Build the next task in docs/TASKS.md through the build loop (backend, frontend, tests, visual QA, review), then commit per function and push.
argument-hint: "(optional) task id e.g. T003"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

You are orchestrating one pass of the **/wd:build-next** build loop. Agents
communicate only through files in `docs/`.

First read `~/.claude/webdev-pipeline/CONVENTIONS.md` and `docs/TASKS.md`.

## Select the task
- If `$ARGUMENTS` names a task id, use it.
- Otherwise pick the **first unchecked `[ ]` task whose dependencies are all `[x]`**.
- If every task is done, stop and tell the user to run **/wd:finish**.
Announce the selected task id + title. Track the loop with TodoWrite.

## Build loop
1. **Backend** — if the task has backend scope, launch `wd-backend-developer` with the
   task id. Skip if the task is frontend-only.
2. **Frontend** — if the task has frontend scope, launch `wd-frontend-developer` with
   the task id. Skip if backend-only.
3. **Tests** — launch `wd-tester` with the task id. It writes/runs tests.
4. **Visual QA** — if the task touches UI, launch `wd-visual-qa` → `docs/qa/visual-qa-<task>.md`.
   Skip for pure-backend tasks.
5. **Review** — launch `wd-reviewer` → `docs/reviews/review-<task>.md`.

## Handle the verdict
- If the reviewer (or tester/visual-qa) returns **changes requested**, loop back to the
  relevant developer agent with the specific findings, then re-run tester/visual-qa/
  reviewer. Repeat until the reviewer **approves** (cap at ~3 iterations, then stop and
  surface the blockers to the user).

## Commit & push (only after reviewer approval)
Per `CONVENTIONS.md` §6:
- Stage and commit in **small, function/logical-unit commits** with clear imperative
  messages. **Do NOT add a `Co-Authored-By` trailer.**
- Mark the task `[x]` in `docs/TASKS.md` and append a line to `docs/PROGRESS.md`
  (task id, date, commit hashes, notes).
- Commit the `docs/` updates too.
- **Push** to `origin` if a remote exists (`git remote`); if none, commit locally and
  report that push was skipped (no remote configured).

## Done
Report: task completed, review verdict, test results, commit hashes, push status, and
the next task that /wd:build-next would pick. Never deploy.
