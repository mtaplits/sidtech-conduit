# SidTech Conduit

A self-hosted Backend-as-a-Service (BaaS) platform powered by [Conduit](https://getconduit.dev/).

## What is Conduit?

Conduit is a Firebase/Parse alternative that provides ready-made modules for common backend functionality:
- **Authentication** - User management, OAuth, JWT
- **Database** - Schema management, CRUD operations
- **Chat** - Real-time messaging
- **Email** - Email sending and templates
- **Forms** - Form handling and validation
- **Push Notifications** - Mobile push notifications
- **Storage** - File storage and management

## Prerequisites

- **Docker** - Container runtime
- **Docker Compose** - Container orchestration (included with Docker)
- **Node.js/npm** - For the Conduit CLI (optional, for management)

## Quick Start

### Option 1: Using Docker Compose directly

```bash
# Create a local env file (NOT committed)
cp env.dev.example env

# Start services (dev)
docker compose --env-file env --profile mongodb \
  -f compose.yml -f compose.dev.yml up -d

# Check status
docker compose --env-file env --profile mongodb \
  -f compose.yml -f compose.dev.yml ps

# View logs
docker compose --env-file env --profile mongodb \
  -f compose.yml -f compose.dev.yml logs -f

# Stop services
docker compose --env-file env --profile mongodb \
  -f compose.yml -f compose.dev.yml down
```

### Option 2: Using Conduit CLI

```bash
# Install CLI globally
npm install -g @conduitplatform/cli

# Start deployment
conduit deploy start

# Check status
conduit deploy status

# Stop deployment
conduit deploy stop
```

## First-Time Setup

If Docker is not installed, run the installation script:

```bash
sudo bash install-docker.sh
```

After installation, log out and back in (or run `newgrp docker`).

## Access Points

| Service | URL | Description |
|---------|-----|-------------|
| Admin Panel | http://127.0.0.1:8080 | Web-based admin interface |
| REST API | http://127.0.0.1:3000 | REST API endpoint |
| GraphQL API | http://127.0.0.1:3001 | GraphQL API endpoint |

Dev-only (when using [`sidtech-conduit/compose.dev.yml`](sidtech-conduit/compose.dev.yml:1)):
- Prometheus: `http://127.0.0.1:9090`
- Loki: `http://127.0.0.1:3100`
- MongoDB: `127.0.0.1:27017`
- Redis: `127.0.0.1:6379`

> Dev VPS note: ports are bound to `127.0.0.1` for safety. Access them via SSH port-forwarding (example):
>
> `ssh -L 8080:127.0.0.1:8080 -L 3000:127.0.0.1:3000 -L 3001:127.0.0.1:3001 user@your-vps`

## Default Credentials

- **Username**: `admin`
- **Password**: `admin`

⚠️ **IMPORTANT**: Change the default password immediately after first login!

## Project Structure

```
sidtech-conduit/
├── README.md              # This file
├── compose.yml            # Docker Compose configuration
├── compose.dev.yml        # Dev overrides (extra localhost-only ports)
├── compose.staging.yml    # Staging overrides
├── compose.prod.yml       # Production overrides
├── env                    # Local runtime env (gitignored; contains secrets)
├── loki.cfg.yml           # Loki logging configuration
├── prometheus.cfg.yml     # Prometheus metrics configuration
├── env.example            # Base env template (no secrets)
├── env.dev.example        # Dev env template (no secrets)
├── env.staging.example    # Staging env template (no secrets)
├── env.prod.example       # Prod env template (no secrets)
├── DEPLOYMENT.md          # Multi-dev + staging/prod workflow
├── install-docker.sh      # Docker installation script (Ubuntu)
└── setup-conduit.sh       # Conduit setup script
```

## Services

| Container | Purpose |
|-----------|---------|
| conduit | Core Conduit service |
| conduit-ui | Admin panel web interface |
| conduit-router | API routing service |
| conduit-database | Database module |
| conduit-authentication | Authentication module |
| conduit-authorization | Authorization module |
| conduit-mongo | MongoDB database |
| conduit-redis | Redis cache |
| conduit-prometheus | Metrics collection |
| conduit-loki | Log aggregation |

## Configuration

### Environment Variables

Create `env` from a template and customize it (the file is gitignored):

```bash
cp env.dev.example env
# then edit `env` and set real values for CORE_MASTER_KEY / GRPC_KEY
```

### Docker Compose

The `compose.yml` file contains the full service configuration. Modify as needed for your deployment.

## Useful Commands

```bash
# View running containers
docker compose --env-file env --profile mongodb -f compose.yml ps

# View logs for a specific service
docker compose --env-file env --profile mongodb -f compose.yml logs -f conduit

# Restart a specific service
docker compose --env-file env --profile mongodb -f compose.yml restart conduit

# Remove all containers and volumes (WARNING: deletes data)
docker compose --env-file env --profile mongodb -f compose.yml down -v

# Upgrade images (recommended: pin tags via PR, see DEPLOYMENT.md)
docker compose --env-file env --profile mongodb -f compose.yml pull
docker compose --env-file env --profile mongodb -f compose.yml up -d
```

## Backup & Restore

### Backup MongoDB

```bash
docker exec conduit-mongo mongodump --out /dump
docker cp conduit-mongo:/dump ./backup
```

### Restore MongoDB

```bash
docker cp ./backup conduit-mongo:/dump
docker exec conduit-mongo mongorestore /dump
```

## Resources

- [Conduit Documentation](https://getconduit.dev/docs)
- [Conduit GitHub](https://github.com/ConduitPlatform/Conduit)
- [Docker Documentation](https://docs.docker.com/)

## License

This project uses Conduit which is licensed under the Apache 2.0 License.
