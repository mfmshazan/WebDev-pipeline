# Deployment Advice — <PROJECT NAME>

> Written by `wd-deployment-advisor` from the finished project (read-only).
> **This document is advice only.** The pipeline does not deploy, does not create
> deploy configs, and runs no deploy commands. All steps below are for a human to
> follow manually. Confirm live pricing via the sources at the bottom.

## Project Deployment Profile
- **Frontend:** Next.js (App Router) — <static/SSR/ISR; edge vs node runtime>
- **Backend:** Node.js/Express — <long-running service vs serverless-friendly>
- **Database:** PostgreSQL + Prisma — <size/connection-pooling needs>
- **External services:** <auth, email, storage, payments, AI, etc.>
- **Background jobs / cron / websockets:** <yes/no — affects host choice>
- **Traffic assumption for cost:** low-traffic MVP (<state requests/month, DB size>)

## Options

| Option | Frontend | Backend | Database | Est. monthly (MVP) | Best for |
|--------|----------|---------|----------|--------------------|----------|
| A — <name> | <host> | <host> | <host> | **$<low>–$<high>** | <when> |
| B — <name> | <host> | <host> | <host> | **$<low>–$<high>** | <when> |
| C — <name> | <host> | <host> | <host> | **$<low>–$<high>** | <when> |

### Option A — <name>
- **Architecture:** <how the pieces map to this host>
- **Estimated cost:** $<n>/mo at <assumption>. Free tier: <limits>.
- **Pros:** <…>
- **Cons:** <…>

### Option B — <name>
- **Architecture / cost / pros / cons:** <…>

### Option C — <name>
- **Architecture / cost / pros / cons:** <…>

## Recommended Option: <A/B/C — name>
**Why:** <fit to this project's scale, stack, budget, and ops burden; honest tradeoffs.>

## Step-by-step Deploy Guide (recommended option)
> Manual steps for the user. Replace `<…>` with real values. Do not commit secrets.

1. **Provision the database**
   - Create a PostgreSQL instance on <provider>. Note the connection string.
   - Set `DATABASE_URL` in the host's env settings.
2. **Run migrations** (from your machine against the prod DB, or the host's console)
   - `npx prisma migrate deploy`
3. **Deploy the backend (Express API)**
   - <create service, set env vars, build command `npm run build`, start `npm start`>
   - Note the public API base URL.
4. **Deploy the frontend (Next.js)**
   - <import repo / connect project>, set build command `npm run build`.
   - Set `NEXT_PUBLIC_API_URL` to the backend URL from step 3.
5. **Configure domains & HTTPS**
   - <add custom domain, DNS records, TLS is automatic on most PaaS>
6. **Post-deploy checks**
   - Health check passes, auth works, a key end-to-end flow works, logs are clean.
7. **Rollback plan**
   - <how to revert: redeploy previous build / revert commit>

## Required Environment Variables
| Variable | Purpose | Where to set | Example |
|----------|---------|--------------|---------|
| `DATABASE_URL` | Postgres connection string | backend + migrations | `postgresql://user:pass@host:5432/db` |
| `NODE_ENV` | Runtime mode | backend | `production` |
| `NEXT_PUBLIC_API_URL` | Frontend → backend base URL | frontend | `https://api.<domain>` |
| `JWT_SECRET` / session secret | Auth signing | backend | `<generated>` |
| `<SERVICE>_API_KEY` | <external service> | <where> | `<…>` |
> Mirror `.env.example`. Never commit real secrets; set them in the host's dashboard.

## Operational Notes
- **Backups:** <DB backup cadence on the chosen host>
- **Scaling:** <how to scale when traffic grows; connection pooling (PgBouncer) if serverless>
- **Monitoring/logs:** <where logs/metrics live>
- **Cost triggers:** <what pushes you past the estimate — bandwidth, DB storage, compute hours>

## Pricing Sources
- <provider> pricing — <url> — checked <YYYY-MM-DD>
- <provider> pricing — <url> — checked <YYYY-MM-DD>
