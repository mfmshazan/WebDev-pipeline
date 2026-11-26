# Default stack reference

Pin these defaults unless `docs/architecture/ARCHITECTURE.md` or `docs/research/tech.md`
justifies a deviation.

## Frontend
- **Next.js** (App Router), **TypeScript** (strict), **TailwindCSS**.
- Scaffold: `npx create-next-app@latest <app> --ts --tailwind --app --eslint --src-dir`
- Prefer server components; keep client components lean. Data fetching via server
  components / route handlers; use a typed client for mutations.
- Validation on the client boundary with **zod**.

## API
- **Node.js / Express** + **TypeScript**.
- Structure every feature as `features/<name>/{routes,controller,service,repository,types,test}`.
- Controllers validate input (zod) and shape responses/errors; services hold business
  logic (no Express/Prisma imports); repositories own all Prisma access.
- Central error handler + request logging as cross-cutting middleware.

## Database
- **PostgreSQL** + **Prisma**.
- `prisma/schema.prisma` with `provider = "postgresql"`, `generator client`.
- IDs: `cuid()`; always `createdAt @default(now())` / `updatedAt @updatedAt`.
- Commands (never run deploy/migrate automatically in advisory phases):
  `npx prisma generate`, `npx prisma migrate dev` (local only), `npx prisma studio`.

## Mobile (only when PRD requires a native app)
- **React Native** (Expo recommended). Share types via a common package where sensible.

## Testing
- Unit + integration via the project's chosen runner (e.g. Vitest/Jest + Supertest for
  API, React Testing Library for components). Tests live in each feature's `test/`.

## Quality gates
- `tsc --noEmit` clean, lint clean, tests green before a task is committed.
- Max ~300 lines per file; split when exceeded.
- `.env` + `.env.example`; never commit real secrets.
