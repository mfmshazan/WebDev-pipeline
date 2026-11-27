# CLAUDE.md — <PROJECT NAME>

> Project-level rules for Claude Code. The scaffolder drops this into the generated
> project root. Every agent and every build-loop pass follows it. It restates and
> localizes `~/.claude/webdev-pipeline/CONVENTIONS.md` for this specific project.
> Replace all `<…>` placeholders when scaffolding.

## 1. What this project is
- **Product:** <one-line description from docs/PRD.md>
- **Stack:** Next.js (App Router) + TypeScript + TailwindCSS · Node.js/Express API ·
  PostgreSQL + Prisma <· React Native if mobile>
- **Source of truth docs:** `docs/PRD.md`, `docs/design/`, `docs/architecture/`,
  `docs/TASKS.md`. Read the docs, never rely on chat history.

## 2. Folder structure (feature-based)
Every feature is self-contained:

```
src/
  features/
    <feature>/
      routes/        # HTTP wiring (Express routes / Next route handlers)
      controller/    # request parsing, input validation, response/error shaping
      service/       # business logic — NO framework or Prisma imports
      repository/    # ALL Prisma/data access lives here
      types/         # TypeScript types shared within the feature
      test/          # unit + integration tests for this feature
  shared/            # cross-feature utilities, UI primitives, config, middleware
  lib/               # framework-agnostic helpers
app/                 # Next.js App Router routes (frontend)
prisma/
  schema.prisma
```

- **Never import one feature into another.** Share through `shared/` or `lib/`.
- New capability ⇒ new `features/<feature>/` folder, not a dumping ground file.

## 3. Layer rules (strict dependency direction)
`routes → controller → service → repository`

| Layer | May import | Must NOT import |
|-------|-----------|-----------------|
| routes | controller | service, repository, prisma |
| controller | service, types, validation (zod) | prisma, repository directly |
| service | repository (via interface), types | express, next, prisma client |
| repository | prisma client, types | express, next, service |

- Services are pure business logic and unit-testable without a server or DB.
- Repositories are the **only** place that touches Prisma.
- Controllers validate all external input at the boundary (zod) before calling services.

## 4. Naming conventions
- **Files:** `kebab-case.ts` (`create-user.service.ts`, `user.repository.ts`).
- **Types/Interfaces/Classes/Components:** `PascalCase` (`UserProfile`, `AuthService`).
- **Variables/functions:** `camelCase`. **Constants:** `UPPER_SNAKE_CASE`.
- **React components:** `PascalCase.tsx`; one component per file.
- **Tests:** `<name>.test.ts` / `<name>.spec.ts` beside the feature in `test/`.
- **Booleans:** prefix `is/has/can/should`. **Async funcs** read as verbs (`fetchUser`).

## 5. Code quality
- **TypeScript strict.** No `any` without an inline justification comment.
- **Max ~300 lines per file.** Split when exceeded.
- Validate external input with **zod** at the controller boundary.
- Centralized error handling + request logging as middleware; no `console.log` in
  committed code (use the logger).
- No secrets in code. `.env` + `.env.example`; every env var the code reads is listed
  in `.env.example`.
- Accessibility: semantic HTML, labelled controls, visible focus, WCAG 2.1 AA contrast.

## 6. Testing
- Each feature owns its tests in `features/<feature>/test/`.
- **Unit tests** for services (business logic, edge cases, error paths).
- **Integration tests** for controllers/routes and repository behavior (test DB or mocks).
- **Component tests** for UI-focused tasks (React Testing Library).
- Each PRD acceptance criterion maps to at least one test.
- Tests must assert real behavior — no always-green placeholders.
- Gate before commit: `tsc --noEmit` clean, lint clean, `npm test` green.

## 7. Git commit style
- Commit at **function / logical-unit granularity** — small, focused commits.
- Message = **imperative** summary line (≤72 chars), optional body explaining *why*.
  - e.g. `Add user registration service with email validation`
- **Do NOT add a `Co-Authored-By` trailer.**
- One concern per commit; don't mix refactor + feature + formatting.
- Push to `origin` when a remote exists; otherwise commit locally.

## 8. Hard constraints
- The pipeline **never deploys**. No deploy configs, CI/CD deploy jobs, or deploy
  commands. Deployment is advice only, in `docs/DEPLOYMENT_ADVICE.md`.
- UI references are **inspiration only** — never copy designs, brands, or assets.
- Developers have **no web access**; all context comes from `docs/`.
