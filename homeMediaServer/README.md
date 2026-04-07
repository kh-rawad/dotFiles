# Home Media Server

A Docker Compose–based home media server stack.

## Services

| Service | Default Port | Purpose |
|---|---|---|
| [Jellyfin](https://jellyfin.org) | 8096 | Media server (movies, TV, music) |
| [Sonarr](https://sonarr.tv) | 8989 | Automated TV-show management |
| [Radarr](https://radarr.video) | 7878 | Automated movie management |
| [Prowlarr](https://prowlarr.com) | 9696 | Indexer / tracker aggregation |
| [qBittorrent](https://www.qbittorrent.org) | 8080 | Torrent download client |
| [Nginx Proxy Manager](https://nginxproxymanager.com) | 80/443/81 | Reverse proxy + SSL |

## Prerequisites

- Docker Engine ≥ 24 and Docker Compose v2 (`docker compose`)
- A host directory for config data (default: `/opt/mediaserver/config`)
- A host directory for media files (default: `/mnt/media`)

## Quick Start

### 1. Copy and edit the environment file

```bash
cp .env.example .env
```

Edit `.env` and set at minimum:

| Variable | Description |
|---|---|
| `PUID` / `PGID` | UID/GID of your user (`id -u` / `id -g`) |
| `TZ` | Your timezone, e.g. `America/New_York` |
| `CONFIG_ROOT` | Host path for service config directories |
| `MEDIA_ROOT` | Host path for your media library |

### 2. Create the required directories

```bash
source .env

mkdir -p \
  "${CONFIG_ROOT}/jellyfin" \
  "${CONFIG_ROOT}/sonarr" \
  "${CONFIG_ROOT}/radarr" \
  "${CONFIG_ROOT}/prowlarr" \
  "${CONFIG_ROOT}/qbittorrent" \
  "${CONFIG_ROOT}/nginx-proxy-manager/data" \
  "${CONFIG_ROOT}/nginx-proxy-manager/letsencrypt" \
  "${MEDIA_ROOT}/movies" \
  "${MEDIA_ROOT}/tv" \
  "${MEDIA_ROOT}/music" \
  "${MEDIA_ROOT}/downloads"
```

### 3. Start the stack

```bash
docker compose up -d
```

### 4. First-time setup

| Service | URL | Default credentials |
|---|---|---|
| Jellyfin | `http://<host>:8096` | Created on first run |
| Sonarr | `http://<host>:8989` | No auth by default |
| Radarr | `http://<host>:7878` | No auth by default |
| Prowlarr | `http://<host>:9696` | No auth by default |
| qBittorrent | `http://<host>:8080` | `admin` / check container logs |
| Nginx Proxy Manager | `http://<host>:81` | `admin@example.com` / `changeme` |

> **Security:** Change all default passwords immediately after first login.

## Useful Commands

```bash
# View running containers
docker compose ps

# Follow combined logs
docker compose logs -f

# Restart a single service
docker compose restart sonarr

# Pull latest images and recreate containers
docker compose pull && docker compose up -d

# Stop and remove containers (data is preserved in CONFIG_ROOT)
docker compose down
```

## Connecting the Services

1. **Prowlarr → Sonarr/Radarr**: In Prowlarr go to *Settings → Apps* and add both Sonarr and Radarr using their container hostnames (`sonarr:8989`, `radarr:7878`).
2. **Sonarr/Radarr → qBittorrent**: In each arr app go to *Settings → Download Clients* and add qBittorrent (`qbittorrent:8080`).
3. **Nginx Proxy Manager**: Use the admin UI on port 81 to create proxy hosts and obtain Let's Encrypt certificates for each service.

## Directory Layout

```
homeMediaServer/
├── .env.example        # template – copy to .env and fill in values
├── docker-compose.yml  # full service definitions
└── README.md           # this file
```
