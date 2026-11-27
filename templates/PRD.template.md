# Product Requirements Document — <PROJECT NAME>

> Written by `wd-requirements-analyst` from `docs/IDEA.md` + `docs/research/*`.
> This is the contract every later agent builds against. Keep it testable and scoped.

## Summary
- **Problem:** <what pain, for whom>
- **Vision:** <the one-sentence future state>
- **Target users:** <primary + secondary segments and their jobs-to-be-done>

## Goals & Non-goals
**Goals**
- G1 — <measurable goal>
- G2 — <measurable goal>

**Non-goals (explicitly not doing now)**
- <thing we are intentionally not building>

## MVP Scope
The smallest shippable slice that delivers the core value:
- <bullet list of what's in the MVP>

## Out of Scope
- <deferred features, with a note of when they'd matter>

## User Roles & Permissions
| Role | Description | Key permissions |
|------|-------------|-----------------|
| <role> | <who> | <what they can do> |

## Features
> Number every feature `F#`. Each MUST have a user story and testable acceptance
> criteria. Later agents trace work back to these IDs.

### F1 — <feature name>
- **Priority:** Must / Should / Could
- **Description:** <what it does>
- **User story:** As a `<role>`, I want `<goal>` so that `<benefit>`.
- **Acceptance Criteria:**
  - [ ] AC1 — <observable, testable condition>
  - [ ] AC2 — <edge case / error path>
- **Notes / dependencies:** <external services, other features>

### F2 — <feature name>
- ...

## Non-Functional Requirements
- **Performance:** <targets, e.g. p95 API < 300ms, LCP < 2.5s>
- **Accessibility:** WCAG 2.1 AA
- **Security:** <authn/authz model, data sensitivity, rate limiting>
- **Scale assumptions:** <expected users/traffic for the MVP>
- **Browsers / devices:** <support matrix; responsive at 390 / 768 / 1440px>
- **Compliance / privacy:** <PII, GDPR, etc. if relevant>

## Data & Entities (high level)
> Not a schema (db-designer owns that) — just the nouns the product manages.
- <Entity> — <what it represents, key attributes>

## Assumptions & Dependencies
- <assumption the plan rests on>
- <external dependency: API, service, credential the user must provide>

## Open Questions (need the user's decision)
- [ ] Q1 — <decision required before/at approval gate 1>
- [ ] Q2 — <...>

## Success Metrics
- <how we'll know the MVP worked — activation, retention, task completion, etc.>
