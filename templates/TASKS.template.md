# Tasks — <PROJECT NAME>

> Written by `wd-planner` from `docs/architecture/ARCHITECTURE.md` + `docs/architecture/DATA_MODEL.md`.
> This is the source of truth for `/wd:build-next`.

## How this file is used
- `/wd:build-next` selects the **first unchecked `[ ]` task whose dependencies are all
  `[x]`**, runs it through the build loop (backend → frontend → tests → visual QA →
  review), then commits and marks it `[x]`.
- IDs are **globally unique and ordered** so dependencies always appear earlier.
- Keep each task to roughly one build-loop pass: a thin vertical slice or a single
  layer of one feature, independently buildable and testable.

## Task format
```
- [ ] T0NN — <title>  (F#: <F#|—>; deps: <T0xx,… | none>; scope: <backend|frontend|both>;
      paths: <features/<name>/… , app/…>)
      Acceptance: <one testable line tied to the PRD acceptance criteria>
```
- `scope` tells the build loop which developer agents to run.
- `[x]` = done & committed. `[~]` = in progress / changes requested (optional).

## Status legend
- `[ ]` not started · `[~]` in progress / needs changes · `[x]` done & committed

---

## Phase 0 — Foundations
- [ ] T001 — Shared config, env loading, logger, error-handling middleware
      (F#: —; deps: none; scope: backend; paths: src/shared/)
      Acceptance: app boots; central error handler returns typed error shape; logger wired.
- [ ] T002 — Prisma client setup + base migration from schema.prisma
      (F#: —; deps: T001; scope: backend; paths: prisma/, src/shared/db)
      Acceptance: `prisma generate` succeeds; client exported; connection verified in a test.
- [ ] T003 — Base UI shell: layout, theme tokens, nav, shared components
      (F#: —; deps: none; scope: frontend; paths: app/, src/shared/ui)
      Acceptance: app renders shell at 390/768/1440px with design tokens applied.

## Phase 1 — <Feature F1 name>
- [ ] T004 — <F1> data layer: repository + types
      (F#: F1; deps: T002; scope: backend; paths: features/<f1>/repository, types)
      Acceptance: repository CRUD covered by unit tests against test DB/mocks.
- [ ] T005 — <F1> service: business logic
      (F#: F1; deps: T004; scope: backend; paths: features/<f1>/service)
      Acceptance: service enforces <rule>; edge cases + error paths unit-tested.
- [ ] T006 — <F1> API: routes + controller + validation
      (F#: F1; deps: T005; scope: backend; paths: features/<f1>/routes, controller)
      Acceptance: endpoints match ARCHITECTURE.md contract; input validated (zod); integration tests pass.
- [ ] T007 — <F1> UI: screens wired to the API with all states
      (F#: F1; deps: T006, T003; scope: frontend; paths: app/<f1>, features/<f1> ui)
      Acceptance: default/loading/empty/error/success states per UX; visual QA passes at 3 breakpoints.

## Phase 2 — <Feature F2 name>
- [ ] T008 — ...

## Phase N — Integration & polish
- [ ] T0NN — End-to-end flow for <critical journey>
      (F#: multiple; deps: <…>; scope: both)
      Acceptance: the full user journey from PRD works end to end with tests.
