# Deployment & Environments (dev / staging / prod)

This repo is an **operations wrapper** around Conduit’s published Docker images (it is not the Conduit source code).

The goal is to make it safe for:
- multiple developers to run their own instances,
- a staging environment,
- a production environment,
without committing secrets.

## Key rules

1) **Never commit secrets**
- The runtime env file is `env` and is **gitignored** (see [`sidtech-conduit/.gitignore`](sidtech-conduit/.gitignore:1)).
- Commit only templates: [`sidtech-conduit/env.example`](sidtech-conduit/env.example:1), [`sidtech-conduit/env.dev.example`](sidtech-conduit/env.dev.example:1), [`sidtech-conduit/env.staging.example`](sidtech-conduit/env.staging.example:1), [`sidtech-conduit/env.prod.example`](sidtech-conduit/env.prod.example:1).

2) **Do not publish internal ports in staging/prod**
- Base compose publishes only localhost-bound ports intended for a reverse proxy (nginx) to reach.
- Dev-only port exposure is in [`sidtech-conduit/compose.dev.yml`](sidtech-conduit/compose.dev.yml:1).

3) **Pin image versions**
- Avoid `latest` so dev/staging/prod run the same bits.
- Update tags intentionally via PR (see templates above).

## Compose files

- Base (shared): [`sidtech-conduit/compose.yml`](sidtech-conduit/compose.yml:1)
- Dev override: [`sidtech-conduit/compose.dev.yml`](sidtech-conduit/compose.dev.yml:1)
- Staging override: [`sidtech-conduit/compose.staging.yml`](sidtech-conduit/compose.staging.yml:1)
- Prod override: [`sidtech-conduit/compose.prod.yml`](sidtech-conduit/compose.prod.yml:1)

## Local/dev setup

1. Create your local env file (NOT committed):
   ```bash
   cp env.dev.example env
   ```
2. Edit `env` and set `CORE_MASTER_KEY` and `GRPC_KEY` to strong random values.
3. Bring the stack up:
   ```bash
   docker compose --env-file env --profile mongodb \
     -f compose.yml -f compose.dev.yml up -d
   ```

On a dev VPS, keep everything bound to `127.0.0.1` and access via SSH tunnels.

## Staging setup

1. On the staging server, create `env` from template:
   ```bash
   cp env.staging.example env
   ```
2. Set real hostnames in `*_DEFAULT_HOST_URL`.
3. Set real secrets.
4. Deploy:
   ```bash
   docker compose --env-file env --profile mongodb \
     -f compose.yml -f compose.staging.yml up -d
   ```

## Production setup

Same as staging, but using [`sidtech-conduit/env.prod.example`](sidtech-conduit/env.prod.example:1) and [`sidtech-conduit/compose.prod.yml`](sidtech-conduit/compose.prod.yml:1).

## Branching & GitHub environments

Recommended lightweight model:
- `main` → production
- `staging` branch → staging
- feature branches → PRs into `staging` (and then promote to `main`)

Use GitHub “Environments” (staging/prod) to store deployment secrets (SSH key, server host, etc.) and require approvals for production.

## Upgrading Conduit

1. Bump `IMAGE_TAG` / `UI_IMAGE_TAG` in the env templates (example: [`sidtech-conduit/env.example`](sidtech-conduit/env.example:1)).
2. Open a PR.
3. CI should validate compose config.
4. Merge to `staging`, deploy and verify.
5. Promote to `main` for production.

