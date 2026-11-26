# Shared conventions (read by every agent)

This file is installed to `~/.claude/webdev-pipeline/CONVENTIONS.md`. Every agent
is told to read it first. These rules override any conflicting default.

## 1. Communication

- Agents talk to each other **only through files in `docs/`**. Never assume
  information from chat history; read the input file(s) named in your agent spec.
- Always write your output to the exact path your spec names. If a parent folder
  is missing, create it.
- Keep docs in Markdown. Be concrete and skimmable: headings, tables, checklists.

## 2. Default stack

- **Frontend:** Next.js (App Router) + TypeScript + TailwindCSS.
- **API:** Node.js / Express + TypeScript.
- **Database:** PostgreSQL + Prisma.
- **Mobile (only when the PRD requires a native app):** React Native.
- Prefer server components and route handlers where they fit; keep client
  components lean.

## 3. Code layout — feature-based folders

Every feature lives in its own folder:

```
features/<name>/
  routes/        # Express routes or Next route handlers
  controller/    # request/response handling, validation
  service/       # business logic (no framework imports)
  repository/    # data access via Prisma
  types/         # shared TypeScript types for the feature
  test/          # unit + integration tests for the feature
```

- **Max ~300 lines per file.** If a file grows past that, split it.
- Services contain business logic and must not import Express/Next.
- Repositories are the only place that touches Prisma.
- Share cross-feature code through a `shared/` or `lib/` folder, not by importing
  one feature into another.

## 4. Design references

- Reference sites and screenshots are **inspiration only**.
- **Never copy** a layout pixel-for-pixel, reuse brand names, logos, colors tied
  to a brand, or proprietary copy. Extract patterns and principles, not assets.

## 5. Quality bar

- TypeScript strict mode on. No `any` unless justified in a comment.
- Validate all external input (zod or equivalent) at the controller boundary.
- No secrets in code. Use `.env` + `.env.example`; never commit real secrets.
- Accessibility: semantic HTML, labelled controls, visible focus, adequate
  contrast.

## 6. Git (build loop)

- The user owns and provides the git repository. Do **not** create remotes.
- Commit at **function / logical-unit granularity** — small, focused commits.
- Commit messages: imperative summary line, optional body. **Do NOT add a
  `Co-Authored-By` trailer.**
- Push to `origin` when a remote exists; if no remote is configured, commit
  locally and note that push was skipped.

## 7. The pipeline never deploys

- No agent creates deploy configs, CI/CD deploy jobs, Dockerfiles-for-deploy, or
  runs any deploy command.
- Deployment is covered **only** as written advice in
  `docs/DEPLOYMENT_ADVICE.md` by the `wd-deployment-advisor` agent.

## 8. Playwright MCP (screenshot-capable agents)

- If the Playwright MCP tools are unavailable, do not fail. Skip the screenshots,
  continue your text analysis, and add a line to your output doc:
  `> Playwright MCP not available — screenshots skipped.`
- Screenshot breakpoints are always: **390px (mobile), 768px (tablet), 1440px (desktop).**
