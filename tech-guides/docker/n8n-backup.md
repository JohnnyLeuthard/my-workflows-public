# n8n Backup Models Runbook

This document is a practical runbook for backing up n8n data. Each section solves a specific problem. Use only the model you need.

---

## Backup Models Overview

**Model A:** Development backups (JSON + Git)  
**Model B:** Full system safety backups  
**Model C:** Migration and provider-exit backups  
**Model D:** Regular core backups with workflow structure awareness

---

## Model A: Development and Learning Backups (JSON + Git)

Purpose:
- Frequent changes
- Learning
- Easy rollback

Includes:
- Workflows
- Optional credentials

Does not include:
- Folder structure
- Execution history

Export workflows:
```bash
docker exec -it n8n-n8n-1 n8n export:workflow --all --output=/tmp/workflows.json
```

Optional credentials:
```bash
docker exec -it n8n-n8n-1 n8n export:credentials --all --output=/tmp/credentials.json
```

List contents of the folder backed up to:
```bash
docker exec -it n8n-n8n-1 ls -l /tmp
```

Copy to host:
```bash
docker cp n8n-n8n-1:/tmp/workflows.json .
docker cp n8n-n8n-1:/tmp/credentials.json .
```

Storage:
- Git repository
- Encrypt if credentials included

---

## Model B: Full System Backup (Authoritative)

Purpose:
- Pre-upgrade rollback
- Folder preservation
- Disaster recovery

Includes:
- Workflows
- Credentials (encrypted)
- Folder structure
- Database
- Binary data

Does not include:
- .env
- Encryption key

Backup:
```bash
tar -czf n8n-full-backup-$(date +%Y%m%d-%H%M%S).tgz data
```

Encrypt:
```bash
gpg --symmetric --cipher-algo AES256 n8n-full-backup-*.tgz
rm n8n-full-backup-*.tgz
```

Restore:
```bash
gpg n8n-full-backup-*.tgz.gpg
tar -xzf n8n-full-backup-*.tgz
```

Restart n8n after restore.

---

## Model C: Core Migration Backup (Workflows + Credentials)

Purpose:
- Move to a new VM
- Change providers
- Clean rebuild

Includes:
- Workflows (JSON)
- Credentials (JSON)

Does not include:
- Folder structure
- Database
- Logs

Export:
```bash
docker exec -it n8n-n8n-1 n8n export:workflow --all --output=/tmp/workflows.json
docker exec -it n8n-n8n-1 n8n export:credentials --all --output=/tmp/credentials.json
```

Copy:
```bash
docker cp n8n-n8n-1:/tmp/workflows.json .
docker cp n8n-n8n-1:/tmp/credentials.json .
```

Bundle:
```bash
tar -czf n8n-core-backup-$(date +%Y%m%d-%H%M%S).tgz workflows.json credentials.json
```

Encrypt:
```bash
gpg --symmetric --cipher-algo AES256 n8n-core-backup-*.tgz
rm n8n-core-backup-*.tgz
```

Restore:
```bash
gpg n8n-core-backup-*.tgz.gpg
tar -xzf n8n-core-backup-*.tgz
```

Import:
```bash
docker exec -it n8n-n8n-1 n8n import:workflow --input=workflows.json
docker exec -it n8n-n8n-1 n8n import:credentials --input=credentials.json
```

---

## Model D: Regular Core Backups With Structure Awareness

Important note:
n8n export does not reliably preserve folder paths. Folders are UI metadata. Tags are preserved.

Recommended approach:
- Use naming conventions
- Use tags consistently
- Periodically take Model B backups to preserve folders

---

## Security Notes

Critical fact about full backups:
Credentials inside n8n are encrypted at rest, but the encryption key lives in the same data directory. Anyone with both can decrypt credentials.

Treat full backups (Model B) as sensitive secrets.

Best practices:
- Encrypt all backups at rest
- Never store `.env` with backups
- Store `N8N_ENCRYPTION_KEY` separately and securely
- Test restores periodically
- Never commit exports to GitHub

---

## Final Advice

Use:
- Model A daily
- Model B before upgrades
- Model C before migrations
- Model D for long-term hygiene

Dry-run restores locally until boring. That is stability.
