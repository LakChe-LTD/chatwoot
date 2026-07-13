# LakcheLink VPS Runbook

This document covers the current LakcheLink deployment on the VPS and the local tunnel workflow for accessing Postgres and Redis from a Mac.

## Public App

- App URL: `https://support.lakchelink.com`
- Rails inside the VPS: `127.0.0.1:3000`
- Nginx terminates HTTPS and proxies to Rails

## Current VPS State

- Chatwoot is running in Docker on the VPS
- Postgres and Redis are running as Docker services
- The onboarding flag has been cleared
- The database currently contains one seeded account and sample data

## Local Tunnel Script

Use the tunnel script from the repo on your Mac:

```bash
cd /Users/nathanyinka/Desktop/chatwoot
./scripts/lakchelink_tunnel.sh up
```

If `5432` or `6379` are already busy on your Mac, use alternate local ports:

```bash
POSTGRES_LOCAL_PORT=15432 REDIS_LOCAL_PORT=16379 ./scripts/lakchelink_tunnel.sh up
```

The script opens SSH tunnels for:

- Postgres: `127.0.0.1:5432` on your Mac -> `127.0.0.1:5432` on the VPS
- Redis: `127.0.0.1:6379` on your Mac -> `127.0.0.1:6379` on the VPS

With the alternate ports above:

- Postgres: `127.0.0.1:15432`
- Redis: `127.0.0.1:16379`

Useful commands:

```bash
./scripts/lakchelink_tunnel.sh status
./scripts/lakchelink_tunnel.sh down
./scripts/lakchelink_tunnel.sh psql
./scripts/lakchelink_tunnel.sh redis
```

## Local Env File For The Tunnel Script

Create a local file at `~/.lakchelink.env` with the VPS credentials you want the tunnel script to use:

```bash
POSTGRES_USERNAME=lakchelink
POSTGRES_PASSWORD=<copy from /opt/lakchelink/.env on the VPS>
POSTGRES_DATABASE=lakchelink_production
REDIS_PASSWORD=<copy from /opt/lakchelink/.env on the VPS>
```

The script reads that file automatically when you run:

```bash
./scripts/lakchelink_tunnel.sh psql
./scripts/lakchelink_tunnel.sh redis
```

## Connect A Mac Postgres Client

Keep the tunnel running first:

```bash
./scripts/lakchelink_tunnel.sh up
```

Then configure your Postgres client on your Mac with:

- Host: `127.0.0.1`
- Port: `15432` if you used the alternate-port tunnel, otherwise `5432`
- Database: `lakchelink_production`
- Username: `lakchelink`
- Password: the value from the VPS `.env` file

Command-line check:

```bash
POSTGRES_LOCAL_PORT=15432 ./scripts/lakchelink_tunnel.sh psql
```

Examples:

- `psql`
- TablePlus
- DBeaver
- pgAdmin
- DataGrip

If the client asks for SSL, leave it off for the tunnel-based local connection.

## Connect A Redis Client

Keep the tunnel running first:

```bash
./scripts/lakchelink_tunnel.sh up
```

Then point your Redis client at:

- Host: `127.0.0.1`
- Port: `6379`
- Password: the value from the VPS `.env` file

## VPS .env Values

The live production env file is stored on the VPS at:

```bash
/opt/lakchelink/.env
```

Useful keys in that file:

- `FRONTEND_URL=https://support.lakchelink.com` or the active public URL you are serving
- `POSTGRES_DATABASE=lakchelink_production`
- `POSTGRES_USERNAME=lakchelink`
- `POSTGRES_PASSWORD=...`
- `REDIS_PASSWORD=...`

Do not expose Postgres or Redis directly to the public internet. Use the tunnel script instead.

## App Access Notes

The app shows onboarding only before the onboarding flag is cleared.

Current checks:

- `https://support.lakchelink.com/` returns the main dashboard shell
- `https://support.lakchelink.com/installation/onboarding` redirects back to `/`

## Browser Database Admin

Adminer is the simplest browser-based DB viewer for this setup.

Live access path after DNS propagation:

- URL: `https://db.lakchelink.com`
- Backend: `127.0.0.1:8081` on the VPS
- Auth: nginx basic auth
- Username: `lakchedb`
- Password: `LakcheAdminer2026!`

The older `/adminer/` path on `support.lakchelink.com` has been removed.
The subdomain config is staged on the VPS and will become live after DNS exists and certbot is run.

If you need to recreate it manually on the VPS:

```bash
cd /opt/lakchelink
docker compose -f docker-compose.production.yaml up -d adminer
```

Nginx config for the subdomain layout:

- [`deployment/nginx_adminer.conf`](../deployment/nginx_adminer.conf)

After DNS exists for `db.lakchelink.com`, enable the site and issue certbot:

```bash
sudo certbot --nginx -d db.lakchelink.com
```

## Run Commands Summary

Build and run on the VPS:

```bash
cd /opt/lakchelink
docker build --progress=plain -f docker/Dockerfile -t lakchelink:latest .
docker compose -f docker-compose.production.yaml up -d postgres redis
docker compose -f docker-compose.production.yaml run --rm rails bundle exec rails db:chatwoot_prepare
docker compose -f docker-compose.production.yaml up -d --remove-orphans
```

Check the app:

```bash
curl -I https://support.lakchelink.com/
curl -I https://support.lakchelink.com/installation/onboarding
```
