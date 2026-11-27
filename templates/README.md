# templates/

Installed to `~/.claude/webdev-pipeline/templates/`. These are the canonical
skeletons every agent fills. Agents follow these structures so output stays
consistent across projects, and stack defaults live in one place.

- `CLAUDE.template.md` — per-project coding rules, folder/layer rules, naming,
  testing, and git commit style. The scaffolder drops this into the generated
  project root as `CLAUDE.md`.
- `PRD.template.md` — product requirements. Filled by `wd-requirements-analyst` → `docs/PRD.md`.
- `DESIGN_SYSTEM.template.md` — tokens + components. Filled by `wd-ui-designer` → `docs/design/UI.md`.
- `TASKS.template.md` — checkbox tasks with acceptance criteria. Filled by `wd-planner` → `docs/TASKS.md`.
- `DEPLOYMENT_ADVICE.template.md` — hosting options, costs, recommended guide, env vars.
  Filled by `wd-deployment-advisor` → `docs/DEPLOYMENT_ADVICE.md`.
- `stack/default-stack.md` — concrete versions, config snippets, and setup commands
  for the default stack. Read by the scaffolder and developers.
