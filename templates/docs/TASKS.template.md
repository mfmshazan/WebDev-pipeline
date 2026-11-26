# Tasks

## How this file is used
`/wd:build-next` takes the first unchecked `[ ]` task whose dependencies are all `[x]`,
runs it through the build loop (backend → frontend → tests → visual QA → review), then
commits and marks it `[x]`. Keep IDs globally unique and ordered so dependencies always
appear earlier.

## Task List

### Phase 0 — Foundations
- [ ] T001 — <title>  (F#: —; deps: none; paths: <paths>)
      Acceptance: <one line>

### Phase 1 — <feature>
- [ ] T002 — <title>  (F#: F1; deps: T001; paths: features/<name>/...)
      Acceptance: <one line>
