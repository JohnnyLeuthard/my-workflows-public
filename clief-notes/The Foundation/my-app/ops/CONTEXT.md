# Operations

Deployment, monitoring, and operational tooling.

## What's here
- /deploy — Deployment configs, CI/CD pipelines, infrastructure-as-code
- /monitoring — Alerts, dashboards, health checks
- /scripts — Operational scripts (migrations, backups, maintenance)

## How to work here
- Test deployment changes in staging before production
- Scripts should be idempotent — safe to run more than once
- Document any manual steps required alongside automated scripts
