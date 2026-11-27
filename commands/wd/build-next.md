---
description: Build the next task in docs/TASKS.md through the build loop (backend, frontend, tests, visual QA, review), then commit per function and push.
argument-hint: "(optional) task id e.g. T003"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

You orchestrate one pass of the **/wd:build-next** build loop. Agents talk only through
files in `docs/`. Verify each stage's output before moving to the next.

## Setup
1. Read `~/.claude/webdev-pipeline/CONVENTIONS.md`, the project root `CLAUDE.md`, and `docs/TASKS.md`.
2. Confirm the project is scaffolded (a `package.json` exists). If not, STOP and tell the
   user to run /wd:new-project first.

## Select the task
- If `$ARGUMENTS` names a task id, use it.
- Else pick the **first unchecked `[ ]` task whose dependencies are all `[x]`**.
- If every task is `[x]`, STOP and tell the user to run **/wd:finish**.
Read the task's `scope` field. Announce the task id + title. Start a TodoWrite list.

## Build loop (run only the stages the task's scope requires)
1. **Backend** — if scope is `backend` or `both`, launch `wd-backend-developer` with the
   task id. **Verify:** the task's `features/<name>/` backend files were created/changed
   (`git status`).
2. **Frontend** — if scope is `frontend` or `both`, launch `wd-frontend-developer`.
   **Verify:** the task's UI files were created/changed.
3. **Tests** — launch `wd-tester`. **Verify:** test files exist under the feature's
   `test/` and capture the pass/fail summary it returns.
4. **Visual QA** — if the task touches UI, launch `wd-visual-qa` → `docs/qa/visual-qa-<task>.md`.
   **Verify:** that file exists; read its `## Verdict`.
5. **Review** — launch `wd-reviewer` → `docs/reviews/review-<task>.md`.
   **Verify:** that file exists; read its `## Verdict`.

## Handle verdicts
- If tester (failing tests), visual-qa (`changes requested`), or reviewer
  (`changes requested`) blocks: loop back to the relevant developer agent with the
  **specific findings**, then re-run tester/visual-qa/reviewer and re-verify.
- Cap at **3 iterations**. If still blocked, STOP and surface the open blockers to the user.
- Only proceed to commit once the reviewer verdict is **approved**.

## Commit & push (only after reviewer approval)
Per `CONVENTIONS.md` §6:
1. Commit in **small, function/logical-unit commits** with imperative messages.
   **Do NOT add a `Co-Authored-By` trailer.**
2. Mark the task `[x]` in `docs/TASKS.md`; append a line to `docs/PROGRESS.md`
   (task id, date, commit hashes, notes). Commit the `docs/` updates too.
3. **Push** to `origin` if `git remote` lists one; if none, commit locally and report
   that push was skipped (no remote configured).

## Done
Report: task completed, review verdict, test summary, commit hashes, push status, and
the next task /wd:build-next would pick.

## Do not
- Do not commit before the reviewer approves.
- Do not skip tests or review to save time.
- Do not add a `Co-Authored-By` trailer, create a remote, or deploy anything.
