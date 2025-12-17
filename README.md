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
# Start all services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop services
docker compose down
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
| Admin Panel | http://localhost:8080 | Web-based admin interface |
| REST API | http://localhost:3000 | REST API endpoint |
| GraphQL API | http://localhost:3001 | GraphQL API endpoint |
| Prometheus | http://localhost:9090 | Metrics dashboard |
| MongoDB | localhost:27017 | Database |
| Redis | localhost:6379 | Cache |

## Default Credentials

- **Username**: `admin`
- **Password**: `admin`

⚠️ **IMPORTANT**: Change the default password immediately after first login!

## Project Structure

```
sidtech-conduit/
├── README.md              # This file
├── compose.yml            # Docker Compose configuration
├── env                    # Environment variables
├── loki.cfg.yml           # Loki logging configuration
├── prometheus.cfg.yml     # Prometheus metrics configuration
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

Edit the `env` file to customize your deployment:

```bash
# Example environment variables
CONDUIT_SERVER_URL=http://localhost:3030
MASTER_KEY=your-secret-key
```

### Docker Compose

The `compose.yml` file contains the full service configuration. Modify as needed for your deployment.

## Useful Commands

```bash
# View running containers
docker compose ps

# View logs for a specific service
docker compose logs -f conduit

# Restart a specific service
docker compose restart conduit

# Remove all containers and volumes (WARNING: deletes data)
docker compose down -v

# Update to latest images
docker compose pull
docker compose up -d
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
