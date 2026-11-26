# webdev-pipeline

A reusable, agentic web-development pipeline for Claude Code. You give a project
idea; the pipeline runs research → requirements → UX → UI → architecture → coding →
testing → visual QA → review → audits → docs → **deployment advice**.

It **never deploys**. The final step only writes hosting advice to
`docs/DEPLOYMENT_ADVICE.md`.

## What it installs

The pipeline is **global**: it lives in `~/.claude/` and works inside any project
directory. This repo is the source; `install.sh` copies it into place.

| Source (this repo) | Installs to | Purpose |
|--------------------|-------------|---------|
| `agents/*.md` | `~/.claude/agents/` | 20 subagents, prefixed `wd-` |
| `commands/wd/*.md` | `~/.claude/commands/wd/` | `/wd:new-project`, `/wd:build-next`, `/wd:finish` |
| `templates/` | `~/.claude/webdev-pipeline/templates/` | doc skeletons + stack conventions read by agents |
| `CONVENTIONS.md` | `~/.claude/webdev-pipeline/CONVENTIONS.md` | shared rules every agent reads |

## Install

```bash
git clone <this-repo> webdev-pipeline
cd webdev-pipeline
bash install.sh
```

Then restart Claude Code (or run `/agents` to confirm the `wd-*` agents appear).

### Optional but recommended: Playwright MCP

Several agents take screenshots (research references, prototypes, visual QA,
a11y/performance checks). Install the Playwright MCP server once:

```bash
claude mcp add playwright npx @playwright/mcp@latest
```

If it is missing, those agents degrade gracefully — they skip screenshots and
record a note in their output doc instead of failing.

## Usage

```
/wd:new-project "a habit-tracking app for students"
```

Runs research (parallel) → PRD → ✋ **your approval** → UX/UI/mockups →
✋ **your approval** → architecture → DB → task list → scaffold.

```
/wd:build-next
```

Takes the next unchecked task in `docs/TASKS.md` through the build loop
(backend → frontend → tests → visual QA → review), then commits per function and
pushes.

```
/wd:finish
```

Only when every task is done: security audit → performance/a11y audit → docs →
deployment advice.

## Default stack

- **Frontend:** Next.js (App Router) + TypeScript + TailwindCSS
- **API:** Node.js / Express + TypeScript
- **Database:** PostgreSQL + Prisma
- **Mobile (when needed):** React Native

## Core rules

- Agents communicate **only through files in `docs/`** — never through chat.
- Code uses **feature-based folders**: `features/<name>/{routes,controller,service,repository,types,test}`, max ~300 lines/file.
- UI references are **inspiration only** — never copy designs or brands.
- The pipeline never deploys. It only advises.

See [CONVENTIONS.md](CONVENTIONS.md) for the full ruleset every agent follows.
