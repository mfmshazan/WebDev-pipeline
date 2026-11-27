# webdev-pipeline

A reusable, agentic web-development pipeline for Claude Code. You give a project idea;
the pipeline runs **research → requirements → UX → UI → architecture → coding → testing
→ visual QA → review → audits → docs → deployment advice**.

It **never deploys.** The final step only writes hosting advice to
`docs/DEPLOYMENT_ADVICE.md`.

## How it works

- **Global install.** The pipeline lives in `~/.claude/` and works inside any project
  directory. This repo is the source; `install.sh` copies it into place.
- **20 agents, one job each.** Each agent reads specific files and writes one output
  file. Agents communicate **only through files in `docs/`** — never through chat.
- **3 commands** orchestrate the agents and stop for your approval at the right moments.

| Source (this repo) | Installs to | Purpose |
|--------------------|-------------|---------|
| `agents/wd-*.md` | `~/.claude/agents/` | 20 subagents, prefixed `wd-` |
| `commands/wd/*.md` | `~/.claude/commands/wd/` | `/wd:new-project`, `/wd:build-next`, `/wd:finish` |
| `CONVENTIONS.md` | `~/.claude/webdev-pipeline/CONVENTIONS.md` | shared rules every agent reads |
| `templates/` | `~/.claude/webdev-pipeline/templates/` | canonical doc + stack templates |

## Install

```bash
git clone <this-repo> webdev-pipeline
cd webdev-pipeline
bash install.sh
```

`install.sh` copies `agents/`, `commands/`, `CONVENTIONS.md`, and `templates/` into
`~/.claude/`, and installs the **Playwright MCP at user scope**
(`claude mcp add --scope user playwright npx @playwright/mcp@latest`). If the `claude`
CLI isn't on your PATH, it prints the command to run manually. Restart Claude Code (or
run `/agents`) afterward to load the `wd-*` agents.

> **Playwright MCP** powers reference screenshots, prototype shots, visual QA, and the
> a11y/performance audit (captures at 390 / 768 / 1440px). If it's missing, those
> agents degrade gracefully — they skip screenshots and note it in their output doc.

## Usage

### 1. Start a project
```
/wd:new-project "a habit-tracking app for students"
```
Runs research (parallel) → PRD → **✋ your approval** → UX/UI/mockups →
**✋ your approval** → architecture → DB → task list → scaffold. The command verifies
each agent's output file exists before advancing, and stops at both approval gates.

### 2. Build, task by task
```
/wd:build-next            # or: /wd:build-next T005
```
Takes the next unchecked task from `docs/TASKS.md` (respecting dependencies) through the
build loop — backend → frontend → tests → visual QA → review. It loops back to the
developers on a failing verdict (up to 3 times), then commits **per function** (no
`Co-Authored-By` trailer) and pushes to `origin` when a remote exists. Repeat until all
tasks are `[x]`.

### 3. Finish
```
/wd:finish
```
Refuses to run until every task in `docs/TASKS.md` is ticked. Then: security audit →
performance/a11y audit → docs → deployment advice. It ends by summarizing the
recommended hosting option, estimated monthly cost, and required env vars from
`docs/DEPLOYMENT_ADVICE.md`.

## What a generated project's `docs/` looks like

```
docs/
├── IDEA.md
├── research/{market,ui-references,tech}.md   (+ screenshots/)
├── PRD.md                                     ✋ approval gate 1
├── design/{UX,UI}.md  +  prototypes/          ✋ approval gate 2
├── architecture/{ARCHITECTURE,DATA_MODEL,SCAFFOLD}.md
├── TASKS.md            (source of truth for /wd:build-next)
├── PROGRESS.md
├── qa/visual-qa-<task>.md
├── reviews/review-<task>.md
├── audits/{SECURITY,PERFORMANCE_A11Y}.md
└── DEPLOYMENT_ADVICE.md
```

## Default stack

- **Frontend:** Next.js (App Router) + TypeScript + TailwindCSS
- **API:** Node.js / Express + TypeScript
- **Database:** PostgreSQL + Prisma
- **Mobile (when needed):** React Native

## Core rules

- Agents communicate **only through files in `docs/`**.
- Feature-based folders: `features/<name>/{routes,controller,service,repository,types,test}`,
  max ~300 lines/file. Services are framework-free; repositories own all Prisma access.
- UI references are **inspiration only** — never copy designs or brands.
- Developers have **no web access**; auditors and the deployment-advisor are read-only.
- The pipeline **never deploys** — it only advises.

See [CONVENTIONS.md](CONVENTIONS.md) for the full ruleset, and `templates/` for the doc
skeletons every agent fills.
