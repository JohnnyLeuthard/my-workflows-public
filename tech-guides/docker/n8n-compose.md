# n8n Docker Compose Setup

## Overview
Docker Compose file for running n8n with Caddy reverse proxy, HTTPS, and health checks.

## Dependencies
* Docker
* Docker Compose

## Steps
1. Create a `docker-compose.yml` file in your n8n project directory
2. Add the YAML code below
3. Create a `caddy/` folder and add a `Caddyfile` for reverse proxy configuration
4. Launch the containers

## File Contents

```yaml
name: n8n
services:
  caddy:
    image: caddy:latest
    container_name: n8n-caddy-1
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    depends_on:
      - n8n
    healthcheck:
      test: ["CMD", "caddy", "version"]
      interval: 30s
      timeout: 5s
      retries: 3

  n8n:
    image: n8nio/n8n:latest
    container_name: n8n-n8n-1
    restart: unless-stopped
    env_file:
      - .env
    expose:
      - "5678"
    volumes:
      - ./data:/home/node/.n8n
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://127.0.0.1:5678/healthz"]
      interval: 30s
      timeout: 5s
      retries: 3

volumes:
  caddy_data:
  caddy_config:
```

## Verification
- Open a terminal in the directory where the docker-compose.yml file is located
- Launch the n8n Docker containers:
  
```bash
docker compose up -d
```

- Check that both containers are running and healthy:

```bash
docker ps
```

Both `n8n-caddy-1` and `n8n-n8n-1` should show STATUS as `(healthy)`.

## Notes

The health checks ensure both containers are functioning:
- Caddy health check verifies the reverse proxy is responding
- n8n health check hits the `/healthz` endpoint to confirm the service is ready

Pin the n8n version in `docker-compose.yml` if you need stability:
```yaml
image: n8nio/n8n:2.4.6
```

See the n8n Docker Upgrade guide for version pinning best practices.
