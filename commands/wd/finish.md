---
description: Finalize the project (only when all tasks are done) — security audit, performance/a11y audit, docs, then deployment advice. Never deploys.
argument-hint: ""
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

You orchestrate the **/wd:finish** finalization. Agents talk only through files in
`docs/`. This phase **never deploys** — it ends with written advice only.

## Setup
1. Read `~/.claude/webdev-pipeline/CONVENTIONS.md` and `docs/TASKS.md`.

## Guard — every task must be ticked
Scan `docs/TASKS.md` for task lines. If **any** task is still `- [ ]` (not `[x]`):
- **STOP.** List the outstanding task IDs + titles and tell the user to run
  /wd:build-next until they are all complete. Do not run any finalization agent.

## Finalization (sequential; verify each output before the next)
Start a TodoWrite list.
1. **Security audit** — launch `wd-security-auditor` → `docs/audits/SECURITY.md`.
   **Verify** the file exists; capture the severity counts from `## Summary`.
2. **Performance & a11y audit** — launch `wd-performance-a11y-auditor` →
   `docs/audits/PERFORMANCE_A11Y.md`. **Verify** it exists; read its `## Verdict`.
3. Report any **Critical/High** findings from both audits. Recommend the user fix them
   (re-run /wd:build-next-style work) before shipping — this is advice; continue regardless.
4. **Docs** — launch `wd-docs-writer`. **Verify** root `README.md`, `docs/SETUP.md`,
   `docs/API.md`, and `docs/ARCHITECTURE_SUMMARY.md` exist.
5. **Deployment advice** — launch `wd-deployment-advisor` → `docs/DEPLOYMENT_ADVICE.md`.
   **Verify** it exists with `## Recommended Option` and `## Required Environment Variables`.

## Commit (no deploy)
Commit the new audit/docs/advice files in small commits (no `Co-Authored-By` trailer).
Push to `origin` if a remote exists; otherwise report push skipped.

## Done — summarize deployment advice
Read `docs/DEPLOYMENT_ADVICE.md` and print a short summary to the user:
- The **recommended hosting option** and its **estimated monthly cost**.
- The 2–3 options in one line each.
- The count of **required environment variables**.
- A reminder: the pipeline does **not** deploy — the step-by-step guide in
  `docs/DEPLOYMENT_ADVICE.md` is theirs to follow manually.
Also give the audit severity counts from step 1–2.

## Do not
- Do not run any finalization agent while tasks remain unticked.
- Do not deploy, create deploy configs, or run deploy/migration commands.
- Do not add a `Co-Authored-By` trailer when committing.
