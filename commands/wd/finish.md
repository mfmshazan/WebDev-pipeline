---
description: Finalize the project (only when all tasks are done) — security audit, performance/a11y audit, docs, then deployment advice. Never deploys.
argument-hint: ""
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

You are orchestrating the **/wd:finish** finalization. Agents communicate only through
files in `docs/`. This phase **never deploys** — it ends with written advice only.

First read `~/.claude/webdev-pipeline/CONVENTIONS.md` and `docs/TASKS.md`.

## Guard: all tasks must be done
Verify every task in `docs/TASKS.md` is checked `[x]`. If any remain unchecked, **stop**
and tell the user which tasks are outstanding and to run /wd:build-next until they're
complete. Do not proceed.

## Run finalization (in order)
Track with TodoWrite.
1. **Security audit** — launch `wd-security-auditor` → `docs/audits/SECURITY.md`.
2. **Performance & a11y audit** — launch `wd-performance-a11y-auditor` →
   `docs/audits/PERFORMANCE_A11Y.md`.
3. Summarize Critical/High findings from both audits. If there are Critical or High
   items, **recommend** the user run /wd:build-next-style fixes (or fix now if they
   confirm) before shipping — but this is advice; continue to docs regardless.
4. **Docs** — launch `wd-docs-writer` (README, SETUP, API, ARCHITECTURE_SUMMARY, .env.example).
5. **Deployment advice** — launch `wd-deployment-advisor` → `docs/DEPLOYMENT_ADVICE.md`.

## Commit (no deploy)
Commit the new audit/docs/advice files (small commits, no `Co-Authored-By` trailer).
Push to `origin` if a remote exists; otherwise report push skipped.

## Done
Report: audit summaries (counts by severity), the docs produced, and the recommended
hosting option from `docs/DEPLOYMENT_ADVICE.md` with its estimated monthly cost.
Remind the user the pipeline does **not** deploy — the deploy guide is theirs to follow
manually.
