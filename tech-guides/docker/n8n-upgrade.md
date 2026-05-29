# n8n Docker Upgrade Guide (SQLite Safe Mode)

This guide exists so upgrades stay boring.

You are running n8n on Docker with SQLite. That means version control matters.

---

## Core Rule

Do NOT use `latest`.

Always pin a version.

SQLite does not tolerate uncontrolled jumps.

---

## Current Baseline

Example:

```yaml
image: n8nio/n8n:2.4.6
```

Keep this pinned until you intentionally upgrade.

---

## Upgrade Flow (Safe)

### 1. Check current running version

```bash
docker exec -it n8n-n8n-1 node -e "console.log(require('/usr/local/lib/node_modules/n8n/package.json').version)"
```

Write this down. Example: 2.4.6

### 2. Get list of released versions

```bash
curl -s https://api.github.com/repos/n8n-io/n8n/releases | grep '"tag_name"' | head -n 10
```

---

### 3. Backup n8n data (required)

```bash
cd /opt/apps/docker/n8n
tar -czf n8n-data-backup-$(date +%Y%m%d-%H%M%S).tgz data
```

Or to add to a subfolder:

```bash
sudo tar -czf /opt/apps/docker/n8n/backups/n8n-data-backup-$(date +%Y%m%d-%H%M%S).tgz /opt/apps/docker/n8n/data
```

This protects:
- workflows
- credentials
- execution data
- SQLite database

---

### 4. Download backup to local machine

Download the backup archive to your local machine using scp or your preferred transfer method:

```bash
scp -i ~/.ssh/id_ed25519 \
USER@VM_IP:/opt/apps/docker/n8n/backups/n8n-data-backup-*.tgz \
~/Downloads/
```

### 5. Choose target version

Rules:
- Stay in major version 2
- Patch jumps inside same minor are OK
- Minor jumps must be intentional

Examples:
- 2.4.6 → 2.4.latest patch (safe)
- 2.4.x → 2.5.latest patch (safe)
- Do NOT jump across multiple minors at once

---

### 6. Update docker-compose.yml

Change ONE line only:

```yaml
image: n8nio/n8n:2.5.3
```

---

### 7. Apply upgrade

```bash
docker compose pull n8n
docker compose down
docker compose up -d
```

---

### 8. Verify startup

```bash
docker ps --filter "name=n8n-n8n-1" --format "table {{.Names}}	{{.Status}}	{{.Image}}"
docker logs --tail 50 n8n-n8n-1
```

You want:
- Container running
- No crash loop
- No SQLite errors

---

## Rollback Plan (Always Works)

If anything breaks:

1. Revert version in docker-compose.yml
2. Restart

```bash
docker compose down
docker compose up -d
```

Data stays intact.

---

## What NOT to Do

- Do not use `latest`
- Do not upgrade across major versions
- Do not mix hardened images with custom installs
- Do not rebuild images without pinning versions

---

## When You Can Relax These Rules

Only after:
- Migrating to Postgres
- Or exporting workflows and accepting rebuild risk

---

## Final Rule to Remember

Pin versions. Upgrade intentionally. Backups first.
